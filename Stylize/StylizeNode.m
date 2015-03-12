//
//  StylizeNode.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"

static void const *PrivateKVOContext;

@interface StylizeNode() {
    //NOTHING
}

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;

@property (nonatomic,strong) NSString *axisLeadingKey;
@property (nonatomic,strong) NSString *axisTrailingKey;
@property (nonatomic,strong) NSString *asixDimensionKey;

@end

@implementation StylizeNode

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    _subnodes = nil;
    [_computedCSSRule removeObserver:self forKeyPath:@"observerProperty"];
}

- (instancetype)initWithViewClass:(Class)viewClass {
    if (self=[super init]) {
        NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
        [self makeDefaultProperties];
        _view = [[viewClass alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    if (self=[super init]) {
        [self makeDefaultProperties];
        _view = view;
    }
    return self;
}

- (void)makeDefaultProperties {
    _layoutType = StylizeLayoutTypeFlex;
    _subnodes = [NSArray array];
    _computedCSSRule = [[StylizeCSSRule alloc] init];
    _computedCSSRule.node = self;
    
    [_computedCSSRule addObserver:self
forKeyPath:@"observerProperty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&PrivateKVOContext];
}

- (CGFloat)width {
    return self.computedCSSRule.width;
}

- (void)setWidth:(CGFloat)width {
    self.computedCSSRule.width = width;
    _view.frame = (CGRect){_view.frame.origin, (CGSize){width, _view.frame.size.height}};
}

- (CGFloat)height {
    return self.computedCSSRule.height;
}

- (void)setHeight:(CGFloat)height {
    self.computedCSSRule.height = height;
}

- (StylizeMargin)margin {
    return self.computedCSSRule.margin;
}

- (void)setMargin:(StylizeMargin)margin {
    self.computedCSSRule.margin = margin;
}

- (void)setPadding:(StylizePadding)padding {
    _padding = padding;
}

- (NSString *)axisLeadingKey {
    NSString *ret;
    if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRow ||
        self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRowReverse) {
        ret = @"left";
    } else if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumn ||
               self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumnReverse) {
        ret = @"top";
    }
    return ret;
}

- (NSString *)axisTrailingKey {
    NSString *ret;
    if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRow ||
        self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRowReverse) {
        ret = @"right";
    } else if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumn ||
               self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumnReverse) {
        ret = @"bottom";
    }
    return ret;
}

- (NSString *)asixDimensionKey {
    NSString *ret;
    if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRow ||
        self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionRowReverse) {
        ret = @"width";
    } else if (self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumn ||
               self.supernode.computedCSSRule.flexDirection == StylizeLayoutFlexDirectionColumnReverse) {
        ret = @"height";
    }
    return ret;
}

- (void)addSubnode:(StylizeNode *)subnode {
    NSMutableArray *subnodes = [self.subnodes mutableCopy];
    [subnodes addObject:subnode];
    _subnodes = [subnodes copy];
    
    subnode.supernode = self;
    [self.view addSubview:subnode.view];
    
    [self layout];
}

- (void)insertSubnode:(StylizeNode *)subnode before:(StylizeNode *)before {
    //TODO
}

- (void)insertSubnode:(StylizeNode *)subnode after:(StylizeNode *)after {
    //TODO
}

- (void)insertSubnode:(StylizeNode *)subnode atIndex:(NSInteger)index {
    //TODO
}

- (void)replaceSubnode:(StylizeNode *)subnode withSubnode:(StylizeNode *)replacementSubnode {
    //TODO
}

- (void)removeFromSupernode {
    //TODO
}

- (void)applyCSSRule:(StylizeCSSRule *)CSSRule {
    //TODO
}

- (void)applyCSSRaw:(NSString *)CSSRaw {

}

- (void)handleLayoutEvent:(StylizeLayoutEvent *)layoutEvent {
    //TODO
}

- (void)layout {
    [self layoutInternal];
    for (StylizeNode *subnode in self.subnodes) {
        [subnode layout];
    }
}

- (void)layoutInternal {
    _frame = CGRectMake( _computedCSSRule.left+_computedCSSRule.marginLeft, _computedCSSRule.top+_computedCSSRule.marginTop, _computedCSSRule.width, _computedCSSRule.height);
    
    
    if (self.layoutType==StylizeLayoutTypeFlex && [self.subnodes count]>0) {
        for (StylizeNode *subnode in self.subnodes) {
            if (subnode.computedCSSRule.position  == StylizePositionTypeAbsolute) {
                
            } else {
                if (self.computedCSSRule.alignItems==StylizeLayoutFlexAlignItemsStretch) {
                }
            }
        }
    }
    
    _view.frame = _frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"observerProperty"]) {
        [self layout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
