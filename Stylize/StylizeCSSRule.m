//
//  StylizeCSSRule.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <objc/runtime.h>
#import "StylizeCSSRule.h"
#import "StylizeNode.h"

static void *PrivateKVOContext = &PrivateKVOContext;

@interface StylizeCSSRule()

@property (nonatomic,strong) NSArray *layoutProperties;
@property (nonatomic,strong) NSMutableArray *definedRules;

@end

@implementation StylizeCSSRule

- (void)dealloc {
//    [self removeObserver:self forKeyPath:@"observerPropertyAll"];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.position = StylizePositionTypeStatic;
        self.display = StylizeDisplayBlock;
        self.visibility = StylizeVisibilityVisible;
        
        self.flexDirection = StylizeLayoutFlexDirectionRow;
        self.justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
        self.alignItems = StylizeLayoutFlexAlignFlexStart;
        self.flexWrap = StylizeLayoutFlexFlexWrapNowrap;
        self.alignContent = StylizeLayoutFlexAlignContentStretch;
        
        self.alignSelf = StylizeLayoutFlexAlignStretch;
        
        _definedRules = [@[@"postion",
                           @"display", @"visibility",
                           @"flexDirection", @"justifyContent", @"alignItems", @"flexWrap", @"alignContent", @"alignSelf"] mutableCopy];
        
//        [self addObserver:self
//               forKeyPath:@"observerPropertyAll"
//                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                  context:PrivateKVOContext];
    }
    return self;
}

- (NSArray *)layoutProperties {
    return @[@"top", @"left"];
}

- (void)setWidth:(CGFloat)width {
    _width = width;
    [self updateDefinedRules:[NSArray arrayWithObject:@"width"]];
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    [self updateDefinedRules:[NSArray arrayWithObject:@"height"]];
}

- (void)setTop:(CGFloat)top {
    _top = top;
    [self updateDefinedRules:[NSArray arrayWithObject:@"top"]];
}

- (void)setBottom:(CGFloat)bottom {
    _bottom = bottom;
    [self updateDefinedRules:[NSArray arrayWithObject:@"bottom"]];
}

- (void)setLeft:(CGFloat)left {
    _left = left;
    [self updateDefinedRules:[NSArray arrayWithObject:@"left"]];
}

- (void)setRight:(CGFloat)right {
    _right = right;
    [self updateDefinedRules:[NSArray arrayWithObject:@"right"]];
}

- (StylizePadding)padding {
    return (StylizePadding){self.paddingTop, self.paddingRight, self.paddingBottom, self.paddingLeft};
}

- (void)setPadding:(StylizePadding)padding {
    _paddingLeft = padding.paddingLeft;
    _paddingRight = padding.paddingRight;
    _paddingTop = padding.paddingTop;
    _paddingBottom = padding.paddingBottom;
}

- (StylizeMargin)margin {
    return (StylizeMargin){self.marginTop, self.marginRight, self.marginBottom, self.marginLeft};
}

- (void)setMargin:(StylizeMargin)margin {
    _marginLeft = margin.marginLeft;
    _marginRight = margin.marginRight;
    _marginTop = margin.marginTop;
    _marginBottom = margin.marginBottom;
}

- (StylizeLayoutFlexFlow)flexFlow {
    return (StylizeLayoutFlexFlow){self.flexDirection, self.flexWrap};
}

- (void)setFlexFlow:(StylizeLayoutFlexFlow)flexFlow {
    _flexDirection = flexFlow.direction;
    _flexWrap = flexFlow.flexWrap;
}

- (StylizeLayoutFlexDirection)flexCrossDirection {
    StylizeLayoutFlexDirection ret = StylizeLayoutFlexDirectionColumn;
    if (_flexDirection == StylizeLayoutFlexDirectionColumn) {
        ret = StylizeLayoutFlexDirectionRow;
    } else if (_flexDirection == StylizeLayoutFlexDirectionColumnReverse) {
        ret = StylizeLayoutFlexDirectionRowReverse;
    } else if (_flex == StylizeLayoutFlexDirectionRowReverse) {
        ret = StylizeLayoutFlexDirectionColumnReverse;
    }
    return ret;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    StylizeCSSRule *CSSRule = [[[self class] allocWithZone:zone] init];
    return CSSRule;
}

+ (NSSet *)keyPathsForValuesAffectingObserverPropertyLayout {
    NSMutableArray *keys = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);  // see imports above!
    for (size_t i = 0; i < count; ++i) {
        NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSASCIIStringEncoding];
        
        if (![property isEqualToString:@"observerPropertyLayout"] &&
            ![property isEqualToString:@"observerPropertyOther"] &&
            ![property isEqualToString:@"observerPropertyAll"]) {
            [keys addObject:property];
        }
    }
    free(properties);
    return [NSSet setWithArray:keys];
    
}

+ (NSSet *)keyPathsForValuesAffectingObserverPropertyAll {
    NSMutableArray *keys = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);  // see imports above!
    for (size_t i = 0; i < count; ++i) {
        NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSASCIIStringEncoding];
        
        if (![property isEqualToString:@"observerPropertyLayout"] &&
            ![property isEqualToString:@"observerPropertyOther"] &&
            ![property isEqualToString:@"observerPropertyAll"]) {
            [keys addObject:property];
        }
    }
    free(properties);
    return [NSSet setWithArray:keys];
}

//+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
//    NSSet *ret = [super keyPathsForValuesAffectingValueForKey:key];
//    
//    if ([key isEqualToString:@"observerPropertyLayout"]) {
//        NSMutableArray *keys = [NSMutableArray array];
//        unsigned int count;
//        objc_property_t *properties = class_copyPropertyList([self class], &count);  // see imports above!
//        for (size_t i = 0; i < count; ++i) {
//            NSString *property = [NSString stringWithCString:property_getName(properties[i])
//                                                    encoding:NSASCIIStringEncoding];
//            
//            if (![property isEqualToString:@"observerPropertyLayout"]) {
//                [keys addObject: property];
//            }
//        }
//        free(properties);
//        ret = [ret setByAddingObjectsFromArray: keys];
//    }
//    return ret;
//}

- (BOOL)isRuleDefined:(NSString *)rule {
    return [_definedRules indexOfObject:rule] != NSNotFound;
}

- (void)updateDefinedRules:(NSArray *)rules {
    if ([rules count] == 0) {
        return;
    }
    
    for (NSString *rule in rules) {
        if ([rule isKindOfClass:[NSString class]] && [_definedRules indexOfObject:rules] == NSNotFound) {
            [_definedRules addObject:rule];
        }
    }
}

@end
