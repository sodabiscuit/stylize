//
//  StylizeLayoutFlexGeometry.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/25/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//


typedef enum {
    StylizeLayoutFlexDirectionRow,
    StylizeLayoutFlexDirectionRowReverse,
    StylizeLayoutFlexDirectionColumn,
    StylizeLayoutFlexDirectionColumnReverse,
} StylizeLayoutFlexDirection;

typedef enum {
    StylizeLayoutFlexJustifyContentFlexStart,
    StylizeLayoutFlexJustifyContentFlexEnd,
    StylizeLayoutFlexJustifyContentCenter,
    StylizeLayoutFlexJustifyContentSpaceBetween,
    StylizeLayoutFlexJustifyContentSpaceAround,
} StylizeLayoutFlexJustifyContent;

typedef enum {
    StylizeLayoutFlexAlignFlexStart,
    StylizeLayoutFlexAlignFlexEnd,
    StylizeLayoutFlexAlignCenter,
    StylizeLayoutFlexAlignBaseline,
    StylizeLayoutFlexAlignStretch,
} StylizeLayoutFlexAlign;

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