//
//  StylizeLayoutFlexGeometry.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/25/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "Layout.h"

typedef enum {
    StylizeLayoutFlexDirectionRow = CSS_FLEX_DIRECTION_ROW,
    StylizeLayoutFlexDirectionRowReverse = CSS_FLEX_DIRECTION_ROW_REVERSE,
    StylizeLayoutFlexDirectionColumn = CSS_FLEX_DIRECTION_COLUMN,
    StylizeLayoutFlexDirectionColumnReverse = CSS_FLEX_DIRECTION_COLUMN_REVERSE,
} StylizeLayoutFlexDirection;

typedef enum {
    StylizeLayoutFlexJustifyContentFlexStart = CSS_JUSTIFY_FLEX_START,
    StylizeLayoutFlexJustifyContentFlexEnd = CSS_JUSTIFY_FLEX_END,
    StylizeLayoutFlexJustifyContentCenter = CSS_JUSTIFY_CENTER,
    StylizeLayoutFlexJustifyContentSpaceBetween = CSS_JUSTIFY_SPACE_BETWEEN,
    StylizeLayoutFlexJustifyContentSpaceAround = CSS_JUSTIFY_SPACE_AROUND,
} StylizeLayoutFlexJustifyContent;

typedef enum {
    StylizeLayoutFlexAlignAuto = CSS_ALIGN_AUTO,
    StylizeLayoutFlexAlignFlexStart = CSS_ALIGN_FLEX_START,
    StylizeLayoutFlexAlignFlexEnd = CSS_ALIGN_FLEX_END,
    StylizeLayoutFlexAlignCenter = CSS_ALIGN_CENTER,
    StylizeLayoutFlexAlignStretch = CSS_ALIGN_STRETCH,
} StylizeLayoutFlexAlign;

typedef enum {
    StylizeLayoutFlexFlexWrapNowrap = CSS_NOWRAP,
    StylizeLayoutFlexFlexWrapWrap = CSS_WRAP,
} StylizeLayoutFlexFlexWrap;

typedef struct {
    StylizeLayoutFlexDirection direction;
    StylizeLayoutFlexFlexWrap flexWrap;
} StylizeLayoutFlexFlow;