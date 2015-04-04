//
//  StylizeNode+Flexbox.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"

@interface StylizeNode(Flexbox)

/**
 *  是否为Flex布局中的可扩展尺寸节点
 *
 *  @return 如果是返回YES，反之返回NO
 */
- (BOOL)isFlex;
/**
 *  是否自动折行
 *
 *  @return 如果是返回YES，反之返回NO
 */
- (BOOL)isFlexWrap;
/**
 *  手动触发位置计算
 */
- (void)layoutFlexbox;

/**
 *  是否为横向布局
 *
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isHorizontalDirection:(StylizeLayoutFlexDirection)direction;
/**
 *  是否为纵向布局
 *
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isVerticalDirection:(StylizeLayoutFlexDirection)direction;
/**
 *  是否CSS规则中已定义width或height
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isDimensionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  是否CSS规则中已定义widthAuto或者heightAuto
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isDimensionAutoDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  是否已经主动或者被动设置过width和height
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isNodeDimensionSet:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  是否CSS规则中已定义left、right、top、bottom位置信息
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *  @param location  StylizeNodeBoxLocationtype枚举类型
 *
 *  @return 如果是返回YES，反之
 */
+ (BOOL)isPositionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;
/**
 *  获取CSS规则中的位置信息
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 返回规则中定义的width或者height信息
 */
+ (CGFloat)getDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  获取frame中的size信息
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 返回frame.size.width或者frame.size.height
 */
+ (CGFloat)getNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  设置节点的frame.size信息
 *
 *  @param node      StylizeNode类型节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *  @param value     width或者height的值
 */
+ (void)setNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value;
/**
 *  获取节点的frame.origin信息
 *
 *  @param node      StylizeNode节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 返回frame.origin.x或者frame.origin.y信息
 */
+ (CGFloat)getNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  设置节点的frame.origin信息
 *
 *  @param node      StylizeNode节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *  @param value     x或者y的值
 */
+ (void)setNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value;
/**
 *  获取CSS规则中的前置border+padding+margin之和
 *
 *  @param node      StylizeNode节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 前置border+padding+margin之和
 */
+ (CGFloat)getLeading:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
/**
 *  获取CSS规则中的前置border和padding之和
 *
 *  @param node      StylizeNode节点
 *  @param direction StylizeLayoutFlexDirection枚举类型
 *
 *  @return 前置border和padding之和
 */
+ (CGFloat)getTrailing:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getPaddingandBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getPaddingandBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType        )location;
+ (CGFloat)getMargin:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getMargin:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;
+ (CGFloat)getPadding:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getPadding:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;
+ (CGFloat)getBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;
+ (CGFloat)getPosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;

@end
