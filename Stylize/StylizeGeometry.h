//
//  StylizeGeometry.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    StylizeLayoutTypeDefault,
    StylizeLayoutTypeFlex,
    StylizeLayoutTypeFlexInline,
} StylizeLayoutType;

typedef enum {
    StylizeLayoutFlexDirectionRow,
    StylizeLayoutFlexDirectionColumn,
} StylizeLayoutFlexDirection;

typedef enum {
    StylizeLayoutFlexJustifyContentFlexStart,
    StylizeLayoutFlexJustifyContentFlexEnd,
    StylizeLayoutFlexJustifyContentCenter,
    StylizeLayoutFlexJustifyContentSpaceBetween,
    StylizeLayoutFlexJustifyContentSpaceAround,
} StylizeLayoutFlexJustifyContent;

typedef enum {
    StylizeLayoutFlexAlignItemsFlexStart,
    StylizeLayoutFlexAlignItemsFlexEnd,
    StylizeLayoutFlexAlignItemsCenter,
    StylizeLayoutFlexAlignItemsBaseline,
    StylizeLayoutFlexAlignItemsStretch,
} StylizeLayoutFlexAlignItems;

typedef enum {
    StylizeLayoutFlexFlexWrapNowrap,
    StylizeLayoutFlexFlexWrapWrap,
    StylizeLayoutFlexFlexWrapReserve,
} StylizeLayoutFlexFlexWrap;

typedef enum {
    StylizeLayoutFlexAlignContentStretch,
    StylizeLayoutFlexAlignContentFlexStart,
    StylizeLayoutFlexAlignContentFlexEnd,
    StylizeLayoutFlexAlignContentCenter,
    StylizeLayoutFlexAlignContentSpaceBetween,
    StylizeLayoutFlexAlignContentSpaceAround,
} StylizeLayoutFlexAlignContent;

typedef struct {
    StylizeLayoutFlexDirection direction;
    StylizeLayoutFlexFlexWrap flexWrap;
} StylizeLayoutFlexFlow;


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
