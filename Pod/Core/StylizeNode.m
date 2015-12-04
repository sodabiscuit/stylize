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

static void *PrivateKVOContext = &PrivateKVOContext;

static bool Stylize_alwaysDirty(void *context) {
    return YES;
}

static css_node_t *Stylize_getChild(void *context, int i) {
    StylizeNode *node = (__bridge StylizeNode*)context;
    NSArray *children = [node allSubnodesForLayout];
    StylizeNode *child = [children objectAtIndex:i];
    return child.node;
}

//static css_dim_t Stylize_measureNode(void *context, float width) {
//    StylizeNode *node = (__bridge StylizeNode*)context;
//    CGSize size = [node flexComputeSize:(CGSize){width, NAN}];
//    return (css_dim_t){size.width, size.height};
//}

@interface StylizeNode()

@property (nonatomic, readwrite, assign) CGRect frame;
@property (nonatomic, readwrite, copy) NSArray *subnodes;
@property (nonatomic, readwrite, weak) StylizeNode *supernode;
@property (nonatomic, readwrite, strong) id view;
@property (nonatomic, readwrite, strong) StylizeCSSRule *CSSRule;
@property (nonatomic, assign) BOOL hasLayout;
@property (nonatomic, readwrite, assign) css_node_t *node;

@end

@implementation StylizeNode

#pragma mark - LifeCycle

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyLayout"];
    free_css_node(_node);
}

- (instancetype)initWithViewClass:(Class)viewClass {
    NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
    UIView *view = [[viewClass alloc] initWithFrame:CGRectZero];
    return [self initWithView:view];
}

- (instancetype)initWithViewClass:(Class)viewClass
                     defaultFrame:(CGRect)frame  {
    NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
    UIView *view = [[viewClass alloc] initWithFrame:frame];
    return [self initWithView:view];
}

- (instancetype)initWithView:(UIView *)view {
    if (self=[super init]) {
        _view = view;
        _defaultFrame = view.frame;
        
        _nodeUUID = [NSString stringWithFormat:@"%@", [[[NSUUID alloc] init] UUIDString]];
        _hasLayout = NO;
        _layoutType = StylizeLayoutTypeFlex;
        _subnodes = [NSArray array];
        _CSSRule = [[StylizeCSSRule alloc] init];
        
        _node = new_css_node();
        _node->context = (__bridge void *)self;
        _node->is_dirty = Stylize_alwaysDirty;
        _node->get_child = Stylize_getChild;
        //_node->measure = Stylize_measureNode;
        
        [_CSSRule addObserver:self
                   forKeyPath:@"observerPropertyLayout" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
        
        self.CSSRule.top = _defaultFrame.origin.x;
        self.CSSRule.left = _defaultFrame.origin.y;
        self.CSSRule.width = _defaultFrame.size.width;
        self.CSSRule.height = _defaultFrame.size.height;
    }
    return self;
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

#pragma mark - Setter and Getter

- (CGRect)frame {
    return (CGRect){(CGPoint){self.node->layout.position[CSS_LEFT], self.node->layout.position[CSS_TOP]},
                    (CGSize){self.node->layout.dimensions[CSS_WIDTH], self.node->layout.dimensions[CSS_HEIGHT]}};
}

- (void)layoutNode {
    _hasLayout = YES;
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexLayoutNode];
    }
    
    [self.subnodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *subnode = (StylizeNode *)obj;
        [subnode layoutNode];
    }];
}

#pragma mark - SuperClass Method and Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context == PrivateKVOContext) {
        if ([keyPath isEqualToString:@"observerPropertyLayout"]) {
            [self syncLayoutRules];
            [self renderNode];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)renderNode {
    UIView *view = (UIView *)self.view;
    view.backgroundColor = self.CSSRule.backgroundColor;
}

- (void)syncLayoutRules {
    self.node->style.position_type = (int)self.CSSRule.position;
    
    self.node->style.position[CSS_LEFT] = self.CSSRule.left;
    self.node->style.position[CSS_TOP] = self.CSSRule.top;
    self.node->style.position[CSS_RIGHT] = self.CSSRule.right;
    self.node->style.position[CSS_BOTTOM] = self.CSSRule.bottom;
    
    self.node->style.dimensions[CSS_WIDTH] = self.CSSRule.width > 0 ? self.CSSRule.width : CSS_UNDEFINED;
    self.node->style.dimensions[CSS_HEIGHT] = self.CSSRule.height > 0 ? self.CSSRule.height : CSS_UNDEFINED;
    
    self.node->style.minDimensions[CSS_WIDTH] = self.CSSRule.minWidth;
    self.node->style.minDimensions[CSS_HEIGHT] = self.CSSRule.minHeight;
    
    self.node->style.maxDimensions[CSS_WIDTH] = self.CSSRule.maxWidth > 0 ? self.CSSRule.maxWidth : CSS_UNDEFINED;
    self.node->style.maxDimensions[CSS_HEIGHT] = self.CSSRule.maxHeight > 0 ? self.CSSRule.maxHeight : CSS_UNDEFINED;
    
    self.node->style.margin[CSS_LEFT] = self.CSSRule.marginLeft;
    self.node->style.margin[CSS_TOP] = self.CSSRule.marginTop;
    self.node->style.margin[CSS_RIGHT] = self.CSSRule.marginRight;
    self.node->style.margin[CSS_BOTTOM] = self.CSSRule.marginBottom;
    
    self.node->style.padding[CSS_LEFT] = self.CSSRule.paddingLeft;
    self.node->style.padding[CSS_TOP] = self.CSSRule.paddingTop;
    self.node->style.padding[CSS_RIGHT] = self.CSSRule.paddingRight;
    self.node->style.padding[CSS_BOTTOM] = self.CSSRule.paddingBottom;
    
    self.node->style.border[CSS_LEFT] = self.CSSRule.borderLeft.width;
    self.node->style.border[CSS_TOP] = self.CSSRule.borderTop.width;
    self.node->style.border[CSS_RIGHT] = self.CSSRule.borderRight.width;
    self.node->style.border[CSS_BOTTOM] = self.CSSRule.borderBottom.width;
    
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexPrepareForLayout];
    }
}

- (NSArray *)allSubnodesForLayout {
    NSArray *ret = self.subnodes;
    if (self.layoutType == StylizeLayoutTypeFlex) {
        ret = [self flexSubnodesForLayout];
    }
    
    return ret;
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
    if (index > [_subnodes count]) {
        index = [_subnodes count];
    }
    
    if (subnode.supernode) {
        [subnode removeFromSupernode];
    }
    
    NSMutableArray *subnodes = [self.subnodes mutableCopy];
    subnode.supernode = self;
    [subnodes insertObject:subnode atIndex:index];
    [self.view insertSubview:subnode.view atIndex:index];
    _subnodes = [subnodes copy];
    
    if (_hasLayout) {
        [self layoutNode];
    }
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

@end

#pragma mark - CSS

@implementation StylizeNode(CSS)

- (void)applyCSSRule:(StylizeCSSRule *)CSSRule {
    //TODO
}

- (void)applyCSSRaw:(NSString *)CSSRaw {
    [self.CSSRule updateRuleFromRaw:CSSRaw];
}

- (void)applyRule:(NSString *)ruleKey
            value:(NSString *)ruleValue {
    NSDictionary *dict = @{ruleKey : ruleValue};
    [self.CSSRule updateRuleFromDictionay:dict];
}

- (void)applyCSSDictionary:(NSDictionary *)CSSDictionary {
    [self.CSSRule updateRuleFromDictionay:CSSDictionary];
}

- (BOOL)isVisibile {
    return self.CSSRule.visibility != StylizeVisibilityHidden &&
            self.CSSRule.display != StylizeDisplayNone;
}

@end
