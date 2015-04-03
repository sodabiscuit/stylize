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

@interface StylizeNode() <StylizeNodeProtocol>

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;
@property (nonatomic,readwrite,assign) BOOL isDimensionSet;

@end

@implementation StylizeNode(Flexbox)

#pragma mark - Class Method

+ (BOOL)isHorizontalDirection:(StylizeLayoutFlexDirection)direction {
    return direction == StylizeLayoutFlexDirectionRow || direction == StylizeLayoutFlexDirectionRowReverse;
}

+ (BOOL)isVerticalDirection:(StylizeLayoutFlexDirection)direction {
    return direction == StylizeLayoutFlexDirectionColumn || direction == StylizeLayoutFlexDirectionColumnReverse;
}

+ (BOOL)isDimensionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    if ([StylizeNode isHorizontalDirection:direction]) {
        return [node.CSSRule isRuleDefined:@"width"];
    } else {
        return [node.CSSRule isRuleDefined:@"height"];
    }
}

+ (BOOL)isPositionDefined:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? [node.CSSRule isRuleDefined:@"left"] : [node.CSSRule isRuleDefined:@"top"];
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? [node.CSSRule isRuleDefined:@"right"] : [node.CSSRule isRuleDefined:@"bottom"];
    }
}

+ (CGFloat)getDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.width : node.CSSRule.height;
}

+ (CGFloat)getNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    if ([StylizeNode isHorizontalDirection:direction]) {
        return node.frame.size.width;
    } else {
        return node.frame.size.height;
    }
}

+ (void)setNodeDimension:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value {
    CGRect frame = node.frame;
    if ([StylizeNode isHorizontalDirection:direction]) {
        frame.size.width = value;
    } else {
        frame.size.height = value;
    }
    node.frame = frame;
    node.view.frame = frame;
    node.isDimensionSet = YES;
}

+ (CGFloat)getNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    if ([StylizeNode isHorizontalDirection:direction]) {
        return node.frame.origin.x;
    } else {
        return node.frame.origin.y;
    }
}

+ (void)setNodePosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction value:(CGFloat)value {
    CGRect frame = node.frame;
    if ([StylizeNode isHorizontalDirection:direction]) {
        frame.origin.x = value;
    } else {
        frame.origin.y = value;
    }
    node.frame = frame;
    node.view.frame = frame;
}

+ (CGFloat)getLeading:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingLeft + node.CSSRule.marginLeft : node.CSSRule.paddingTop + node.CSSRule.marginTop;
}

+ (CGFloat)getTrailing:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingRight + node.CSSRule.marginRight : node.CSSRule.paddingBottom + node.CSSRule.marginBottom;
}

+ (CGFloat)getPaddingandBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingLeft + node.CSSRule.paddingRight + node.CSSRule.borderLeft.width + node.CSSRule.borderRight.width : node.CSSRule.paddingTop + node.CSSRule.paddingBottom + node.CSSRule.borderTop.width + node.CSSRule.borderBottom.width;
}

+ (CGFloat)getPaddingandBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingLeft + node.CSSRule.borderLeft.width : node.CSSRule.paddingTop + node.CSSRule.borderTop.width;
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingRight + node.CSSRule.borderRight.width : node.CSSRule.paddingBottom + node.CSSRule.borderBottom.width;
    }
}

+ (CGFloat)getMargin:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.marginLeft + node.CSSRule.marginRight : node.CSSRule.marginTop + node.CSSRule.marginBottom;
}

+ (CGFloat)getMargin:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.marginLeft : node.CSSRule.marginTop;
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.marginRight : node.CSSRule.marginBottom;
    }
}

+ (CGFloat)getPadding:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingLeft + node.CSSRule.paddingRight : node.CSSRule.paddingTop + node.CSSRule.paddingBottom;
}

+ (CGFloat)getPadding:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingLeft : node.CSSRule.paddingTop;
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.paddingRight : node.CSSRule.paddingBottom;
    }
}

+ (CGFloat)getBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction {
    return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.borderLeft.width + node.CSSRule.borderRight.width : node.CSSRule.borderTop.width + node.CSSRule.borderBottom.width;
}

+ (CGFloat)getBorder:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.borderLeft.width : node.CSSRule.borderTop.width;
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.borderRight.width : node.CSSRule.borderBottom.width;
    }
}

+ (CGFloat)getPosition:(StylizeNode *)node direction:(StylizeLayoutFlexDirection)direction location:(StylizeNodeBoxLocationType)location {
    if (location == StylizeNodeBoxLocationTypeLeading) {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.left : node.CSSRule.top;
    } else {
        return [StylizeNode isHorizontalDirection:direction] ? node.CSSRule.right : node.CSSRule.bottom;
    }
}

- (BOOL)isFlex {
    return self.CSSRule.flex > 0 && (self.CSSRule.position == StylizePositionTypeRelative || self.CSSRule.position == StylizePositionTypeStatic);
}

- (BOOL)isFlexWrap {
    return self.CSSRule.flexWrap != StylizeLayoutFlexFlexWrapNowrap;
}

- (void)layoutFlexbox {
    if (!self.supernode) {
        CGPoint position= (CGPoint){self.CSSRule.marginLeft, self.CSSRule.marginTop};
        if (self.CSSRule.position != StylizePositionTypeStatic) {
            position = (CGPoint){self.CSSRule.left + position.x, self.CSSRule.top + position.y};
        }
        
        [StylizeNode setNodePosition:self direction:StylizeLayoutFlexDirectionRow value:position.x];
        [StylizeNode setNodePosition:self direction:StylizeLayoutFlexDirectionColumn value:position.y];
        
        if ([StylizeNode isDimensionDefined:self direction:StylizeLayoutFlexDirectionRow]) {
            [StylizeNode setNodeDimension:self direction:StylizeLayoutFlexDirectionRow value:self.CSSRule.width];
        }
        [StylizeNode setNodeDimension:self direction:StylizeLayoutFlexDirectionColumn value:self.CSSRule.height];
        
        self.view.frame = self.frame;
    }
    
    if (self.layoutType == StylizeLayoutTypeFlex) {
        [self layoutFlexSubnodes];
    }
}

#pragma mark - Private Method

- (CGSize)makeComputedSize:(CGFloat)mainAxisSize cross:(CGFloat)crossAxisSize {
    return [StylizeNode isHorizontalDirection:self.CSSRule.flexDirection] ? (CGSize){mainAxisSize, crossAxisSize} : (CGSize){crossAxisSize, mainAxisSize};
}

- (void)layoutFlexSubnodes {
    [self layoutFlexSubnodesPreLoop];
    [self layoutFlexSubnodesMainLoop];
    for (StylizeNode *subnode in self.subnodes) {
        NSLog(@"<%@> %@ Final: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
    }
}

- (void)layoutFlexSubnodesPreLoop {
    for (StylizeNode *subnode in self.subnodes) {
        NSLog(@"<%@> %@ PreLoop Before: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
        
        //set or reset
        [StylizeNode setNodePosition:subnode direction:StylizeLayoutFlexDirectionRow value:0];
        [StylizeNode setNodePosition:subnode direction:StylizeLayoutFlexDirectionColumn value:0];
        [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionRow value:subnode.CSSRule.width];
        [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionColumn value:subnode.CSSRule.height];
        
        NSLog(@"<%@> %@ PreLoop Reset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
        
        
        /**
         *  处理子节点未设置的尺寸的情况,绝对定位元素尺寸由自身位置信息决定，非绝对定位元素如果尺寸由布局信息决定
         */
        
        CGFloat dimensionAxis;
        if (subnode.CSSRule.position != StylizePositionTypeAbsolute &&
            self.CSSRule.alignItems == StylizeLayoutFlexAlignStretch &&
//            [StylizeNode isDimensionDefined:self direction:self.CSSRule.flexCrossDirection] &&
            ![StylizeNode isDimensionDefined:subnode direction:self.CSSRule.flexCrossDirection]) {
            dimensionAxis = MAX([StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexCrossDirection], [StylizeNode getNodeDimension:self direction:self.CSSRule.flexCrossDirection] - [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:self.CSSRule.flexCrossDirection]);
            [StylizeNode setNodeDimension:subnode direction:self.CSSRule.flexCrossDirection value:dimensionAxis];
        } else {
            if ([subnode.CSSRule isRuleDefined:@"top"] &&
                [subnode.CSSRule isRuleDefined:@"bottom"] &&
//                [StylizeNode isDimensionDefined:self direction:StylizeLayoutFlexDirectionColumn] &&
                ![StylizeNode isDimensionDefined:subnode direction:StylizeLayoutFlexDirectionColumn]) {
                dimensionAxis = [StylizeNode getNodeDimension:self direction:StylizeLayoutFlexDirectionColumn] - [StylizeNode getPaddingandBorder:self direction:StylizeLayoutFlexDirectionColumn] - subnode.CSSRule.top - subnode.CSSRule.bottom;
                [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionColumn value:dimensionAxis];
            }
            
            if ([subnode.CSSRule isRuleDefined:@"left"] &&
                [subnode.CSSRule isRuleDefined:@"right"] &&
//                [StylizeNode isDimensionDefined:self direction:StylizeLayoutFlexDirectionRow] &&
                ![StylizeNode isDimensionDefined:subnode direction:StylizeLayoutFlexDirectionRow]) {
                dimensionAxis = [StylizeNode getNodeDimension:self direction:StylizeLayoutFlexDirectionRow] - [StylizeNode getPaddingandBorder:self direction:StylizeLayoutFlexDirectionRow] - subnode.CSSRule.left - subnode.CSSRule.right;
                [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionRow value:dimensionAxis];
            }
        }
        
        NSLog(@"<%@> %@ PreLoop After: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
    }
}

- (void)layoutFlexSubnodesMainLoop {
    CGFloat definedMainDim = 0;
    CGFloat mainContentDim = 0;
    CGFloat nextContentDim = 0;
    
    CGFloat linesCrossDim = 0;
    CGFloat linesMainDim = 0;
    
    NSInteger flexibleSubnodeCount = 0;
    NSInteger totalFlexible = 0;
    NSInteger nonFlexibleSubnodeCount = 0;
    NSInteger startLine = 0;
    NSInteger endLine = 0;
    NSInteger alreadyComputedNextLayout = 0;
    
    definedMainDim = [StylizeNode getNodeDimension:self direction:self.CSSRule.flexDirection] - [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection];
    
    while (endLine < [self.subnodes count]) {
        /**
         *  计算主轴尺寸信息
         */
        for (NSInteger i = startLine; i < [self.subnodes count]; ++i) {
            StylizeNode *subnode = self.subnodes[i];
            if (subnode.CSSRule.flex > 0 &&
                subnode.CSSRule.position != StylizePositionTypeAbsolute) {
                flexibleSubnodeCount++;
                totalFlexible += subnode.CSSRule.flex;
                
                nextContentDim = [StylizeNode getPaddingandBorder:subnode direction:self.CSSRule.flexDirection];
                nextContentDim += [StylizeNode getMargin:subnode direction:self.CSSRule.flexDirection];
            } else {
                if (alreadyComputedNextLayout == 0) {
                    [subnode layout];
                }
                
                if (subnode.CSSRule.position != StylizePositionTypeAbsolute) {
                    nonFlexibleSubnodeCount++;
                    nextContentDim = [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexDirection];
                    nextContentDim += [StylizeNode getPaddingandBorder:subnode direction:self.CSSRule.flexDirection];
                    nextContentDim += [StylizeNode getMargin:subnode direction:self.CSSRule.flexDirection];
                }
            }
            
            if (self.isFlexWrap &&
                mainContentDim + nextContentDim > definedMainDim &&
                i != startLine) {
                alreadyComputedNextLayout = 1;
                break;
            }
        
            alreadyComputedNextLayout = 0;
            mainContentDim += nextContentDim;
            endLine = i + 1;
        } //end of first loop
        
        CGFloat leadingMainDim = 0;
        CGFloat betweenMainDim = 0;
        CGFloat remainingMainDim = 0;
        
        remainingMainDim = definedMainDim - mainContentDim;
        
        if (flexibleSubnodeCount > 0) {
            CGFloat flexibleMainDim = 0;
            flexibleMainDim = remainingMainDim / totalFlexible;
            flexibleMainDim = MAX(flexibleMainDim, 0);
            
            /**
             *  子节点在定义flex的属性后，其尺寸将不再受限与已定义的默认尺寸
             */
            for (NSInteger i = startLine; i < endLine; ++i) {
                StylizeNode *subnode = self.subnodes[i];
                
                if (subnode.isFlex) {
                    CGFloat dim = flexibleMainDim * subnode.CSSRule.flex + [StylizeNode getPaddingandBorder:subnode direction:self.CSSRule.flexDirection];
                    [StylizeNode setNodeDimension:subnode direction:self.CSSRule.flexDirection value:dim];
                    [subnode layout];
                    NSLog(@"<%@> %@ MainLoop FlexibleDimension: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
                }
            } //end of second loop
        } else {
            /**
             *  不存在可扩展子节点的情况下结算剩余空间
             */
            if (self.CSSRule.justifyContent == StylizeLayoutFlexJustifyContentCenter) {
                leadingMainDim = remainingMainDim / 2;
            } else if (self.CSSRule.justifyContent == StylizeLayoutFlexJustifyContentFlexEnd) {
                leadingMainDim = remainingMainDim;
            } else if (self.CSSRule.justifyContent == StylizeLayoutFlexJustifyContentSpaceBetween) {
                remainingMainDim = MAX(remainingMainDim, 0);
                if (flexibleSubnodeCount + nonFlexibleSubnodeCount - 1 >0) {
                    betweenMainDim = remainingMainDim / (flexibleSubnodeCount + nonFlexibleSubnodeCount - 1);
                } else {
                    betweenMainDim = 0;
                }
            } else if (self.CSSRule.justifyContent == StylizeLayoutFlexJustifyContentSpaceAround) {
                betweenMainDim = remainingMainDim / (flexibleSubnodeCount + nonFlexibleSubnodeCount);
                leadingMainDim = betweenMainDim / 2;
            }
        }
        
        CGFloat crossDim = 0;
        CGFloat mainDim = leadingMainDim + [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
        
        /**
         *  计算主轴位置信息
         */
        for (NSInteger i = startLine; i < endLine; ++i) {
            StylizeNode *subnode = self.subnodes[i];
            CGFloat offsetMainAxis;
            if (subnode.CSSRule.position == StylizePositionTypeAbsolute &&
                [StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetMainAxis = [StylizeNode getPosition:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                offsetMainAxis += [StylizeNode getBorder:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                offsetMainAxis += [StylizeNode getMargin:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexDirection value:offsetMainAxis];
            } else {
                offsetMainAxis = [StylizeNode getPosition:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading] + mainDim;
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexDirection value:offsetMainAxis];
            }
            
            NSLog(@"<%@> %@ MainLoop MainAsixOffset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
            
            if (subnode.CSSRule.position == StylizePositionTypeRelative ||
                subnode.CSSRule.position == StylizePositionTypeStatic) {
                mainDim += betweenMainDim + [StylizeNode getMargin:subnode direction:self.CSSRule.flexDirection] + [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexDirection];
                crossDim = MAX(crossDim, [StylizeNode getMargin:subnode direction:self.CSSRule.flexCrossDirection] + [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexCrossDirection]);
            }
        } //end of third loop
        
        CGFloat containerMainAxis = [StylizeNode getNodeDimension:self direction:self.CSSRule.flexDirection];
        CGFloat containerCrossAxis = [StylizeNode getNodeDimension:self direction:self.CSSRule.flexCrossDirection];
        CGFloat computedContainerMainAxis = MAX(mainDim + [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection]);
        CGFloat computedContainerCrossAxis = MAX(crossDim + [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection]);
        
        self.computedSize = [self makeComputedSize:computedContainerMainAxis cross:computedContainerCrossAxis];
        containerMainAxis = containerMainAxis == 0 ? computedContainerMainAxis : containerMainAxis;
        containerCrossAxis = containerCrossAxis == 0 ? computedContainerCrossAxis : containerCrossAxis;
        
        for (NSInteger i = startLine; i < endLine; ++i) {
            StylizeNode *subnode = self.subnodes[i];
            CGFloat offsetCrossAxis = 0;
            
            if (subnode.CSSRule.position == StylizePositionTypeAbsolute &&
                [StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetCrossAxis = [StylizeNode getPosition:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading] + [StylizeNode getMargin:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading] + [StylizeNode getBorder:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading];
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexCrossDirection value:offsetCrossAxis];
            } else {
                CGFloat leadingCrossDim = [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading];
                if (subnode.CSSRule.position == StylizePositionTypeRelative ||
                    subnode.CSSRule.position == StylizePositionTypeStatic) {
                    StylizeLayoutFlexAlign alignSelf = [subnode.CSSRule isRuleDefined:@"alignSelf"] ? subnode.CSSRule.alignSelf : self.CSSRule.alignItems;
                    
                    if (alignSelf == StylizeLayoutFlexAlignStretch) {
                        CGFloat itemCrossDim = MAX(containerCrossAxis - [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:self.CSSRule.flexCrossDirection], [StylizeNode getPaddingandBorder:subnode direction:self.CSSRule.flexCrossDirection]);
                        [StylizeNode setNodeDimension:subnode direction:self.CSSRule.flexCrossDirection value:itemCrossDim];
                    } else if (alignSelf != StylizeLayoutFlexAlignFlexStart){
                        CGFloat remainingCrossDim = containerCrossAxis - [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection] - [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:self.CSSRule.flexCrossDirection];
                        if (alignSelf == StylizeLayoutFlexAlignCenter) {
                            leadingCrossDim += remainingCrossDim / 2;
                        } else {
                            leadingCrossDim += remainingCrossDim;
                        }
                    }
                }
                
                offsetCrossAxis = [StylizeNode getNodePosition:subnode direction:self.CSSRule.flexCrossDirection];
                offsetCrossAxis += linesCrossDim + leadingCrossDim;
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexCrossDirection value:offsetCrossAxis];
            }
            
            NSLog(@"<%@> %@ MainLoop CrossAsixOffset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.class, self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
            
        } //end of fourth loop
        
        linesCrossDim += crossDim;
        linesMainDim = MAX(linesMainDim, mainDim);
        startLine = endLine;
    } //end of main while
    
    if ([StylizeNode getNodeDimension:self direction:self.CSSRule.flexDirection] == 0) {
        [StylizeNode setNodeDimension:self direction:self.CSSRule.flexDirection value:MAX(linesMainDim + [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexDirection])];
    }
    
    if ([StylizeNode getNodeDimension:self direction:self.CSSRule.flexCrossDirection] == 0) {
        [StylizeNode setNodeDimension:self direction:self.CSSRule.flexCrossDirection value:MAX(linesCrossDim + [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection], [StylizeNode getPaddingandBorder:self direction:self.CSSRule.flexCrossDirection])];
    }
   
    for (StylizeNode *subnode in self.subnodes) {
        if (subnode.CSSRule.position == StylizePositionTypeAbsolute) {
            CGFloat offsetAxis = 0;
            if ([StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing] &&
                ![StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetAxis = [StylizeNode getNodeDimension:self direction:self.CSSRule.flexDirection] - [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexDirection] - [StylizeNode getPosition:subnode direction:self.CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing];
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexDirection value:offsetAxis];
            }
            
            if ([StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing] &&
                ![StylizeNode isPositionDefined:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetAxis = [StylizeNode getNodeDimension:self direction:self.CSSRule.flexCrossDirection] - [StylizeNode getNodeDimension:subnode direction:self.CSSRule.flexCrossDirection] - [StylizeNode getPosition:subnode direction:self.CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing];
                [StylizeNode setNodePosition:subnode direction:self.CSSRule.flexCrossDirection value:offsetAxis];
            }
        }
    }
}

@end
