//
//  StylizeNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeGeometry.h"
#import "Layout.h"

@class StylizeCSSRule;
@class StylizeLayoutEvent;

@interface StylizeNode : NSObject {
    @protected
    id _view;
}

/**
 *  id信息
 */
@property (nonatomic,strong) NSString *nodeID;

/**
 *  class选择符信息
 */
@property (nonatomic,readonly,strong) NSSet *nodeClass;

/**
 *  uuid信息
 */
@property (nonatomic,readonly,strong) NSString *nodeUUID;

/**
 *  输出的位置信息
 */
@property (nonatomic,readonly,assign) CGRect frame;

/**
 *  初始化尺寸
 */
@property (nonatomic,readonly,assign) CGRect defaultFrame;

/**
 *  布局类型
 */
@property (nonatomic,assign) StylizeLayoutType layoutType;

/**
 *  样式
 */
@property (nonatomic,readonly,strong) StylizeCSSRule *CSSRule;

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
@property (nonatomic,readonly,strong) id view;

/**
 *  flexbox布局节点
 */
@property (nonatomic,readonly,assign) css_node_t *node;

/**
 *  以类初始化
 *
 *  @param viewClass 类
 *
 *  @return Stylize节点
 */
- (instancetype)initWithViewClass:(Class)viewClass;

/**
 *  以类初始化，需要指定默认frame信息
 *
 *  @param viewClass 类
 *  @param frame     frame信息
 *
 *  @return Stylize节点
 */
- (instancetype)initWithViewClass:(Class)viewClass
                     defaultFrame:(CGRect)frame;

/**
 *  以UIView实例初始化
 *
 *  @param view UIView实例
 *
 *  @return Stylize节点
 */
- (instancetype)initWithView:(UIView *)view;

/**
 *  手动触发位置计算
 */
- (void)layoutNode;

/**
 *  需要布局的节点
 */
- (NSArray *)allSubnodesForLayout;

/**
 *  布局之外的渲染
 */
- (void)renderNode;

@end

@interface StylizeNode(DOM)

/**
 *  通过添加view添加子节点
 *
 *  @param view 需要添加的子节点
 */
- (void)addSubview:(UIView *)view;

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
- (void)replaceSubnode:(StylizeNode *)subnode withSubnode:(StylizeNode *)replacement;

/**
 *  从父节点移除
 */
- (void)removeFromSupernode;

@end

@interface StylizeNode(CSS)

/**
 *  添加CSS规则
 *
 *  @param CSSRule 需要增加或者覆盖的CSS规则
 */
- (void)applyCSSRule:(StylizeCSSRule *)CSSRule;

/**
 *  添加CSS规则字典
 *
 *  @param CSSDictionary 需要增加或者覆盖的CSS规则
 */
- (void)applyCSSDictionary:(NSDictionary *)CSSDictionary;

/**
 *  通过解析CSS文本添加CSS规则
 *
 *  @param CSSRaw CSS文本
 */
- (void)applyCSSRaw:(NSString *)CSSRaw;

@end
