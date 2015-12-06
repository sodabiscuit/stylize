//
//  StylizeButtonNode.m
//  StylizeDemo
//
//  Created by Yulin Ding on 12/6/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import "StylizeButtonNode.h"

@implementation StylizeButtonNode

- (instancetype)init {
    return [self initWithView:[UIButton buttonWithType:UIButtonTypeCustom]];
}

- (void)layoutNode {
    [super layoutNode];
    UIButton *button = (UIButton *)self.view;
}

- (void)renderNode {
    [super renderNode];
    UIButton *button = (UIButton *)self.view;
}


@end
