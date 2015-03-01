//
//  StylizeGeometry.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylizeLayoutFlexGeometry.h"

typedef enum {
    StylizeNodeMeasureAuto,
} StylizeNodeMeasure;

typedef enum {
    StylizeLayoutTypeDefault,
    StylizeLayoutTypeBox,
    StylizeLayoutTypeFlex,
    StylizeLayoutTypeFlexInline,
} StylizeLayoutType;

typedef enum {
    StylizePositionTypeRelative,
    StylizePositionTypeAbsolute,
} StylizePositionType;

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

CG_INLINE StylizeMargin
StylizeMarginMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left)
{
    StylizeMargin margin;
    margin.marginTop = top;
    margin.marginRight = right;
    margin.marginBottom = bottom;
    margin.marginLeft = right;
    return margin;
}

CG_INLINE StylizePadding
StylizePaddingMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left)
{
    StylizePadding padding;
    padding.paddingTop = top;
    padding.paddingRight = right;
    padding.paddingBottom = bottom;
    padding.paddingLeft = right;
    return padding;
}