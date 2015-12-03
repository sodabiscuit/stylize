//
//  StylizeCSSRule.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylizeGeometry.h"
#import "StylizeLayoutFlexGeometry.h"

#define kStylizeNofificationStyleDimension @"kStylizeNofificationStyleDimension"
#define kStylizeNofificationStylePosition @"kStylizeNofificationStylePosition"
#define kStylizeNofificationStyleNormal @"kStylizeNofificationStyleNormal"

@protocol StylizeNodeProtocol;

@interface StylizeCSSRule : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic,assign) id observerPropertyOther;
@property (nonatomic,assign) id observerPropertyLayout;
@property (nonatomic,assign) id observerPropertyAll;

@property (nonatomic,assign) StylizePositionType position;
@property (nonatomic,assign) StylizeDisplay display;
@property (nonatomic,assign) StylizeVisibility visibility;

/**
 *  uuid信息
 */
@property (nonatomic,strong) NSString *ruleUUID;

@property (nonatomic,assign) StylizeOverflow overflow;
@property (nonatomic,assign) StylizeOverflowSkeleton overflowX;
@property (nonatomic,assign) StylizeOverflowSkeleton overflowY;

@property (nonatomic,readonly,assign) CGSize maxSize;
@property (nonatomic,readonly,assign) CGSize minSize;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat minWidth;
@property (nonatomic,assign) CGFloat maxWidth;
@property (nonatomic,assign) BOOL widthAuto;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat minHeight;
@property (nonatomic,assign) CGFloat maxHeight;
@property (nonatomic,assign) BOOL heightAuto;
@property (nonatomic,assign) StylizeMargin margin;
@property (nonatomic,assign) BOOL marginAuto;
@property (nonatomic,assign) CGFloat marginTop;
@property (nonatomic,assign) BOOL marginTopAuto;
@property (nonatomic,assign) CGFloat marginBottom;
@property (nonatomic,assign) BOOL marginBottomAuto;
@property (nonatomic,assign) CGFloat marginLeft;
@property (nonatomic,assign) BOOL marginLeftAuto;
@property (nonatomic,assign) CGFloat marginRight;
@property (nonatomic,assign) CGFloat marginRightAuto;
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
@property (nonatomic,readonly,assign) StylizeLayoutFlexDirection flexCrossDirection;
@property (nonatomic,assign) StylizeLayoutFlexJustifyContent justifyContent;
@property (nonatomic,assign) StylizeLayoutFlexAlign alignItems;
@property (nonatomic,assign) StylizeLayoutFlexFlexWrap flexWrap;
@property (nonatomic,assign) StylizeLayoutFlexAlign alignContent;
@property (nonatomic,assign) StylizeLayoutFlexFlow flexFlow;

@property (nonatomic,assign) StylizeLayoutFlexAlign alignSelf;
@property (nonatomic,assign) NSInteger order;
@property (nonatomic,assign) NSInteger flexShrink;
@property (nonatomic,assign) NSInteger flexBasis;
@property (nonatomic,assign) NSInteger flexGrow;
@property (nonatomic,assign) NSInteger flex;

@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,assign) StylizeTextAlign *textAlign;

- (BOOL)isRuleDefined:(NSString *)ruleKey;
- (void)updateRuleFromDictionay:(NSDictionary *)ruleDictionary;
- (void)updateRuleFromRaw:(NSString *)ruleRaw;
- (void)updateRuleFromRule:(StylizeCSSRule *)rule;

@end
