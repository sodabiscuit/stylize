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

@interface StylizeNode()

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;
@property (nonatomic,readwrite,assign) BOOL isDimensionSet;
@property (nonatomic,assign) BOOL hasLayout;

@end

@implementation StylizeNode

#pragma mark - LifeCycle

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    _subnodes = nil;
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyLayout"];
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyOther"];
}

- (instancetype)initWithViewClass:(Class)viewClass {
    if (self=[super init]) {
        NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
        [self makeDefaultProperties];
        _view = [[viewClass alloc] initWithFrame:CGRectZero];
        [self createCSSRuleObserver];
    }
    return self;
}

- (instancetype)initWithViewClass:(Class)viewClass defaultFrame:(CGRect)frame  {
    if (self=[super init]) {
        NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
        [self makeDefaultProperties];
        _view = [[viewClass alloc] initWithFrame:frame];
        _frame = frame;
        _CSSRule.width = _frame.size.width;
        _CSSRule.height = _frame.size.height;
        [self createCSSRuleObserver];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    if (self=[super init]) {
        [self makeDefaultProperties];
        _view = view;
        _frame = view.frame;
        _CSSRule.width = _frame.size.width;
        _CSSRule.height = _frame.size.height;
        [self createCSSRuleObserver];
    }
    return self;
}

- (void)makeDefaultProperties {
    _hasLayout = NO;
    _layoutType = StylizeLayoutTypeFlex;
    _isDimensionSet = NO;
    _frame = CGRectZero;
    _subnodes = [NSArray array];
    _CSSRule = [[StylizeCSSRule alloc] init];
}

- (void)createCSSRuleObserver {
    [_CSSRule addObserver:self
forKeyPath:@"observerPropertyLayout" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
    [_CSSRule addObserver:self
forKeyPath:@"observerPropertyOther" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
}

#pragma mark - Setter and Getter

- (CGFloat)width {
    return self.CSSRule.width;
}

- (void)setWidth:(CGFloat)width {
    self.CSSRule.width = width;
}

- (CGFloat)height {
    return self.CSSRule.height;
}

- (void)setHeight:(CGFloat)height {
    self.CSSRule.height = height;
}

- (StylizeMargin)margin {
    return self.CSSRule.margin;
}

- (void)setMargin:(StylizeMargin)margin {
    self.CSSRule.margin = margin;
}

- (void)setPadding:(StylizePadding)padding {
    _padding = padding;
}

#pragma mark - Public Method

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
        [self layout];
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

- (void)applyCSSRule:(StylizeCSSRule *)CSSRule {
    //TODO
}

- (void)applyCSSRaw:(NSString *)CSSRaw {

}

- (void)layout {
    _hasLayout = YES;
    if (self.layoutType == StylizeLayoutTypeFlex) {
        if ([self respondsToSelector:@selector(layoutFlexbox)]) {
            [self performSelector:@selector(layoutFlexbox) withObject:nil];
        }
    }
}

#pragma mark - SuperClass Method and Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == PrivateKVOContext) {
        if ([keyPath isEqualToString:@"observerPropertyLayout"]) {
            if (_hasLayout) {
                [self layout];
            }
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


@end
