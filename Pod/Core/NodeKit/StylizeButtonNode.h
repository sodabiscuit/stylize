//
//  StylizeButtonNode.h
//  StylizeDemo
//
//  Created by Yulin Ding on 12/6/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import "StylizeControlNode.h"
#import "StylizeNode+Query.h"

@interface StylizeButtonNode : StylizeControlNode

- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state;

/**
 *  根据传入的UIControlState设置title
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNOI title;

@end
