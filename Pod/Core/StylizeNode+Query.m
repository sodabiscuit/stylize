//
//  StylizeNode+Query.m
//  StylizeDemo
//
//  Created by Yulin Ding on 3/23/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode+Query.h"

NS_INLINE NSArray *stylize_find_children(StylizeNode *root, NSString *selector, bool deep) {
    NSMutableArray *ret = [@[] mutableCopy];
    return ret;
}

@implementation StylizeNode(Query)

- (StylizeNodeQueryBlockAS)Query {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return stylize_find_children(self, selector, true);
    };
    return block;
}

@end
