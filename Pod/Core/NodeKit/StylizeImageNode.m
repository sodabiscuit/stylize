//
//  StylizeImageNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 3/17/15.
//  Copyright (c) 2015 VizLab. All rights reserved.
//

#import "StylizeImageNode.h"

@implementation StylizeImageNode

- (instancetype)init {
    return [self initWithViewClass:[UIImageView class]];
}

- (void)renderNode {
    [super renderNode];
}

- (void)layoutNode {
    [super layoutNode];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = _image;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
}

@end
