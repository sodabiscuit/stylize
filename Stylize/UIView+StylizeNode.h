//
//  UIView+StylizeNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/24/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

@class StylizeNode;

@interface UIView(StylizeNode)

@property (nonatomic,readonly,strong) NSArray *subnodes;

- (void)addStylizeNode:(StylizeNode *)stylizeNode;

@end
