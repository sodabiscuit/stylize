//
//  StylizeNode+Flexbox.m
//  StylizeDemo
//
//  Created by Yulin Ding on 4/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode+Flexbox.h"
#import "StylizeCSSRule.h"
#import "Layout.h"

@interface StylizeNode()

@property (nonatomic, readwrite, assign) CGRect frame;
@property (nonatomic, readwrite, copy) NSArray *subnodes;
@property (nonatomic, readwrite, strong) UIView *view;

@end

@implementation StylizeNode(Flexbox)

#pragma mark - StylizeNodeFlexProtocol

- (void)flexLayoutNode {
    layoutNode(self.node, self.node->layout.dimensions[CSS_WIDTH], self.node->style.direction);
}

- (void)flexBeforeLayout {
    NSArray *subnodes = [self flexSubnodesForLayout];
    self.node->children_count = (int)[subnodes count];
    [self resetPositionsAndDimensions];
}

- (void)flexAfterLayout {
    //NOTHING
}

- (CGSize)flexComputeSize:(CGSize)aSize {
    CGSize ret = CGSizeZero;
    StylizeCSSRule *CSSRule = self.CSSRule;
    
    if (!isnan(aSize.width) &&
        aSize.width > 0) {
        ret.width = aSize.width;
    }
    
    if (!isnan(aSize.height) &&
        aSize.height > 0) {
        ret.height = aSize.height;
    }
    
    CGSize maxSize = CSSRule.maxSize;
    CGSize minSize = CSSRule.minSize;
    
    if (!CGSizeEqualToSize(maxSize, CGSizeZero) &&
        !CGSizeEqualToSize(maxSize, (CGSize){CGFLOAT_MAX, CGFLOAT_MAX})) {
        ret.width = !isnan(maxSize.width) && ret.width > maxSize.width ? maxSize.width : ret.width;
        ret.height = !isnan(maxSize.height) && ret.height > maxSize.height ? maxSize.height : ret.height;
    }
    
    if (!CGSizeEqualToSize(minSize, CGSizeZero) &&
        !CGSizeEqualToSize(minSize, (CGSize){CGFLOAT_MIN, CGFLOAT_MIN})) {
        ret.width = !isnan(minSize.width) && ret.width < minSize.width ? minSize.width : ret.width;
        ret.height = !isnan(minSize.height) && ret.height < minSize.height ? minSize.height : ret.height;
    }
    
    return ret;
}

- (NSArray *)flexSubnodesForLayout {
    NSMutableArray *ret = [@[] mutableCopy];
    
    [self.subnodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *node = (StylizeNode *)obj;
        StylizeCSSRule *CSSRule = node.CSSRule;
        
        if (CSSRule.visibility != StylizeVisibilityHidden &&
            CSSRule.display != StylizeDisplayNone) {
            [ret addObject:node];
        }
    }];
    
    return [ret copy];
}

- (void)flexPrepareForLayout {
    StylizeCSSRule *CSSRule = self.CSSRule;
    
    self.node->style.flex_direction = (int)CSSRule.flexDirection;
    self.node->style.flex_wrap = (int)CSSRule.flexWrap;
    self.node->style.flex = CSSRule.flex;
    self.node->style.align_content = (int)CSSRule.alignContent;
    self.node->style.align_items = (int)CSSRule.alignItems;
    self.node->style.align_self = (int)CSSRule.alignSelf;
    self.node->style.justify_content = (int)CSSRule.justifyContent;
}

- (void)resetPositionsAndDimensions {
    self.node->layout.position[CSS_LEFT] = 0;
    self.node->layout.position[CSS_RIGHT] = 0;
    self.node->layout.position[CSS_TOP] = 0;
    self.node->layout.position[CSS_BOTTOM] = 0;
    
    self.node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    self.node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
}

@end
