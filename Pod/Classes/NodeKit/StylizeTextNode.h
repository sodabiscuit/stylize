//
//  StylizeLabelNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeNode.h"

@interface StylizeTextNode : StylizeNode

@property(nonatomic, copy) NSAttributedString *attributedText;
@property(nonatomic, copy) NSString *text;

@end
