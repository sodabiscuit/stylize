//
//  StylizeLayoutFlexGeometry.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/25/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//


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
