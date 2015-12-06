//
//  StylizeImageNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeNode.h"

@interface StylizeImageNode : StylizeNode

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;

@end
