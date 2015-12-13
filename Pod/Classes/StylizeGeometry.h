//
//  StylizeGeometry.h
//  StylizeMobile
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
    StylizeVisibilityVisible,
    StylizeVisibilityHidden,
    StylizeVisibilityCollapse,
} StylizeVisibility;

typedef enum {
    StylizeDisplayBlock,
    StylizeDisplayInline,
    StylizeDisplayNone,
} StylizeDisplay;

typedef enum {
    StylizeLayoutTypeDefault,
    StylizeLayoutTypeBox,
    StylizeLayoutTypeFlex,
    StylizeLayoutTypeFlexInline,
} StylizeLayoutType;

typedef enum {
    StylizeRuleOrderedTypeTop,
    StylizeRuleOrderedTypeRight,
    StylizeRuleOrderedTypeBottom,
    StylizeRuleOrderedTypeLeft,
} StylizeRuleOrderedType;

typedef enum {
    StylizeRuleRadiusOrderedTypeTopLeft,
    StylizeRuleRadiusOrderedTypeTopRight,
    StylizeRuleRadiusOrderedTypeBottomRight,
    StylizeRuleRadiusOrderedTypeBottomLeft,
} StylizeRuleRadiusOrderedType;

typedef enum {
//    StylizePositionTypeStatic = CSS_POSITION_RELATIVE,
    StylizePositionTypeRelative = CSS_POSITION_RELATIVE,
    StylizePositionTypeAbsolute = CSS_POSITION_ABSOLUTE,
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

typedef struct {
    CGFloat width;
    CGColorRef color;
    StylizeBorderType style;
} StylizeBorderSkeleton;


typedef struct {
  CGFloat ordered[4];
}  StylizeOrdered;

typedef struct {
    StylizeBorderSkeleton borderTop;
    StylizeBorderSkeleton borderRight;
    StylizeBorderSkeleton borderBottom;
    StylizeBorderSkeleton borderLeft;
}  StylizeBorder;

typedef struct {
    CGFloat borderTopLeft;
    CGFloat borderTopRight;
    CGFloat borderBottomRight;
    CGFloat borderBottomLeft;
}  StylizeBorderRadius;

CG_INLINE StylizeOrdered
StylizeOrderedMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left)
{
    StylizeOrdered ret;
    ret.ordered[StylizeRuleOrderedTypeTop] = top;
    ret.ordered[StylizeRuleOrderedTypeRight] = right;
    ret.ordered[StylizeRuleOrderedTypeBottom] = bottom;
    ret.ordered[StylizeRuleOrderedTypeLeft] = left;
    return ret;
}

typedef enum {
    StylizeOverflowVisible,
    StylizeOverflowHidden,
    StylizeOverflowScroll,
    StylizeOverflowAuto,
} StylizeOverflowSkeleton;

typedef struct {
    StylizeOverflowSkeleton overflowX;
    StylizeOverflowSkeleton overflowY;
    
} StylizeOverflow;

typedef enum {
    StylizeTextAlignLeft = NSTextAlignmentLeft,
    StylizeTextAlignCenter = NSTextAlignmentCenter,
    StylizeTextAlignRight = NSTextAlignmentRight,
    StylizeTextAlignJustify = NSTextAlignmentJustified,
} StylizeTextAlign;