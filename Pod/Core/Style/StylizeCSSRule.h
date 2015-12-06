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

@class StylizeCSSRule;

@interface StylizeCSSRule : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, strong) NSString *ruleUUID;

@property (nonatomic, assign) StylizePositionType position;
@property (nonatomic, assign) StylizeDisplay display;
@property (nonatomic, assign) StylizeVisibility visibility;

@property (nonatomic, assign) StylizeOverflow overflow;
@property (nonatomic, assign) StylizeOverflowSkeleton overflowX;
@property (nonatomic, assign) StylizeOverflowSkeleton overflowY;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, readonly, assign) CGSize maxSize;
@property (nonatomic, readonly, assign) CGSize minSize;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) BOOL widthAuto;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat minHeight;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) BOOL heightAuto;
@property (nonatomic, assign) StylizeMargin margin;
@property (nonatomic, assign) BOOL marginAuto;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) BOOL marginTopAuto;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) BOOL marginBottomAuto;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) BOOL marginLeftAuto;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) CGFloat marginRightAuto;
@property (nonatomic, assign) StylizePadding padding;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;

@property (nonatomic, assign) StylizeBorder border;

@property (nonatomic, assign) StylizeBorderSkeleton borderTop;
@property (nonatomic, assign) CGFloat borderTopWidth;
@property (nonatomic, assign) StylizeBorderType borderTopStyle;
@property (nonatomic, strong) UIColor *borderTopColor;

@property (nonatomic, assign) StylizeBorderSkeleton borderBottom;
@property (nonatomic, assign) CGFloat borderBottomWidth;
@property (nonatomic, assign) StylizeBorderType borderBottomStyle;
@property (nonatomic, strong) UIColor *borderBottomColor;

@property (nonatomic, assign) StylizeBorderSkeleton borderLeft;
@property (nonatomic, assign) CGFloat borderLeftWidth;
@property (nonatomic, assign) StylizeBorderType borderLeftStyle;
@property (nonatomic, strong) UIColor *borderLeftColor;

@property (nonatomic, assign) StylizeBorderSkeleton borderRight;
@property (nonatomic, assign) CGFloat borderRightWidth;
@property (nonatomic, assign) StylizeBorderType borderRightStyle;
@property (nonatomic, strong) UIColor *borderRightColor;

@property (nonatomic, assign) StylizeLayoutFlexDirection flexDirection;
@property (nonatomic, assign) StylizeLayoutFlexJustifyContent justifyContent;
@property (nonatomic, assign) StylizeLayoutFlexAlign alignItems;
@property (nonatomic, assign) StylizeLayoutFlexAlign alignContent;
@property (nonatomic, assign) StylizeLayoutFlexAlign alignSelf;
@property (nonatomic, assign) StylizeLayoutFlexFlexWrap flexWrap;
@property (nonatomic, assign) StylizeLayoutFlexFlow flexFlow;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger flexShrink;
@property (nonatomic, assign) NSInteger flexBasis;
@property (nonatomic, assign) NSInteger flexGrow;
@property (nonatomic, assign) NSInteger flex;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat opacity;

@property (nonatomic, assign) StylizeTextAlign textAlign;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic, assign) NSInteger fontWeight;
@property (nonatomic, assign) UIFont *font;

+ (NSArray *)getLayoutAffectedRuleKeys;
+ (NSArray *)getRenderAffectedRuleKeys;
+ (NSArray *)getBothAffectedRuleKeys;
+ (NSArray *)getUnAffectedRuleKeys;

- (void)updateRuleFromDictionay:(NSDictionary *)ruleDictionary;
- (void)updateRuleFromRaw:(NSString *)ruleRaw;
- (void)updateRuleFromRule:(StylizeCSSRule *)rule;
- (void)updatePositionAndDimensionFromRect:(CGRect)rect;

@end
