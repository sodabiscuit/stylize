//
//  StylizeNode.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"

@interface StylizeNode() {
    //NOTHING
}

@property (nonatomic,readwrite,strong) NSMutableArray *subnodes;
@property (nonatomic,readwrite,strong) UIView *view;

@end

@implementation StylizeNode

- (instancetype)init {
    if (self=[super init]) {
        //TODO
    }
    return self;
}

- (void)dealloc {
    //TODO
}

- (instancetype)initWithViewClass:(Class)viewClass {
    if (self=[super init]) {
        NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
        _view = [[viewClass alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    if (self=[super init]) {
        _view = view;
    }
    return self;
}

- (CGRect)frame {
    if (_view) {
        return _view.frame;
    }
    return CGRectZero;
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    _view.frame = (CGRect){_view.frame.origin, (CGSize){width, _view.frame.size.height}};
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    _view.frame = (CGRect){_view.frame.origin, (CGSize){_view.frame.size.width, height}};
}

- (void)setMargin:(StylizeMargin)margin {
    _margin = margin;
}

- (void)setPadding:(StylizePadding)padding {
    _padding = padding;
}

- (void)addSubnode:(StylizeNode *)subnode {
    //TODO
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

@end
