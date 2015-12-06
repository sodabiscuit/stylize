//
//  StylizeControlNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeNode.h"

@interface StylizeControlNode : StylizeNode

@property(nonatomic,getter=isEnabled) BOOL enabled;
@property(nonatomic,getter=isSelected) BOOL selected;
@property(nonatomic,getter=isHighlighted) BOOL highlighted;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
