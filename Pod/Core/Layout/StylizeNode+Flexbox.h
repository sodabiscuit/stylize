//
//  StylizeNode+Flexbox.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"

@protocol StylizeNodeFlexProtocol <NSObject>

@required

/**
 *  获取可布局子节点
 *
 *  @return 可布局子节点
 */
- (NSArray *)flexSubnodesForLayout;
/**
 *  计算尺寸
 *
 *  @param size 容器尺寸
 *
 *  @return 容器实际尺寸
 */
- (CGSize)flexComputeSize:(CGSize)aSize;
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
- (void)flexLayoutNode;
/**
 *  设置布局初始化参数
 */
- (void)flexPrepareForLayout;

@end

@interface StylizeNode(Flexbox) <StylizeNodeFlexProtocol>

@end
