//
//  StylizeButtonNode.m
//  StylizeDemo
//
//  Created by Yulin Ding on 12/6/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import "StylizeButtonNode.h"
#import "StylizeCSSRule.h"
#import "StylizeUtility.h"

@implementation StylizeButtonNode

- (instancetype)init {
    return [self initWithView:[UIButton buttonWithType:UIButtonTypeCustom]];
}

- (void)layoutNode {
    [super layoutNode];
}

- (void)renderNode {
    [super renderNode];
    
    UIButton *button = (UIButton *)self.view;
    
    if (self.CSSRule.backgroundColorSelected) {
        [button setBackgroundImage:[StylizeColorUtility createImageWithColor:self.CSSRule.backgroundColorSelected] forState:UIControlStateSelected];
    }
    
    if (self.CSSRule.backgroundColorHighlighted) {
        [button setBackgroundImage:[StylizeColorUtility createImageWithColor:self.CSSRule.backgroundColorHighlighted] forState:UIControlStateHighlighted];
    }
    
    if (self.CSSRule.backgroundColorDisabled) {
        [button setBackgroundImage:[StylizeColorUtility createImageWithColor:self.CSSRule.backgroundColorDisabled] forState:UIControlStateDisabled];
    }
    
    [button setBackgroundImage:[StylizeColorUtility createImageWithColor:self.CSSRule.backgroundColor ? self.CSSRule.backgroundColor : [UIColor whiteColor]] forState:UIControlStateNormal];
    
    if (self.CSSRule.colorSelected) {
        [button setTitleColor:self.CSSRule.colorSelected forState:UIControlStateSelected];
    }
    
    if (self.CSSRule.colorHighlighted) {
        [button setTitleColor:self.CSSRule.colorHighlighted forState:UIControlStateHighlighted];
    }
    
    if (self.CSSRule.colorDisabled) {
        [button setTitleColor:self.CSSRule.colorDisabled forState:UIControlStateDisabled];
    }
    
    [button setTitleColor:self.CSSRule.color ? self.CSSRule.color : [UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state {
    UIButton *button = (UIButton *)self.view;
    [button setAttributedTitle:title forState:state];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    UIButton *button = (UIButton *)self.view;
    [button setTitle:title forState:state];
}

- (StylizeNodeQueryBlockNOI)title {
    StylizeNodeQueryBlockNOI block = ^id(id title, NSInteger state) {
        if ([title isKindOfClass:[NSAttributedString class]]) {
            [self setAttributedTitle:title forState:state];
        } else {
            [self setTitle:title forState:state];
        }
        return self;
    };
    return block;
}

@end
