//
//  StylizeControlNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeControlNode.h"

@implementation StylizeControlNode

- (instancetype)init {
    return [self initWithViewClass:[UIControl class]];
}

- (void)layoutNode {
    [super layoutNode];
}

- (void)renderNode {
    [super renderNode];
}

@end
