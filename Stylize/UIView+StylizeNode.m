//
//  UIView+StylizeNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/24/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+StylizeNode.h"
#import "StylizeCSSRule.h"
#import "StylizeNode.h"
#import "StylizeNode+Flexbox.h"


@interface UIView()

@property (nonatomic,readwrite,strong) NSArray *subnodes;

@end

@implementation UIView(StylizeNode)

- (NSArray *)subnodes {
    NSArray *subnodes = objc_getAssociatedObject(self, @selector(subnodes));
    if (subnodes) {
        return subnodes;
    }
    
    subnodes = [NSArray array];
    objc_setAssociatedObject(self, @selector(subnodes), subnodes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return subnodes;
}

- (void)addStylizeNode:(StylizeNode *)stylizeNode {
    NSAssert(stylizeNode.view != nil, @"StylizeNode instance must own a UIView instance.");
    [self addSubview:stylizeNode.view];
    
    if (![StylizeNode isDimensionDefined:stylizeNode direction:StylizeLayoutFlexDirectionRow]) {
        [StylizeNode setNodeDimension:stylizeNode direction:StylizeLayoutFlexDirectionRow value:self.frame.size.width];
    }
    
    [stylizeNode layout];
    NSMutableArray *subnodes = [self.subnodes mutableCopy];
    [subnodes addObject:stylizeNode];
    objc_setAssociatedObject(self, @selector(subnodes), [subnodes copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
