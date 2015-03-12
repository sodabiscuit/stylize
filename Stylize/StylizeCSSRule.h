//
//  StylizeCSSRule.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylizeGeometry.h"
#import "StylizeLayoutFlexGeometry.h"

@class StylizeNode;
@protocol StylizeNodeProtocol;

@interface StylizeCSSRule : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic,weak) id<StylizeNodeProtocol> node;
@property (nonatomic,assign) NSInteger observerProperty;

@property (nonatomic,assign) StylizePositionType position;
@property (nonatomic,assign) StylizeDisplay display;
@property (nonatomic,assign) StylizeVisibility visibility;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) StylizeMargin margin;
@property (nonatomic,assign) CGFloat marginTop;
@property (nonatomic,assign) CGFloat marginBottom;
@property (nonatomic,assign) CGFloat marginLeft;
@property (nonatomic,assign) CGFloat marginRight;
@property (nonatomic,assign) StylizePadding padding;
@property (nonatomic,assign) CGFloat paddingTop;
@property (nonatomic,assign) CGFloat paddingBottom;
@property (nonatomic,assign) CGFloat paddingLeft;
@property (nonatomic,assign) CGFloat paddingRight;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) StylizeBorder border;
@property (nonatomic,assign) StylizeBorderSkeleton borderTop;
@property (nonatomic,assign) StylizeBorderSkeleton borderBottom;
@property (nonatomic,assign) StylizeBorderSkeleton borderLeft;
@property (nonatomic,assign) StylizeBorderSkeleton borderRight;

@property (nonatomic,assign) StylizeLayoutFlexDirection flexDirection;
@property (nonatomic,assign) StylizeLayoutFlexJustifyContent justifyContent;
@property (nonatomic,assign) StylizeLayoutFlexAlignItems alignItems;
@property (nonatomic,assign) StylizeLayoutFlexFlexWrap flexWrap;
@property (nonatomic,assign) StylizeLayoutFlexAlignContent alignContent;
@property (nonatomic,assign) StylizeLayoutFlexFlow flexFlow;

@property (nonatomic,assign) StylizeLayoutFlexAlignSelf alignSelf;
@property (nonatomic,assign) NSInteger order;
@property (nonatomic,assign) NSInteger flexShrink;
@property (nonatomic,assign) NSInteger flexBasis;
@property (nonatomic,assign) NSInteger flexGrow;

@end
