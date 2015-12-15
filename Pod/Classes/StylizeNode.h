//
//  StylizeNode.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeGeometry.h"
#import "Layout.h"
#import "StylizeEventDefinations.h"

@class StylizeCSSRule;
@class StylizeNode;
@protocol StylizeCSSRuleProtocol;

typedef CGSize (^StylizeNodeMeasureBlock)(CGFloat);

@interface StylizeNode : NSObject {
    @protected
    id _view;
}

/**
 *  uuid信息
 */
@property (nonatomic, readonly, strong) NSString *nodeUUID;

/**
 *  id信息
 */
@property (nonatomic, strong) NSString *nodeID;

/**
 *  class选择符信息
 */
@property (nonatomic, readonly, copy) NSSet *nodeClasses;

/**
 *  标签名称
 */
@property (nonatomic, readonly, strong) NSString *tagName;

/**
 *  绑定view的class
 */
@property (nonatomic, readonly, assign) Class viewClass;

/**
 *  属性
 */
@property (nonatomic, readonly, copy) NSDictionary *attributes;

/**
 *  文本内容
 */
@property (nonatomic, strong) NSString *content;

/**
 *  输出的位置信息
 */
@property (nonatomic, readonly, assign) CGRect frame;

/**
 *  初始化尺寸
 */
@property (nonatomic, readonly, assign) CGRect defaultFrame;

/**
 *  布局类型
 */
@property (nonatomic, assign) StylizeLayoutType layoutType;

/**
 *  样式
 */
@property (nonatomic, readonly, strong) StylizeCSSRule *CSSRule;

/**
 *  父节点
 */
@property (nonatomic, readonly, weak) StylizeNode *supernode;

/**
 *  子节点列表
 */
@property (nonatomic, readonly, copy) NSArray *subnodes;

/**
 *  事件列表
 */
@property (nonatomic, readonly) NSDictionary *events;

/**
 *  节点所包含的UIView或UIView子类实例
 */
@property (nonatomic, readonly, strong) id view;

/**
 *  透传至view
 */
@property (nonatomic, getter=isUserInteractionEnabled) BOOL userInteractionEnabled;

/**
 *  tag，透传至view
 */
@property (nonatomic, assign) NSInteger tag;

/**
 *  flexbox布局节点
 */
@property (nonatomic, readonly, assign) css_node_t *node;

/**
 *  自身的尺寸计算方法
 *  1. 优先级低于measure方法；
 *  2. 当前实现导致此方法在父节点布局完成后调用，因此不会影响父节点的调用。
 */
@property (nonatomic, readonly, weak) StylizeNodeMeasureBlock classMeasure;

/**
 *  自身的尺寸计算方法
 *  1. 使用时注意避免循环引用；
 *  2. 当前实现导致此方法在父节点布局完成后调用，因此不会影响父节点的调用。
 */
@property (nonatomic, copy) StylizeNodeMeasureBlock measure;

/**
 *  使用结构文本数据以及stylesheet创建节点
 *
 *  @param document   结构文本数据
 *  @param styleSheet 样式文本数据
 *
 *  @return 节点
 */
- (instancetype)initWithDocument:(NSData *)document
                   andStyleSheet:(NSData *)styleSheet;

/**
 *  下载结构文本数据以及stylesheet创建节点
 *
 *  @param documentURL   结构文本数据地址
 *  @param styleSheetURL 样式文本数据地址
 *
 *  @return 节点
 */
- (instancetype)initWithDocumentURL:(NSString *)documentURL
                   andStyleSheetURL:(NSString *)styleSheetURL;

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
 *  @param frame frame
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
 *  不创建包含view的context
 *
 *  @return Stylize节点，view属性为空
 */
+ (instancetype)shadowNode:(NSString *)tagName;

/**
 *  规则类
 *
 *  @return 规则类
 */
+ (Class)CSSRuleClass;

@end


@interface StylizeNode(Layout)

/**
 *  布局前处理
 */
-(void)syncCSSRuleForLayout;

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
 *  设置属性
 *
 *  @param key   属性键
 *  @param value 属性值
 */
- (void)setAttribute:(NSString *)key value:(id)value;

/**
 *  获取属性值
 *
 *  @param key 属性键
 *
 *  @return 属性值
 */
- (id)getAttribute:(NSString *)key;

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

/**
 *  添加class类
 *
 *  @param className 样式类名
 */
- (void)addNodeClass:(NSString *)className;

/**
 *  是否存在class
 *
 *  @param className 样式类名
 */
- (BOOL)hasNodeClass:(NSString *)className;


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
 *  增加单条CSS规则
 *
 *  @param key   ruleKey
 *  @param value ruleValue
 */
- (void)applyRule:(NSString *)ruleKey value:(id)ruleValue;

/**
 *  通过解析CSS文本添加CSS规则
 *
 *  @param CSSRaw CSS文本
 */
- (void)applyCSSRaw:(NSString *)CSSRaw;

/**
 *  应用规则集合stylesheet
 *
 *  @param styleSheet 要应用的stylesheet
 */
- (void)applyStyleSheet:(NSData *)styleSheet;

/**
 *  解析CSSParser无法处理的属性
 *
 *  @param key   rule键
 *  @param value rule值
 */
- (void)parseUnrecoginzedCSSRule:(NSString *)key value:(id)value;

@end

@interface StylizeNode(Event)

/**
 *  添加事件
 *
 *  @param event     事件识别符
 *  @param nodeBlock 事件block
 */
- (void)addEvent:(id)event block:(StylizeNodeEventBlockBind)nodeBlock;

/**
 *  移除事件
 *
 *  @param event 事件识别符
 */
- (void)removeEvent:(id)event;

@end
