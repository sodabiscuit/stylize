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

- (BOOL)isEnabled {
    UIControl *control = (UIControl *)self.view;
    return control.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    UIControl *control = (UIControl *)self.view;
    control.enabled = enabled;
}

- (BOOL)isHighlighted {
    UIControl *control = (UIControl *)self.view;
    return control.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
    UIControl *control = (UIControl *)self.view;
    control.highlighted = highlighted;
}

- (BOOL)isSelected {
    UIControl *control = (UIControl *)self.view;
    return control.selected;
}

- (void)setSelected:(BOOL)selected {
    UIControl *control = (UIControl *)self.view;
    control.selected = selected;
}

@end
