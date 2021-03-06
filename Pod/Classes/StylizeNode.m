//
//  StylizeNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"
#import "StylizeCSSRule.h"
#import "StylizeNode+Flexbox.h"
#import "StylizeUtility.h"
#import "Ono.h"

typedef void (^StylizeNodeLayoutCallback)(void);

static void *PrivateKVOContext = &PrivateKVOContext;

static bool Stylize_alwaysDirty(void *context) {
    return YES;
}

static css_node_t *Stylize_getChild(void *context, int i) {
    StylizeNode *node = (__bridge StylizeNode*)context;
    NSArray *children = [node allSubnodesForLayout];
    if (i >= [children count]) {
        return nil;
    }
    StylizeNode *child = [children objectAtIndex:i];
    return child.node;
}

static css_dim_t Stylize_measureNode(void *context, float width) {
    StylizeNode *node = (__bridge StylizeNode*)context;
    CGSize size = node.measure ? node.measure(width) : node.classMeasure(width);
    return (css_dim_t){size.width, size.height};
}

@interface StylizeNode()

@property (nonatomic, readwrite, assign) CGRect frame;
@property (nonatomic, readwrite, copy) NSDictionary *attributes;
@property (nonatomic, readwrite, copy) NSSet *nodeClasses;
@property (nonatomic, readwrite, weak) StylizeNode *supernode;
@property (nonatomic, readwrite, copy) NSArray *subnodes;
@property (nonatomic, readwrite, strong) id view;
@property (nonatomic, readwrite, strong) StylizeCSSRule *CSSRule;
@property (nonatomic, readwrite, assign) css_node_t *node;

@end

@implementation StylizeNode

#pragma mark - LifeCycle

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    free_css_node(_node);
    
    [[[self.class CSSRuleClass] getLayoutAffectedRuleKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_CSSRule removeObserver:self
                      forKeyPath:obj
                         context:PrivateKVOContext];
    }];
    
    [[[self.class CSSRuleClass] getRenderAffectedRuleKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_CSSRule removeObserver:self
                      forKeyPath:obj
                         context:PrivateKVOContext];
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithViewClass:(Class)viewClass {
    UIView *view = [[viewClass alloc] initWithFrame:CGRectZero];
    return [self initWithView:view];
}

- (instancetype)initWithViewClass:(Class)viewClass
                     defaultFrame:(CGRect)frame  {
    UIView *view = [[viewClass alloc] initWithFrame:frame];
    return [self initWithView:view];
}

- (instancetype)initWithView:(UIView *)view {
    NSAssert([[view class] isSubclassOfClass:[UIView class]], @"view Class must be a UIView or a subclass of it.");
    NSAssert([[self.class CSSRuleClass] isSubclassOfClass:[StylizeCSSRule class]], @"CSSRuleClass must be a StylizeCSSRule or a subclass of it.");
    
    if (self = [self initImpl:[view class]]) {
        
        _view = view;
        _defaultFrame = view.frame;
        
        [[[self.class CSSRuleClass] getLayoutAffectedRuleKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_CSSRule addObserver:self
                       forKeyPath:obj
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:PrivateKVOContext];
        }];
        
        [[[self.class CSSRuleClass] getRenderAffectedRuleKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_CSSRule addObserver:self
                       forKeyPath:obj
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:PrivateKVOContext];
        }];
        
        [_CSSRule updatePositionAndDimensionFromRect:_defaultFrame];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(parseUnrecoginzedCSSRule:)
                                                     name:kStylizeCSSRuleParserUnrecoginzeNotification
                                                   object:nil];
    }
    return self;
}

- (instancetype)initImpl:(Class)viewClass {
    if (self = [super init]) {
        _nodeUUID = [NSString stringWithFormat:@"%@", [[[NSUUID alloc] init] UUIDString]];
        _layoutType = StylizeLayoutTypeFlex;
        _subnodes = [NSArray array];
        _CSSRule = (StylizeCSSRule *)[[[self.class CSSRuleClass] alloc] init];
        
        _node = new_css_node();
        _node->context = (__bridge void *)self;
        _node->is_dirty = Stylize_alwaysDirty;
        _node->get_child = Stylize_getChild;
        
        if (self.classMeasure) {
            _node->measure = Stylize_measureNode;
        }
    }
    
    return self;
}

- (instancetype)initWithDocument:(NSData *)document
                   andStyleSheet:(NSData *)styleSheet {
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument XMLDocumentWithData:document error:&error];
    ONOXMLElement *rootElement = doc.rootElement;
    StylizeNode *ret = [StylizeNode generateNodeWithElement:rootElement withoutView:NO];
    return ret;
}

- (instancetype)initWithDocumentURL:(NSString *)documentURL
                   andStyleSheetURL:(NSString *)styleSheetURL {
    StylizeNode *ret = [StylizeNode generateNodeWithElement:nil withoutView:NO];
    return ret;
}

+ (instancetype)generateNodeWithElement:(ONOXMLElement *)element
                            withoutView:(BOOL)withoutView {
    Class tagClass = NSClassFromString(element.tag);
    if (!tagClass) {
        return nil;
    }
    
    StylizeNode *ret = [[tagClass alloc] init];
    
    ret.content = [element stringValue].length > 0 ? [element stringValue] : nil;
    ret.attributes = element.attributes;
    [element.attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqualToString:@"id"]) {
            ret.nodeID = obj;
        } else if ([key isEqualToString:@"class"]) {
            NSString *classStr = [StylizeRegexUtility string:obj
                                                     replace:@"\\s+"
                                                        with:@","
                                                  ignoreCase:YES];
            NSArray *classArray = [classStr componentsSeparatedByString:@","];
            ret.nodeClasses = [NSSet  setWithArray:classArray];
        }
    }];
    
    [[element children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *node = [StylizeNode generateNodeWithElement:obj withoutView:withoutView];
        [ret addSubnode:node];
    }];
    
    return ret;
}

+ (instancetype)shadowNode:(NSString *)tagName {
    return [[[self class] alloc] initImpl:NSClassFromString(tagName)];
}

#pragma mark - Setter and Getter

- (CGRect)frame {
    CGFloat x = self.node->layout.position[CSS_LEFT];
    CGFloat y = self.node->layout.position[CSS_TOP];
    CGFloat w = self.node->layout.dimensions[CSS_WIDTH];
    CGFloat h = self.node->layout.dimensions[CSS_HEIGHT];
    
    x = isnan(x) ? 0 : x;
    y = isnan(y) ? 0 : y;
    w = isnan(w) ? 0 : w;
    h = isnan(h) ? 0 : h;
    
    return (CGRect){(CGPoint){x, y}, (CGSize){w, h}};
}

#pragma mark - SuperClass Method and Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context == PrivateKVOContext) {
        if ([[[self.class CSSRuleClass] getLayoutAffectedRuleKeys] indexOfObject:keyPath] != NSNotFound) {
            [self syncCSSRuleForLayout];
            if ([[[self.class CSSRuleClass] getBothAffectedRuleKeys] indexOfObject:keyPath] != NSNotFound) {
                [self renderNode];
            }
        } else if ([[[self.class CSSRuleClass] getRenderAffectedRuleKeys] indexOfObject:keyPath] != NSNotFound) {
            [self renderNode];
        } else {
            //NOTHING
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (Class)CSSRuleClass {
    return [StylizeCSSRule class];
}

+ (Class)viewClass {
    return [UIView class];
}

- (void)setMeasure:(StylizeNodeMeasureBlock)measure {
    _measure = measure;
    if (measure || self.classMeasure) {
        _node->measure = Stylize_measureNode;
    } else {
        _node->measure = nil;
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    UIView *view = (UIView *)self.view;
    view.userInteractionEnabled = userInteractionEnabled;
}

- (BOOL)isUserInteractionEnabled {
    UIView *view = (UIView *)self.view;
    return view.userInteractionEnabled;
}

- (void)setTag:(NSInteger)tag {
    UIView *view = (UIView *)self.view;
    view.tag = tag;
}

- (NSInteger)tag {
    UIView *view = (UIView *)self.view;
    return view.tag;
}

- (void)parseUnrecoginzedCSSRule:(NSNotification *)notification {
    NSString *ruleUUID = notification.object[@"ruleUUID"];
    if ([ruleUUID isEqualToString:self.CSSRule.ruleUUID]) {
        [self parseUnrecoginzedCSSRule:notification.object[@"key"] value:notification.object[@"value"]];
    }
}

@end


#pragma mark - Layout

@implementation StylizeNode(Layout)

- (CGSize)computeSizeWithDocument:(NSData *)document
                    andStyleSheet:(NSData *)styleSheet {
    NSError *error = nil;
    ONOXMLDocument *doc = [ONOXMLDocument XMLDocumentWithData:document error:&error];
    ONOXMLElement *rootElement = doc.rootElement;
    
    StylizeNode *ret = [StylizeNode generateNodeWithElement:rootElement withoutView:YES];
    [ret applyStyleSheet:styleSheet];
    [ret layoutNodeImpl];

    return ret.frame.size;
}

- (void)layoutNode {
    __weak typeof(self) weakSelf = self;
    [self layoutNodeWithCallback:^{
        [weakSelf afterLayout];
    }];
}

- (void)beforeLayout {
    [self syncCSSRuleForLayout];
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexBeforeLayout];
    }
    [self.subnodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *subnode = (StylizeNode *)obj;
        [subnode beforeLayout];
    }];
}

- (void)afterLayout {
    if (self.view) {
        ((UIView *)self.view).frame = self.frame;
        [self renderNode];
    }
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexAfterLayout];
    }
    [self.subnodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *subnode = (StylizeNode *)obj;
        [subnode afterLayout];
    }];
}

- (void)renderNode {
    UIView *view = (UIView *)self.view;
    StylizeCSSRule *CSSRule = self.CSSRule;
    
    view.backgroundColor = CSSRule.backgroundColor;
    view.hidden = CSSRule.visibility == StylizeVisibilityHidden || CSSRule.display == StylizeDisplayNone;
    view.alpha = CSSRule.opacity;
    
//    [self setRoundedCorners:UIRectCornerAllCorners radius:self.CSSRule.borderRadius];
    [self setBorderAndRadius];
}

- (void)syncCSSRuleForLayout {
    StylizeCSSRule *CSSRule = self.CSSRule;
    
    self.node->style.position_type = (int)CSSRule.position;
    
    self.node->style.position[CSS_LEFT] = CSSRule.left;
    self.node->style.position[CSS_TOP] = CSSRule.top;
    self.node->style.position[CSS_RIGHT] = CSSRule.right;
    self.node->style.position[CSS_BOTTOM] = CSSRule.bottom;
    
    self.node->style.dimensions[CSS_WIDTH] = CSSRule.width > 0 ? CSSRule.width : CSS_UNDEFINED;
    self.node->style.dimensions[CSS_HEIGHT] = CSSRule.height > 0 ? CSSRule.height : CSS_UNDEFINED;
    
    self.node->style.minDimensions[CSS_WIDTH] = CSSRule.minWidth;
    self.node->style.minDimensions[CSS_HEIGHT] = CSSRule.minHeight;
    
    self.node->style.maxDimensions[CSS_WIDTH] = CSSRule.maxWidth > 0 ? CSSRule.maxWidth : CSS_UNDEFINED;
    self.node->style.maxDimensions[CSS_HEIGHT] = CSSRule.maxHeight > 0 ? CSSRule.maxHeight : CSS_UNDEFINED;
    
    self.node->style.margin[CSS_LEFT] = CSSRule.marginLeft;
    self.node->style.margin[CSS_TOP] = CSSRule.marginTop;
    self.node->style.margin[CSS_RIGHT] = CSSRule.marginRight;
    self.node->style.margin[CSS_BOTTOM] = CSSRule.marginBottom;
    
    self.node->style.padding[CSS_LEFT] = CSSRule.paddingLeft;
    self.node->style.padding[CSS_TOP] = CSSRule.paddingTop;
    self.node->style.padding[CSS_RIGHT] = CSSRule.paddingRight;
    self.node->style.padding[CSS_BOTTOM] = CSSRule.paddingBottom;
    
    self.node->style.border[CSS_LEFT] = CSSRule.borderLeft.width;
    self.node->style.border[CSS_TOP] = CSSRule.borderTop.width;
    self.node->style.border[CSS_RIGHT] = CSSRule.borderRight.width;
    self.node->style.border[CSS_BOTTOM] = CSSRule.borderBottom.width;
    
    self.node->style.flex_direction = (int)CSSRule.flexDirection;
    self.node->style.flex_wrap = (int)CSSRule.flexWrap;
    self.node->style.flex = CSSRule.flex;
    self.node->style.align_content = (int)CSSRule.alignContent;
    self.node->style.align_items = (int)CSSRule.alignItems;
    self.node->style.align_self = (int)CSSRule.alignSelf;
    self.node->style.justify_content = (int)CSSRule.justifyContent;
}

- (NSArray *)allSubnodesForLayout {
    NSArray *ret = self.subnodes;
    if (self.layoutType == StylizeLayoutTypeFlex) {
        ret = [self flexSubnodesForLayout];
    }
    return ret;
}

- (void)layoutNodeWithCallback:(StylizeNodeLayoutCallback)callback {
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        [weakSelf layoutNodeImpl];
//        if (callback) {
//            dispatch_sync(dispatch_get_main_queue(), ^(void) {
//                callback();
//            });
//        }
//    });
    [self layoutNodeImpl];
    if (callback) {
        callback();
    }
}

- (void)layoutNodeImpl {
    [self beforeLayout];
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexLayoutNode];
    }
}

- (void)setBorderAndRadius {
    UIView *view = (UIView *)self.view;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = self.CSSRule.borderRadius.ordered[StylizeRuleOrderedTypeTop];
}

- (void)setRoundedCorners:(UIRectCorner)corners
                   radius:(StylizeOrdered)radius {
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, minx, midy);
    CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, (corners & UIRectCornerTopLeft) ? radius.ordered[StylizeRuleOrderedTypeTop] : 0);
    CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, (corners & UIRectCornerTopRight) ? radius.ordered[StylizeRuleOrderedTypeRight] : 0);
    CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, (corners & UIRectCornerBottomRight) ? radius.ordered[StylizeRuleOrderedTypeBottom] : 0);
    CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, (corners & UIRectCornerBottomLeft) ? radius.ordered[StylizeRuleOrderedTypeLeft] : 0);
    CGPathCloseSubpath(path);
    
    
    UIView *view = (UIView *)self.view;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [maskLayer setPath:path];
    [[view layer] setMask:nil];
    [[view layer] setMask:maskLayer];
    
    CFRelease(path);
}

@end

#pragma mark - DOM

@implementation StylizeNode(DOM)

- (void)addSubview:(UIView *)view {
    StylizeNode *node = [[StylizeNode alloc] initWithView:view];
    [self addSubnode:node];
}

- (void)addSubnode:(StylizeNode *)subnode {
    [self insertSubnode:subnode atIndex:[_subnodes count]];
}

- (void)insertSubnode:(StylizeNode *)subnode before:(StylizeNode *)before {
    NSAssert(before.supernode == self, @"the parent of before node should be the current node.");
    NSInteger index = [_subnodes indexOfObject:before];
    [self insertSubnode:subnode atIndex:index];
}

- (void)insertSubnode:(StylizeNode *)subnode after:(StylizeNode *)after {
    NSAssert(after.supernode == self, @"the parent of after node should be the current node.");
    NSInteger index = [_subnodes indexOfObject:after];
    [self insertSubnode:subnode atIndex:index + 1];
}

- (void)insertSubnode:(StylizeNode *)subnode atIndex:(NSInteger)index {
    if (!subnode) {
        return;
    }
    
    if (index > [_subnodes count]) {
        index = [_subnodes count];
    }
    
    if (subnode.supernode) {
        [subnode removeFromSupernode];
    }
    
    NSMutableArray *subnodes = [self.subnodes mutableCopy];
    subnode.supernode = self;
    [subnodes insertObject:subnode atIndex:index];
    
    if (self.view && subnode.view) {
        [self.view insertSubview:subnode.view atIndex:index];
    }
    
    _subnodes = [subnodes copy];
}

- (void)replaceSubnode:(StylizeNode *)subnode withSubnode:(StylizeNode *)replacement {
    NSAssert(subnode.supernode == self, @"the parent of subnode should be the current node.");
    NSInteger index = [_subnodes indexOfObject:subnode];
    
    [subnode removeFromSupernode];
    [self insertSubnode:replacement atIndex:index];
}

- (void)removeFromSupernode {
    [_view removeFromSuperview];
    if (_supernode) {
        NSMutableArray *subnodes = [_supernode.subnodes mutableCopy];
        [subnodes removeObject:self];
        _supernode.subnodes = [subnodes copy];
    }
}

- (void)addNodeClass:(NSString *)className {
    NSMutableArray *classes = [@[] mutableCopy];
    
    if (_nodeClasses) {
        classes = [[_nodeClasses allObjects] mutableCopy];
    }
    
    [classes addObject:className];
    _nodeClasses = [NSSet setWithArray:classes];
}

- (BOOL)hasNodeClass:(NSString *)className {
    if (!_nodeClasses || [_nodeClasses count] == 0) {
        return NO;
    }
    
    return [[_nodeClasses allObjects] indexOfObject:className] != NSNotFound;
}

- (id)getAttribute:(NSString *)key {
    return nil;
}

- (void)setAttribute:(NSString *)key value:(id)value {
    //TODO
}

@end

#pragma mark - CSS

@implementation StylizeNode(CSS)

- (void)applyStyleSheet:(NSData *)styleSheet {

}

- (void)applyCSSRule:(StylizeCSSRule *)CSSRule {
    //TODO
}

- (void)applyCSSRaw:(NSString *)CSSRaw {
    [self.CSSRule updateRuleFromRaw:CSSRaw];
}

- (void)applyRule:(NSString *)ruleKey
            value:(id)ruleValue {
    NSDictionary *dict = @{ruleKey : ruleValue};
    [self.CSSRule updateRuleFromDictionay:dict];
}

- (void)applyCSSDictionary:(NSDictionary *)CSSDictionary {
    [self.CSSRule updateRuleFromDictionay:CSSDictionary];
}

- (void)parseUnrecoginzedCSSRule:(NSString *)key value:(id)value {
    //TODO
}

@end
