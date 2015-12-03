//
//  StylizeNode+Query.h
//  StylizeDemo
//
//  Created by Yulin Ding on 3/23/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"

@class StylizeNodeQuery;

typedef NSString* (^StylizeNodeQueryBlockSS)(NSString *);
typedef NSString* (^StylizeNodeQueryBlockSV)(void);
typedef BOOL (^StylizeNodeQueryBlockBS)(NSString *);
typedef NSUInteger (^StylizeNodeQueryBlockIN)(StylizeNode *);
typedef StylizeNode* (^StylizeNodeQueryBlockNOO)(id, id);
typedef StylizeNode* (^StylizeNodeQueryBlockNV)(void);
typedef StylizeNode* (^StylizeNodeQueryBlockNI)(NSUInteger);
typedef StylizeNode* (^StylizeNodeQueryBlockNS)(NSString *);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAS)(NSString *);
typedef StylizeNodeQuery* (^StylizeNodeQueryBlockAV)(void);

@interface StylizeNode(Query)

#pragma mark - traversing

@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS Query;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAV children;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAV prevAll;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAV nextAll;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV parent;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAV parents;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV prev;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV next;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS siblings;

#pragma mark - manipulation

@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNOO CSS;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNS Class;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNS Id;

@end

@interface StylizeNodeQuery : NSArray

#pragma mark - traversing

@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAS find;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV first;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNV last;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockAV addSelf;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockIN index;
@property (nonatomic, weak, readonly) StylizeNodeQueryBlockNI get;

@end
