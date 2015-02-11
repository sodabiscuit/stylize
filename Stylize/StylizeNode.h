//
//  StylizeNode.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeGeometry.h"
#import "StylizeCSSRule.h"

@interface StylizeNode : NSObject

/**
 *  宽度
 */
@property (nonatomic,assign) CGFloat width;
/**
 *  高度
 */
@property (nonatomic,assign) CGFloat height;
/**
 *  外边距
 */
@property (nonatomic,assign) StylizeMargin margin;
/**
 *  内边距
 */
@property (nonatomic,assign) StylizePadding padding;
/**
 *  边框
 */
@property (nonatomic,assign) StylizeBorder border;
/**
 *  样式
 */
@property (nonatomic,copy) StylizeCSSRule *cssRule;

@end
