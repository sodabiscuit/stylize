//
//  StylizeScrollNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeScrollNode.h"
#import "StylizeCSSRule.h"

@interface StylizeScrollNode()

@end

@implementation StylizeScrollNode

- (instancetype)init {
    return [super initWithViewClass:[UIScrollView class]];
}

- (void)layoutNode {
    [super layoutNode];
    
    CGSize contentSize = self.frame.size;
    
    if ([self.CSSRule isRuleDefined:@"overflowX"]) {
        if (self.CSSRule.overflowX == StylizeOverflowScroll ||
            self.CSSRule.overflowX == StylizeOverflowAuto) {
            //TODO
        }
    }
    
    if ([self.CSSRule isRuleDefined:@"overflowY"]) {
        if (self.CSSRule.overflowY == StylizeOverflowScroll ||
            self.CSSRule.overflowY == StylizeOverflowAuto) {
            //TODO
        }
    }
    
    if ([_view isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)self.view).contentSize = contentSize;
    }
}

@end
