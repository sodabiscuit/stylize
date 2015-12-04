//
//  StylizeNode+Query.h
//  StylizeDemo
//
//  Created by Yulin Ding on 3/23/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"

@class StylizeNodeQuery;

//normal
typedef NSString* (^StylizeNodeQueryBlockSS)(NSString *);
typedef NSString* (^StylizeNodeQueryBlockSV)(void);
typedef BOOL (^StylizeNodeQueryBlockBS)(NSString *);
typedef NSUInteger (^StylizeNodeQueryBlockIN)(StylizeNode *);
typedef StylizeNode* (^StylizeNodeQueryBlockNV)(void);
typedef StylizeNode* (^StylizeNodeQueryBlockNI)(NSUInteger);
typedef StylizeNode* (^StylizeNodeQueryBlockNS)(NSString *);
typedef StylizeNode* (^StylizeNodeQueryBlockNN)(StylizeNode *);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAS)(NSString *);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAV)(void);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAV)(void);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAA)(StylizeNodeQuery *);

//specical
typedef StylizeNode* (^StylizeNodeQueryBlockNOO)(id, id);
typedef StylizeNode* (^StylizeNodeQueryBlockNOI)(id, NSUInteger);
typedef BOOL (^StylizeNodeQueryBlockBOI)(id, NSUInteger);

typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAMap)(StylizeNodeQueryBlockNN);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAFilter)(StylizeNodeQueryBlockBOI);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAEach)(StylizeNodeQueryBlockNOI);


@interface StylizeNode(Query)

#pragma mark - traversing

/**
 *  查找子节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS Query;
/**
 *  查找子节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS children;
/**
 *  相邻节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS siblings;
/**
 *  前相邻所有节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS prevAll;
/**
 *  后相邻所有节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS nextAll;
/**
 *  父节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV parent;
/**
 *  至顶部的所有父节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS parents;
/**
 *  前相邻节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV prev;
/**
 *  后相邻节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV next;

#pragma mark - manipulation

/**
 *  应用CSS规则，单个参数时传入字典
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNOO CSS;
/**
 *  增加nodeclass
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNS Class;
/**
 *  设置nodeId
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNS ID;
/**
 *  nodeClasses是否包含class
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockBS hasClass;

@end

@interface StylizeNodeQuery : NSArray

#pragma mark - traversing

/**
 *  根据selector查找
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS find;
/**
 *  第一个节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV first;
/**
 *  最后一个节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV last;
/**
 *  获取列表中的index值
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockIN index;
/**
 *  获取列表中指定index的节点
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNI get;


#pragma mark - manipulation

/**
 *  map方法
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAMap map;
/**
 *  each 方法
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAEach each;
/**
 *  filter方法
 */
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAFilter filter;

@end
