//
//  StylizeNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"
#import "StylizeNode+Flexbox.h"

static void *PrivateKVOContext = &PrivateKVOContext;

static bool Stylize_alwaysDirty(void *context) {
    return YES;
}

static css_node_t *Stylize_getChild(void *context, int i) {
    StylizeNode *node = (__bridge StylizeNode*)context;
    NSArray *children = [node flexSubnodesForLayout];
    StylizeNode *child = [children objectAtIndex:i];
    return child.node;
}

//static css_dim_t Stylize_measureNode(void *context, float width) {
//    StylizeNode *node = (__bridge StylizeNode*)context;
//    CGSize size = [node flexComputeSize:(CGSize){width, NAN}];
//    return (css_dim_t){size.width, size.height};
//}

@interface StylizeNode()

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;
@property (nonatomic,assign) BOOL hasLayout;
@property (nonatomic,readwrite,assign) css_node_t *node;

@end

@implementation StylizeNode

#pragma mark - LifeCycle

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyLayout"];
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyOther"];
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
        //    _node->measure = Stylize_measureNode;
        
        [_CSSRule addObserver:self
                   forKeyPath:@"observerPropertyLayout" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
        [_CSSRule addObserver:self
                   forKeyPath:@"observerPropertyOther" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
        
        self.CSSRule.top = _defaultFrame.origin.x;
        self.CSSRule.left = _defaultFrame.origin.y;
        self.CSSRule.width = _defaultFrame.size.width;
        self.CSSRule.height = _defaultFrame.size.height;
    }
    return self;
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
}

#pragma mark - SuperClass Method and Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (context == PrivateKVOContext) {
        if ([keyPath isEqualToString:@"observerPropertyLayout"]) {
            [self syncCSS];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLayoutEvent:(StylizeLayoutEvent *)layoutEvent {
    //TODO
}

- (void)syncCSS {
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self flexPrepareForLayout];
    }
}


@end

#pragma mark - DOM

@implementation StylizeNode(DOM)

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
    if (_supernode) {
        [_view removeFromSuperview];
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

}

- (BOOL)isVisibile {
    return self.CSSRule.visibility != StylizeVisibilityHidden && self.CSSRule.display != StylizeDisplayNone;
}

@end
