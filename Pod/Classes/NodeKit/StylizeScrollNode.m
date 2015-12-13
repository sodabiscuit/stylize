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

- (void)renderNode {
    [super renderNode];
}

- (void)layoutNode {
    [super layoutNode];
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = self.frame.size;
}

@end
