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
 *  布局类型
 */
@property (nonatomic,assign) StylizeLayoutType layoutType;
/**
 *  位置
 */
@property (nonatomic,assign) StylizePositionType position;
/**
 *  样式
 */
@property (nonatomic,copy) StylizeCSSRule *cssRule;
/**
 *  父节点
 */
@property (nonatomic,readonly,strong) StylizeNode *supernode;
/**
 *  子节点列表
 */
@property (nonatomic,readonly,strong) NSArray *subnodes;
/**
 *  节点所包含的UIView或UIView子类实例
 */
@property (nonatomic,readonly,strong) UIView *view;


/**
 *  以类实例初始化
 *
 *  @param viewClass
 *
 *  @return Stylize节点
 */
- (instancetype)initWithViewClass:(Class)viewClass;
/**
 *  以UIView实例初始化
 *
 *  @param view UIView实例
 *
 *  @return Stylize节点
 */
- (instancetype)initWithView:(UIView *)view;
/**
 *  添加子节点，位置为最后一个
 *
 *  @param subnode 需要添加的子节点
 */
- (void)addSubnode:(StylizeNode *)subnode;
/**
 *  在某原有节点之前插入新节点
 *
 *  @param subnode 新增节点
 *  @param before  新增节点在其之前的节点
 */
- (void)insertSubnode:(StylizeNode *)subnode before:(StylizeNode *)before;
/**
 *  在某原有节点之后插入新节点
 *
 *  @param subnode 新增节点
 *  @param after   新增节点在其之后的节点
 */
- (void)insertSubnode:(StylizeNode *)subnode after:(StylizeNode *)after;
/**
 *  插入新节点在指定位置
 *
 *  @param subnode 新增节点
 *  @param index   位置下标值
 */
- (void)insertSubnode:(StylizeNode *)subnode atIndex:(NSInteger)index;
/**
 *  使用新节点替换原有节点
 *
 *  @param subnode            新增节点
 *  @param replacementSubnode 原有节点
 */
- (void)replaceSubnode:(StylizeNode *)subnode withSubnode:(StylizeNode *)replacementSubnode;
/**
 *  从父节点移除
 */
- (void)removeFromSupernode;

@end
