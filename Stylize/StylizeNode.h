//
//  StylizeNode.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeGeometry.h"

@class StylizeCSSRule;
@class StylizeLayoutEvent;

typedef enum {
    StylizeNodeBoxLocationTypeLeading,
    StylizeNodeBoxLocationTypeTrailing,
} StylizeNodeBoxLocationType;


@protocol StylizeNodeProtocol <NSObject>

/**
 *  处理接收的布局通知
 *
 *  @param layoutEvent 布局事件
 */
- (void)handleLayoutEvent:(StylizeLayoutEvent *)layoutEvent;

@end

@interface StylizeNode : NSObject <StylizeNodeProtocol>

/**
 *  id信息
 */
@property (nonatomic,strong) NSString *nodeID;
/**
 *  uuid信息
 */
@property (nonatomic,readonly,strong) NSString *nodeUUID;
/**
 *  输出的位置信息
 */
@property (nonatomic,readonly,assign) CGRect frame;
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
//@property (nonatomic,assign) StylizePositionType position;
/**
 *  样式
 */
//@property (nonatomic,copy) StylizeCSSRule *CSSRule;
/**
 *  计算完成的样式
 */
@property (nonatomic,strong) StylizeCSSRule *CSSRule;
/**
 *  父节点
 */
@property (nonatomic,readonly,weak) StylizeNode *supernode;
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
/**
 *  添加CSS规则
 *
 *  @param CSSRule 需要增加或者覆盖的CSS规则
 */
- (void)applyCSSRule:(StylizeCSSRule *)CSSRule;
/**
 *  通过解析CSS文本添加CSS规则
 *
 *  @param CSSRaw CSS文本
 */
- (void)applyCSSRaw:(NSString *)CSSRaw;
/**
 *  手动触发位置计算
 */
- (void)layout;
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

+ (BOOL)isHorizontalDirection:(StylizeLayoutFlexDirection)direction;
+ (BOOL)isVerticalDirection:(StylizeLayoutFlexDirection)direction;
+ (BOOL)isDimensionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (BOOL)isPositionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location;
+ (CGFloat)getDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (CGFloat)getNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (void)setNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value;
+ (CGFloat)getNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
+ (void)setNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value;
+ (CGFloat)getLeading:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction;
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
