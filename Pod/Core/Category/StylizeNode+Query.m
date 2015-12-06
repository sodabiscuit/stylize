//
//  StylizeNode+Query.m
//  StylizeDemo
//
//  Created by Yulin Ding on 3/23/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode+Query.h"
#import "UIView+StylizeNode.h"

NS_INLINE void add_valid_node_to_array(StylizeNode *node, NSString *selector, NSMutableArray *__autoreleasing *array) {
    if ([selector hasPrefix:@"."]) {
        if ([node hasNodeClass:[selector substringFromIndex:1]]) {
            [*array addObject:node];
        }
    } else if ([selector hasPrefix:@"#"]) {
        if (node.nodeID.length > 0 && [node.nodeID isEqualToString:[selector substringFromIndex:1]]) {
            [*array addObject:node];
        }
    } else if (selector.length > 0) {
        NSString *tag = nil;
        NSUInteger classMark = [selector rangeOfString:@"."].location;
        NSUInteger idMark = [selector rangeOfString:@"#"].location;
        NSString *tagName = NSStringFromClass([node class]);
        
        if (classMark != NSNotFound) {
            tag = [selector substringToIndex:classMark];
            NSString *cls = [selector substringFromIndex:classMark + 1];
            if ([tagName isEqualToString:tag] && [node hasNodeClass:cls]) {
                [*array addObject:node];
            }
        } else if (idMark != NSNotFound) {
            tag = [selector substringToIndex:idMark];
            NSString *Id = [selector substringFromIndex:idMark + 1];
            if ([tagName isEqualToString:tag] && (node.nodeID.length > 0 && [node.nodeID isEqualToString:Id])) {
                [*array addObject:node];
            }
        } else {
            tag = selector;
            if ([tagName isEqualToString:tag]) {
                [*array addObject:node];
            }
        }
    } else {
        [*array addObject:node];
    }
}

NS_INLINE NSArray *stylize_find_children(StylizeNode *root, NSString *selector, bool deep) {
    NSMutableArray *ret = [@[] mutableCopy];
    
    for (int i = 0; i < [root.subnodes count]; i++) {
        if (selector.length > 0) {
            add_valid_node_to_array(root.subnodes[i], selector, &ret);
            if (deep) {
                NSArray *subnodes = stylize_find_children(root.subnodes[i], selector, deep);
                if (subnodes && [subnodes count] > 0) {
                    [ret addObjectsFromArray:subnodes];
                }
            }
        } else {
            [ret addObject:root.subnodes[i]];
        }
    }
    return [ret copy];
}

NS_INLINE NSArray *stylize_find_parents(StylizeNode *root, NSString *selector, bool deep) {
    NSMutableArray *ret = [@[] mutableCopy];
    
    StylizeNode *parent = root.supernode;
    while (parent) {
        add_valid_node_to_array(parent, selector, &ret);
        if (deep) {
            NSArray *subnodes = stylize_find_parents(parent, selector, deep);
            if (subnodes && [subnodes count] > 0) {
                [ret addObjectsFromArray:subnodes];
            }
        }
    }
    return [ret copy];
}


NS_INLINE NSArray *stylize_find_sibling(StylizeNode *node, NSString *selector, NSInteger type) {
    if (!node.supernode) {
        return @[];
    }
    
    NSArray *subnodes = [node.supernode subnodes];
    NSInteger index = [subnodes indexOfObject:node];
    
    if (index == NSNotFound ||
        (type == 1 && index == 0) ||
        (type == 2 && index == [subnodes count] - 1)) {
        return @[];
    }
    
    NSMutableArray *ret = [@[] mutableCopy];
    
    NSUInteger i = 0;
    NSUInteger max = [subnodes count];
    
    if (type == 1) {
        i = 0;
        max = index;
    } else if (type == 2) {
        i = index + 1;
        max = [subnodes count];
    }
    
    for (; i < max; i++) {
        if (i != index) {
            add_valid_node_to_array(subnodes[i], selector, &ret);
        }
    }
    
    return [ret copy];
}

@implementation StylizeNode(Query)

- (StylizeNodeQueryBlockAS)Query {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_children(self, selector, true)];
    };
    return block;
}

- (StylizeNodeQueryBlockAS)children {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_children(self, selector, false)];
    };
    return block;
}

- (StylizeNodeQueryBlockAS)parents {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_parents(self, selector, true)];
    };
    return block;
}

- (StylizeNodeQueryBlockAS)prevAll {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_sibling(self, selector, 1)];
    };
    return block;
}

- (StylizeNodeQueryBlockAS)nextAll {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_sibling(self, selector, 2)];
    };
    return block;
}

- (StylizeNodeQueryBlockAS)siblings {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        return [StylizeNodeQuery arrayWithArray:stylize_find_sibling(self, selector, 0)];
    };
    return block;
}

- (StylizeNodeQueryBlockNV)parent {
    StylizeNodeQueryBlockNV block = ^id(void) {
        return self.supernode;
    };
    return block;
}

- (StylizeNodeQueryBlockNV)prev {
    StylizeNodeQueryBlockNV block = ^id(void) {
        if (!self.supernode) {
            return nil;
        }
        
        NSArray *subnodes = [self.supernode subnodes];
        NSInteger index = [subnodes indexOfObject:self];
        
        if (index == NSNotFound ||
            index == 0) {
            return nil;
        }
        
        return subnodes[index-1];
    };
    return block;
}

- (StylizeNodeQueryBlockNV)next {
    StylizeNodeQueryBlockNV block = ^id(void) {
        if (!self.supernode) {
            return nil;
        }
        
        NSArray *subnodes = [self.supernode subnodes];
        NSInteger index = [subnodes indexOfObject:self];
        
        if (index == NSNotFound ||
            index == [subnodes count] - 1) {
            return nil;
        }
        
        return subnodes[index+1];
    };
    return block;
}

- (StylizeNodeQueryBlockNOO)CSS {
    StylizeNodeQueryBlockNOO block = ^id(id key, id val) {
        if ([key isKindOfClass:[NSDictionary class]]) {
            [self applyCSSDictionary:key];
        } else if ([key isKindOfClass:[NSString class]] && [val isKindOfClass:[NSString class]]) {
            NSString *k = (NSString *)key;
            NSString *v = (NSString *)val;
            if (k.length > 0 && v.length > 0) {
                [self applyRule:k value:v];
            }
        }
        
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNS)Class {
    StylizeNodeQueryBlockNS block = ^id(NSString *cls) {
        [self addNodeClass:cls];
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNS)ID {
    StylizeNodeQueryBlockNS block = ^id(NSString *Id) {
        self.nodeID = Id;
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNN)append {
    StylizeNodeQueryBlockNN block = ^id(StylizeNode *node) {
        [self addSubnode:node];
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNN)prepend {
    StylizeNodeQueryBlockNN block = ^id(StylizeNode *node) {
        [self insertSubnode:node atIndex:0];
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNN)appendTo {
    StylizeNodeQueryBlockNN block = ^id(StylizeNode *node) {
        [node addSubnode:self];
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockNN)prependTo {
    StylizeNodeQueryBlockNN block = ^id(StylizeNode *node) {
        [node insertSubnode:self atIndex:0];
        return self;
    };
    return block;
}

- (StylizeNodeQueryBlockBS)hasClass {
    StylizeNodeQueryBlockBS block = ^BOOL(NSString *cls) {
        return [self hasNodeClass:cls];
    };
    return block;
}

@end

@interface StylizeNodeQuery()

@property (nonatomic, readwrite, strong) NSArray *array;

@end

@implementation StylizeNodeQuery

+ (instancetype)arrayWithArray:(NSArray *)anArray {
    StylizeNodeQuery *ret = [[StylizeNodeQuery alloc] init];
    ret.array = anArray;
    return ret;
}

- (NSUInteger)count {
    return [self.array count];
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self.array objectAtIndex:index];
    }
    return nil;
}

- (NSUInteger)indexOfObject:(id)anObject {
    return [self.array indexOfObject:anObject];
}

- (id)firstObject {
    return [self.array firstObject];
}

- (id)lastObject {
    return [self.array lastObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

- (StylizeNodeQueryBlockAS)find {
    StylizeNodeQueryBlockAS block = ^id(NSString *selector) {
        NSMutableArray *ret = [NSMutableArray array];
        for (StylizeNode *child in self) {
            NSArray *subnodes = stylize_find_children(child, selector, true);
            if (subnodes && [subnodes count] > 0) {
                [ret addObjectsFromArray:subnodes];
            }
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockNV)first {
    StylizeNodeQueryBlockNV block = ^id(void) {
        if ([self count] > 0) {
            return [self firstObject];
        }
        return nil;
    };
    return block;
}

- (StylizeNodeQueryBlockNV)last {
    StylizeNodeQueryBlockNV block = ^id(void) {
        if ([self count] > 0) {
            return [self lastObject];
        }
        return nil;
    };
    return block;
}

- (StylizeNodeQueryBlockIN)index {
    StylizeNodeQueryBlockIN block = ^NSUInteger(StylizeNode *node) {
        return [self indexOfObject:node];
    };
    return block;
}

- (StylizeNodeQueryBlockNI)get {
    StylizeNodeQueryBlockNI block = ^id(NSUInteger index) {
        if (index > 0 && index < [self count] - 1) {
            return [self objectAtIndex:index];
        }
        return nil;
    };
    return block;
}

- (StylizeNodeQueryBlockAOO)CSS {
    StylizeNodeQueryBlockAOO block = ^id(id key, id val) {
        NSMutableArray *ret = [NSMutableArray array];
        
        for (StylizeNode *child in self) {
            if ([key isKindOfClass:[NSDictionary class]]) {
                [child applyCSSDictionary:key];
            } else if ([key isKindOfClass:[NSString class]] && [val isKindOfClass:[NSString class]]) {
                NSString *k = (NSString *)key;
                NSString *v = (NSString *)val;
                if (k.length > 0 && v.length > 0) {
                    [child applyRule:k value:v];
                }
            }
            [ret addObject:child];
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}


- (StylizeNodeQueryBlockAS)Class {
    StylizeNodeQueryBlockAS block = ^id(NSString *cls) {
        NSMutableArray *ret = [NSMutableArray array];
        
        for (StylizeNode *child in self) {
            [child addNodeClass:cls];
            [ret addObject:child];
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockAN)appendTo {
    StylizeNodeQueryBlockAN block = ^id(StylizeNode *node) {
        NSMutableArray *ret = [NSMutableArray array];
        
        for (StylizeNode *child in self) {
            [node addSubnode:child];
            [ret addObject:child];
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockAN)prependTo {
    StylizeNodeQueryBlockAN block = ^id(StylizeNode *node) {
        NSMutableArray *ret = [NSMutableArray array];
        
        for (StylizeNode *child in self) {
            [node insertSubnode:child atIndex:0];
            [ret insertObject:child atIndex:0];
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockAMap)map {
    StylizeNodeQueryBlockAMap block = ^id(StylizeNodeQueryBlockNN mapBlock) {
        NSMutableArray *ret = [@[] mutableCopy];
        for (StylizeNode *subnode in self) {
            StylizeNode *node = mapBlock(subnode);
            if (node) {
                [ret addObject:node];
            }
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockAFilter)filter {
    StylizeNodeQueryBlockAFilter block = ^id(StylizeNodeQueryBlockBOI filterBlock) {
        NSMutableArray *ret = [@[] mutableCopy];
        for (int i = 0; i < [self count]; i++) {
            BOOL has = filterBlock([self objectAtIndex:i], i);
            if (has) {
                [ret addObject:[self objectAtIndex:i]];
            }
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

- (StylizeNodeQueryBlockAEach)each {
    StylizeNodeQueryBlockAEach block = ^id(StylizeNodeQueryBlockNOI eachBlock) {
        NSMutableArray *ret = [@[] mutableCopy];
        for (int i = 0; i < [self count]; i++) {
            StylizeNode *node = eachBlock([self objectAtIndex:i], i);
            if (node) {
                [ret addObject:node];
            }
        }
        
        return [StylizeNodeQuery arrayWithArray:ret];
    };
    return block;
}

@end
