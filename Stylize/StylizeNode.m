//
//  StylizeNode.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeNode.h"
#import "StylizeCSSRule.h"
#import "StylizeLayoutEvent.h"

static void *PrivateKVOContext = &PrivateKVOContext;

@interface StylizeNode()

@property (nonatomic,readwrite,assign) CGRect frame;
@property (nonatomic,readwrite,assign) CGSize computedSize;
@property (nonatomic,readwrite,strong) NSArray *subnodes;
@property (nonatomic,readwrite,weak) StylizeNode *supernode;
@property (nonatomic,readwrite,strong) UIView *view;

@end

@implementation StylizeNode

#pragma mark - LifeCycle

- (instancetype)init {
    return [self initWithViewClass:[UIView class]];
}

- (void)dealloc {
    _subnodes = nil;
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyLayout"];
    [_CSSRule removeObserver:self forKeyPath:@"observerPropertyOther"];
}

- (instancetype)initWithViewClass:(Class)viewClass {
    return [self initWithViewClass:viewClass defaultFrame:CGRectZero];
}

- (instancetype)initWithViewClass:(Class)viewClass defaultFrame:(CGRect)frame  {
    if (self=[super init]) {
        NSAssert([viewClass isSubclassOfClass:[UIView class]], @"viewClass must be a UIView or a subclass of UIView.");
        [self makeDefaultProperties];
        _view = [[viewClass alloc] initWithFrame:frame];
        _frame = frame;
        _CSSRule.width = _frame.size.width;
        _CSSRule.height = _frame.size.height;
        [self createCSSRuleObserver];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view {
    if (self=[super init]) {
        [self makeDefaultProperties];
        _view = view;
        _frame = view.frame;
        _CSSRule.width = _frame.size.width;
        _CSSRule.height = _frame.size.height;
        [self createCSSRuleObserver];
    }
    return self;
}

- (void)makeDefaultProperties {
    _layoutType = StylizeLayoutTypeFlex;
    _frame = CGRectZero;
    _subnodes = [NSArray array];
    _CSSRule = [[StylizeCSSRule alloc] init];
}

- (void)createCSSRuleObserver {
    [_CSSRule addObserver:self
forKeyPath:@"observerPropertyLayout" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
    [_CSSRule addObserver:self
forKeyPath:@"observerPropertyOther" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:PrivateKVOContext];
}

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

#pragma mark - Setter and Getter

- (CGFloat)width {
    return self.CSSRule.width;
}

- (void)setWidth:(CGFloat)width {
    self.CSSRule.width = width;
}

- (CGFloat)height {
    return self.CSSRule.height;
}

- (void)setHeight:(CGFloat)height {
    self.CSSRule.height = height;
}

- (StylizeMargin)margin {
    return self.CSSRule.margin;
}

- (void)setMargin:(StylizeMargin)margin {
    self.CSSRule.margin = margin;
}

- (void)setPadding:(StylizePadding)padding {
    _padding = padding;
}

- (BOOL)isFlex {
    return _CSSRule.flex > 0 && (_CSSRule.position == StylizePositionTypeRelative || _CSSRule.position == StylizePositionTypeStatic);
}

- (BOOL)isFlexWrap {
    return _CSSRule.flexWrap != StylizeLayoutFlexFlexWrapNowrap;
}

#pragma mark - Public Method

- (void)addSubnode:(StylizeNode *)subnode {
    [self insertSubnode:subnode atIndex:[_subnodes count]];
}

- (void)insertSubnode:(StylizeNode *)subnode before:(StylizeNode *)before {
    NSAssert(before.supernode == self, @"the parent of before node should be the current node.");
    NSInteger index = [_subnodes indexOfObject:before];
    [self insertSubnode:subnode atIndex:index];
}

- (void)insertSubnode:(StylizeNode *)subnode after:(StylizeNode *)after {
    NSAssert(after.supernode == self, @"the parent of after node should be the current node.");
    NSInteger index = [_subnodes indexOfObject:after];
    [self insertSubnode:subnode atIndex:index + 1];
}

- (void)insertSubnode:(StylizeNode *)subnode atIndex:(NSInteger)index {
    if (index > [_subnodes count]) {
        index = [_subnodes count];
    }
    
    if (subnode.supernode) {
        [subnode removeFromSupernode];
    }
    
    NSMutableArray *subnodes = [self.subnodes mutableCopy];
    subnode.supernode = self;
    [subnodes insertObject:subnode atIndex:index];
    [self.view insertSubview:subnode.view atIndex:index];
    _subnodes = [subnodes copy];
    
    [self layout];
}

- (void)replaceSubnode:(StylizeNode *)subnode withSubnode:(StylizeNode *)replacement {
    NSAssert(subnode.supernode == self, @"the parent of subnode should be the current node.");
    NSInteger index = [_subnodes indexOfObject:subnode];
    
    [subnode removeFromSupernode];
    [self insertSubnode:replacement atIndex:index];
}

- (void)removeFromSupernode {
    if (_supernode) {
        [_view removeFromSuperview];
        NSMutableArray *subnodes = [_supernode.subnodes mutableCopy];
        [subnodes removeObject:self];
        _supernode.subnodes = [subnodes copy];
    }
}

- (void)applyCSSRule:(StylizeCSSRule *)CSSRule {
    //TODO
}

- (void)applyCSSRaw:(NSString *)CSSRaw {

}

- (void)layout {
    if (self.layoutType==StylizeLayoutTypeFlex && [_subnodes count] > 0) {
        [self layoutFlexSubnodes];
    }
}

#pragma mark - Private Method

- (CGSize)makeComputedSize:(CGFloat)mainAxisSize cross:(CGFloat)crossAxisSize {
    return [StylizeNode isHorizontalDirection:_CSSRule.flexDirection] ? (CGSize){mainAxisSize, crossAxisSize} : (CGSize){crossAxisSize, mainAxisSize};
}

- (void)layoutFlexSubnodes {
    [self layoutFlexSubnodesPreLoop];
    [self layoutFlexSubnodesMainLoop];
    for (StylizeNode *subnode in _subnodes) {
        NSLog(@"<StylizeNode> %@ Final: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
    }
}

- (void)layoutFlexSubnodesPreLoop {
    for (StylizeNode *subnode in self.subnodes) {
        
        
        NSLog(@"<StylizeNode> %@ PreLoop Before: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
        
        //set or reset
        [StylizeNode setNodePosition:subnode direction:StylizeLayoutFlexDirectionRow value:0];
        [StylizeNode setNodePosition:subnode direction:StylizeLayoutFlexDirectionColumn value:0];
        [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionRow value:subnode.CSSRule.width];
        [StylizeNode setNodeDimension:subnode direction:StylizeLayoutFlexDirectionColumn value:subnode.CSSRule.height];
        
        NSLog(@"<StylizeNode> %@ PreLoop Reset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
        
        
        /**
         *  处理子节点未设置的尺寸的情况,绝对定位元素尺寸由自身位置信息决定，非绝对定位元素如果尺寸由布局信息决定
         */
        
        CGFloat dimensionAxis;
        if (subnode.CSSRule.position != StylizePositionTypeAbsolute &&
            _CSSRule.alignItems == StylizeLayoutFlexAlignStretch &&
//            [StylizeNode isDimensionDefined:self direction:_CSSRule.flexCrossDirection] &&
            ![StylizeNode isDimensionDefined:subnode direction:_CSSRule.flexCrossDirection]) {
            dimensionAxis = MAX([StylizeNode getDimension:subnode direction:_CSSRule.flexCrossDirection], [StylizeNode getNodeDimension:self direction:_CSSRule.flexCrossDirection] - [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:_CSSRule.flexCrossDirection]);
            [StylizeNode setNodeDimension:subnode direction:_CSSRule.flexCrossDirection value:dimensionAxis];
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
        
        NSLog(@"<StylizeNode> %@ PreLoop After: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
    }
}

- (void)layoutFlexSubnodesMainLoop {
    NSLog(@"nodeID:%@ is Layout in parent", self.nodeID);
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
    
    definedMainDim = [StylizeNode getNodeDimension:self direction:_CSSRule.flexDirection] - [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection];
    
    while (endLine < [_subnodes count]) {
        /**
         *  计算主轴尺寸信息
         */
        for (NSInteger i = startLine; i < [_subnodes count]; ++i) {
            StylizeNode *subnode = _subnodes[i];
            if (subnode.CSSRule.flex > 0 &&
                subnode.CSSRule.position != StylizePositionTypeAbsolute) {
                flexibleSubnodeCount++;
                totalFlexible += subnode.CSSRule.flex;
                
                nextContentDim = [StylizeNode getPaddingandBorder:subnode direction:_CSSRule.flexDirection];
                nextContentDim += [StylizeNode getMargin:subnode direction:_CSSRule.flexDirection];
            } else {
                if (alreadyComputedNextLayout == 0) {
                    [subnode layout];
                }
                
                if (subnode.CSSRule.position != StylizePositionTypeAbsolute) {
                    nonFlexibleSubnodeCount++;
                    nextContentDim = [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexDirection];
                    nextContentDim += [StylizeNode getPaddingandBorder:subnode direction:_CSSRule.flexDirection];
                    nextContentDim += [StylizeNode getMargin:subnode direction:_CSSRule.flexDirection];
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
                StylizeNode *subnode = _subnodes[i];
                
                if (subnode.isFlex) {
                    CGFloat dim = flexibleMainDim * subnode.CSSRule.flex + [StylizeNode getPaddingandBorder:subnode direction:_CSSRule.flexDirection];
                    [StylizeNode setNodeDimension:subnode direction:_CSSRule.flexDirection value:dim];
                    [subnode layout];
                    NSLog(@"<StylizeNode> %@ MainLoop FlexibleDimension: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
                }
            } //end of second loop
        } else {
            /**
             *  不存在可扩展子节点的情况下结算剩余空间
             */
            if (_CSSRule.justifyContent == StylizeLayoutFlexJustifyContentCenter) {
                leadingMainDim = remainingMainDim / 2;
            } else if (_CSSRule.justifyContent == StylizeLayoutFlexJustifyContentFlexEnd) {
                leadingMainDim = remainingMainDim;
            } else if (_CSSRule.justifyContent == StylizeLayoutFlexJustifyContentSpaceBetween) {
                remainingMainDim = MAX(remainingMainDim, 0);
                if (flexibleSubnodeCount + nonFlexibleSubnodeCount - 1 >0) {
                    betweenMainDim = remainingMainDim / (flexibleSubnodeCount + nonFlexibleSubnodeCount - 1);
                } else {
                    betweenMainDim = 0;
                }
            } else if (_CSSRule.justifyContent == StylizeLayoutFlexJustifyContentSpaceAround) {
                betweenMainDim = remainingMainDim / (flexibleSubnodeCount + nonFlexibleSubnodeCount);
                leadingMainDim = betweenMainDim / 2;
            }
        }
        
        CGFloat crossDim = 0;
        CGFloat mainDim = leadingMainDim + [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
        
        /**
         *  计算主轴位置信息
         */
        for (NSInteger i = startLine; i < endLine; ++i) {
            StylizeNode *subnode = _subnodes[i];
            CGFloat offsetMainAxis;
            if (subnode.CSSRule.position == StylizePositionTypeAbsolute &&
                [StylizeNode isPositionDefined:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetMainAxis = [StylizeNode getPosition:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                offsetMainAxis += [StylizeNode getBorder:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                offsetMainAxis += [StylizeNode getMargin:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading];
                
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexDirection value:offsetMainAxis];
            } else {
                offsetMainAxis = [StylizeNode getPosition:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading] + mainDim;
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexDirection value:offsetMainAxis];
            }
            
            NSLog(@"<StylizeNode> %@ MainLoop MainAsixOffset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
            
            if (subnode.CSSRule.position == StylizePositionTypeRelative ||
                subnode.CSSRule.position == StylizePositionTypeStatic) {
                mainDim += betweenMainDim + [StylizeNode getMargin:subnode direction:_CSSRule.flexDirection] + [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexDirection];
                crossDim = MAX(crossDim, [StylizeNode getMargin:subnode direction:_CSSRule.flexCrossDirection] + [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexCrossDirection]);
            }
        } //end of third loop
        
        CGFloat containerMainAxis = [StylizeNode getNodeDimension:self direction:_CSSRule.flexDirection];
        CGFloat containerCrossAxis = [StylizeNode getNodeDimension:self direction:_CSSRule.flexCrossDirection];
        CGFloat computedContainerMainAxis = MAX(mainDim + [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection]);
        CGFloat computedContainerCrossAxis = MAX(crossDim + [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection]);
        
        _computedSize = [self makeComputedSize:computedContainerMainAxis cross:computedContainerCrossAxis];
        containerMainAxis = containerMainAxis == 0 ? computedContainerMainAxis : containerMainAxis;
        containerCrossAxis = containerCrossAxis == 0 ? computedContainerCrossAxis : containerCrossAxis;
        
        for (NSInteger i = startLine; i < endLine; ++i) {
            StylizeNode *subnode = _subnodes[i];
            CGFloat offsetCrossAxis = 0;
            
            if (subnode.CSSRule.position == StylizePositionTypeAbsolute &&
                [StylizeNode isPositionDefined:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetCrossAxis = [StylizeNode getPosition:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading] + [StylizeNode getMargin:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading] + [StylizeNode getBorder:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading];
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexCrossDirection value:offsetCrossAxis];
            } else {
                CGFloat leadingCrossDim = [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading];
                if (subnode.CSSRule.position == StylizePositionTypeRelative ||
                    subnode.CSSRule.position == StylizePositionTypeStatic) {
                    StylizeLayoutFlexAlign alignSelf = subnode.CSSRule.alignSelf;
                    
                    if (alignSelf == StylizeLayoutFlexAlignStretch) {
                        CGFloat itemCrossDim = MAX(containerCrossAxis - [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:_CSSRule.flexCrossDirection], [StylizeNode getPaddingandBorder:subnode direction:_CSSRule.flexCrossDirection]);
                        [StylizeNode setNodeDimension:subnode direction:_CSSRule.flexCrossDirection value:itemCrossDim];
                    } else if (alignSelf != StylizeLayoutFlexAlignFlexStart){
                        CGFloat remainingCrossDim = containerCrossAxis - [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection] - [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexCrossDirection] - [StylizeNode getMargin:subnode direction:_CSSRule.flexCrossDirection];
                        if (alignSelf == StylizeLayoutFlexAlignCenter) {
                            leadingCrossDim += remainingCrossDim / 2;
                        } else {
                            leadingCrossDim += remainingCrossDim;
                        }
                    }
                }
                
                offsetCrossAxis = [StylizeNode getNodePosition:subnode direction:_CSSRule.flexCrossDirection];
                offsetCrossAxis += linesCrossDim + leadingCrossDim;
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexCrossDirection value:offsetCrossAxis];
            }
            
            NSLog(@"<StylizeNode> %@ MainLoop CrossAsixOffset: <StylizeNode> %@, frame = {(%.2f,%.2f),(%.2f,%.2f)}", self.nodeID, subnode.nodeID, subnode.frame.origin.x, subnode.frame.origin.y, subnode.frame.size.width, subnode.frame.size.height);
            
        } //end of fourth loop
        
        linesCrossDim += crossDim;
        linesMainDim = MAX(linesMainDim, mainDim);
        startLine = endLine;
    } //end of main while
    
    if ([StylizeNode getDimension:self direction:_CSSRule.flexDirection] == 0) {
        [StylizeNode setNodeDimension:self direction:_CSSRule.flexDirection value:MAX(linesMainDim + [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing], [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexDirection])];
    }
    
    if ([StylizeNode getDimension:self direction:_CSSRule.flexCrossDirection] == 0) {
        [StylizeNode setNodeDimension:self direction:_CSSRule.flexCrossDirection value:MAX(linesCrossDim + [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection], [StylizeNode getPaddingandBorder:self direction:_CSSRule.flexCrossDirection])];
    }
   
    for (StylizeNode *subnode in _subnodes) {
        if (subnode.CSSRule.position == StylizePositionTypeAbsolute) {
            CGFloat offsetAxis = 0;
            if ([StylizeNode isPositionDefined:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing] &&
                ![StylizeNode isPositionDefined:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetAxis = [StylizeNode getNodeDimension:self direction:_CSSRule.flexDirection] - [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexDirection] - [StylizeNode getPosition:subnode direction:_CSSRule.flexDirection location:StylizeNodeBoxLocationTypeTrailing];
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexDirection value:offsetAxis];
            }
            
            if ([StylizeNode isPositionDefined:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing] &&
                ![StylizeNode isPositionDefined:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeLeading]) {
                offsetAxis = [StylizeNode getNodeDimension:self direction:_CSSRule.flexCrossDirection] - [StylizeNode getNodeDimension:subnode direction:_CSSRule.flexCrossDirection] - [StylizeNode getPosition:subnode direction:_CSSRule.flexCrossDirection location:StylizeNodeBoxLocationTypeTrailing];
                [StylizeNode setNodePosition:subnode direction:_CSSRule.flexCrossDirection value:offsetAxis];
            }
        }
    }
}

#pragma mark - SuperClass Method and Protocol

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == PrivateKVOContext) {
        if ([keyPath isEqualToString:@"observerPropertyLayout"]) {
            [self layout];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLayoutEvent:(StylizeLayoutEvent *)layoutEvent {
    //TODO
}


@end
