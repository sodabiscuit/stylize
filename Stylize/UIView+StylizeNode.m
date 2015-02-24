//
//  UIView+StylizeNode.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/24/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "UIView+StylizeNode.h"

@implementation UIView(StylizeNode)

- (void)addStylizeNode:(StylizeNode *)stylizeNode {
    NSAssert(stylizeNode.view != nil, @"StylizeNode instance must own a UIView instance.");
    [self addSubview:stylizeNode.view];
    stylizeNode.view.frame = CGRectMake(stylizeNode.margin.marginLeft, stylizeNode.margin.marginTop, stylizeNode.width, stylizeNode.height);
}

@end
