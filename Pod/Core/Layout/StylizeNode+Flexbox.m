//
//  StylizeNode+Flexbox.m
//  StylizeDemo
//
//  Created by Yulin Ding on 4/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode+Flexbox.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"
#import "NSLogMan.h"

@interface StylizeNode() <StylizeNodeProtocol>

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;

@end

@implementation StylizeNode(Flexbox)

#pragma mark - StylizeNodeFlexProtocol

- (BOOL)isFlex {
    return self.CSSRule.flex > 0 && (self.CSSRule.position == StylizePositionTypeRelative || self.CSSRule.position == StylizePositionTypeStatic);
}

- (BOOL)isFlexWrap {
    return self.CSSRule.flexWrap != StylizeLayoutFlexFlexWrapNowrap;
}

- (void)layoutFlexbox {
    if (!self.supernode) {
        //TODO
    }
    
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self layoutFlexSubnodes];
    }
}

- (CGSize)flexComputeSize:(CGSize)aSize {
    return aSize;
}

- (void)layoutFlexSubnodes {
}

@end
