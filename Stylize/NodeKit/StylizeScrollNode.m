//
//  StylizeScrollNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeScrollNode.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"

@interface StylizeScrollNode()

@property (nonatomic,readwrite,strong) UIScrollView *view;

@end

@implementation StylizeScrollNode

- (void)layout {
    [super layout];
    
    CGSize contentSize = self.frame.size;
    
    if ([self.CSSRule isRuleDefined:@"overflowX"]) {
        if (self.CSSRule.overflowX == StylizeOverflowScroll ||
            self.CSSRule.overflowX == StylizeOverflowAuto) {
            contentSize.width = self.computedSize.width;
        }
    }
    
    if ([self.CSSRule isRuleDefined:@"overflowY"]) {
        if (self.CSSRule.overflowY == StylizeOverflowScroll ||
            self.CSSRule.overflowY == StylizeOverflowAuto) {
            contentSize.height = self.computedSize.height;
        }
    }
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        self.view.contentSize = contentSize;
    }
}

- (void)setView:(UIScrollView *)view {
    _view = view;
}

@end
