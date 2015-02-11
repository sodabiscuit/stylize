//
//  StylizeGeometry.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat paddingTop;
    CGFloat paddingRight;
    CGFloat paddingBottom;
    CGFloat paddingLeft;
} StylizePadding;

typedef struct {
    CGFloat marginTop;
    CGFloat marginRight;
    CGFloat marginBottom;
    CGFloat marginLeft;
} StylizeMargin;

typedef enum {
    StylizeBorderTypeSolid,
    StylizeBorderTypeDash,
    StylizeBorderTypeDotted
} StylizeBorderType;

struct StyizeBorderSkeleton {
    CGFloat width;
    CGColorRef color;
    StylizeBorderType type;
};

typedef struct {
    CGFloat borderTop;
    CGFloat borderRight;
    CGFloat borderBottom;
    CGFloat borderLeft;
}  StylizeBorder;
