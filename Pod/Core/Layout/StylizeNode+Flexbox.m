//
//  StylizeNode+Flexbox.m
//  StylizeDemo
//
//  Created by Yulin Ding on 4/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode+Flexbox.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"
#import "NSLogMan.h"
#import "Layout.h"

@interface StylizeNode() <StylizeNodeProtocol>

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;

@end

@implementation StylizeNode(Flexbox)

#pragma mark - StylizeNodeFlexProtocol

- (BOOL)isFlex {
    return self.CSSRule.flex > 0 && self.CSSRule.position == StylizePositionTypeRelative;
}

- (BOOL)isFlexWrap {
    return self.CSSRule.flexWrap != StylizeLayoutFlexFlexWrapNowrap;
}

- (void)flexLayoutNode {
    if (!self.supernode) {
        //TODO
    }
    
    [self flexLayoutSubnodesInternal];
    self.view.frame = self.frame;
}

- (CGSize)flexComputeSize:(CGSize)aSize {
    CGSize ret = CGSizeZero;
    
    if (!isnan(aSize.width) &&
        aSize.width > 0) {
        ret.width = aSize.width;
    }
    
    if (!isnan(aSize.height) &&
        aSize.height > 0) {
        ret.height = aSize.height;
    }
    
    CGSize maxSize = self.CSSRule.maxSize;
    CGSize minSize = self.CSSRule.minSize;
    
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
        
        if (node.CSSRule.visibility != StylizeVisibilityHidden &&
            node.CSSRule.display != StylizeDisplayNone) {
            [ret addObject:node];
        }
    }];
    
    return [ret copy];
}

- (void)flexPrepareForLayout {
    self.node->style.position_type = (int)self.CSSRule.position;
    
    self.node->style.position[CSS_LEFT] = self.CSSRule.left;
    self.node->style.position[CSS_TOP] = self.CSSRule.top;
    self.node->style.position[CSS_RIGHT] = self.CSSRule.right;
    self.node->style.position[CSS_BOTTOM] = self.CSSRule.bottom;
    
    self.node->style.dimensions[CSS_WIDTH] = self.CSSRule.width;
    self.node->style.dimensions[CSS_HEIGHT] = self.CSSRule.height;
    
    self.node->style.minDimensions[CSS_WIDTH] = self.CSSRule.minWidth;
    self.node->style.minDimensions[CSS_HEIGHT] = self.CSSRule.minHeight;
    
    self.node->style.maxDimensions[CSS_WIDTH] = self.CSSRule.maxWidth;
    self.node->style.maxDimensions[CSS_HEIGHT] = self.CSSRule.maxHeight;
    
    self.node->style.margin[CSS_LEFT] = self.CSSRule.marginLeft;
    self.node->style.margin[CSS_TOP] = self.CSSRule.marginTop;
    self.node->style.margin[CSS_RIGHT] = self.CSSRule.marginRight;
    self.node->style.margin[CSS_BOTTOM] = self.CSSRule.marginBottom;
    
    self.node->style.padding[CSS_LEFT] = self.CSSRule.paddingLeft;
    self.node->style.padding[CSS_TOP] = self.CSSRule.paddingTop;
    self.node->style.padding[CSS_RIGHT] = self.CSSRule.paddingRight;
    self.node->style.padding[CSS_BOTTOM] = self.CSSRule.paddingBottom;
    
    self.node->style.border[CSS_LEFT] = self.CSSRule.borderLeft.width;
    self.node->style.border[CSS_TOP] = self.CSSRule.borderTop.width;
    self.node->style.border[CSS_RIGHT] = self.CSSRule.borderRight.width;
    self.node->style.border[CSS_BOTTOM] = self.CSSRule.borderBottom.width;
    
    self.node->style.flex_direction = (int)self.CSSRule.flexDirection;
    self.node->style.flex_wrap = (int)self.CSSRule.flexWrap;
    self.node->style.flex = self.CSSRule.flex;
    self.node->style.align_content = (int)self.CSSRule.alignContent;
    self.node->style.align_items = (int)self.CSSRule.alignItems;
    self.node->style.align_self = (int)self.CSSRule.alignSelf;
    self.node->style.justify_content = (int)self.CSSRule.justifyContent;
}

- (void)flexLayoutSubnodesInternal {
    [self flexPrepareForLayout];
   
    NSArray *subnodes = [self flexSubnodesForLayout];
    self.node->children_count = (int)[subnodes count];
    layoutNode(self.node, self.frame.size.width, self.node->style.direction);
    
    [subnodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StylizeNode *subnode = (StylizeNode *)obj;
        [subnode layoutNode];
    }];
}

@end
