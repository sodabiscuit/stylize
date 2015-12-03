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
#import "StylizeCSSRuleParser.h"

static void *PrivateKVOContext = &PrivateKVOContext;

@interface StylizeCSSRule()

@property (nonatomic, strong) NSArray *layoutProperties;
@property (nonatomic, strong) NSMutableArray *definedRules;

@end

@implementation StylizeCSSRule

- (instancetype)init {
    if (self = [super init]) {
        
        self.ruleUUID = [NSString stringWithFormat:@"%@", [[[NSUUID alloc] init] UUIDString]];
        self.position = StylizePositionTypeRelative;
        self.display = StylizeDisplayBlock;
        self.visibility = StylizeVisibilityVisible;
        
        self.flexDirection = StylizeLayoutFlexDirectionRow;
        self.justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
        self.alignItems = StylizeLayoutFlexAlignStretch;
        self.flexWrap = StylizeLayoutFlexFlexWrapNowrap;
        self.alignContent = StylizeLayoutFlexAlignStretch;
        self.alignSelf = StylizeLayoutFlexAlignAuto;
        self.flex = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        self.color = [UIColor blackColor];
        
        self.widthAuto = YES;
        self.heightAuto = YES;
        
        _definedRules = [@[@"color", @"backgroundColor",
                           @"postion", @"widthAuto", @"heightAuto",
                           @"display", @"visibility",
                           @"flexDirection", @"justifyContent", @"alignItems", @"flexWrap", @"alignContent", @"alignSelf", @"flex"] mutableCopy];
        
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
    _widthAuto = NO;
    [self updateDefinedRules:@[@"width", @"-widthAuto"]];
}

- (void)setWidthAuto:(BOOL)widthAuto {
    _widthAuto = widthAuto;
    [self updateDefinedRules:@[@"widthAuto", @"-width"]];
}

- (void)setHeight:(CGFloat)height {
    _height = height;
    _heightAuto = NO;
    [self updateDefinedRules:@[@"height", @"-heightAuto"]];
}

- (void)setHeightAuto:(BOOL)heightAuto {
    _heightAuto = heightAuto;
    [self updateDefinedRules:@[@"heightAuto", @"-height"]];
}

- (void)setTop:(CGFloat)top {
    _top = top;
    [self updateDefinedRules:@[@"top"]];
}

- (void)setBottom:(CGFloat)bottom {
    _bottom = bottom;
    [self updateDefinedRules:@[@"bottom"]];
}

- (void)setLeft:(CGFloat)left {
    _left = left;
    [self updateDefinedRules:@[@"left"]];
}

- (void)setRight:(CGFloat)right {
    _right = right;
    [self updateDefinedRules:@[@"right"]];
}

- (StylizePadding)padding {
    return (StylizePadding){self.paddingTop, self.paddingRight, self.paddingBottom, self.paddingLeft};
}

- (void)setPadding:(StylizePadding)padding {
    _paddingLeft = padding.paddingLeft;
    _paddingRight = padding.paddingRight;
    _paddingTop = padding.paddingTop;
    _paddingBottom = padding.paddingBottom;
    [self updateDefinedRules:@[@"padding", @"paddingLeft", @"paddingRight", @"paddingTop", @"paddingBottom"]];
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

- (void)setAlignSelf:(StylizeLayoutFlexAlign)alignSelf {
    _alignSelf = alignSelf;
    [self updateDefinedRules:@[@"alignSelf"]];
}

- (StylizeOverflow)overflow {
    return (StylizeOverflow){self.overflowX, self.overflowY};
}

- (void)setOverflow:(StylizeOverflow)overflow {
    _overflowX = overflow.overflowX;
    _overflowY = overflow.overflowY;
    [self updateDefinedRules:@[@"overflow", @"overflowX", @"overflowY"]];
}

- (CGSize)maxSize {
    return (CGSize){_maxWidth, _maxHeight};
}

- (CGSize)minSize {
    return (CGSize){_minWidth, _minHeight};
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

- (BOOL)isRuleDefined:(NSString *)ruleKey {
    return [_definedRules indexOfObject:ruleKey] != NSNotFound;
}

- (void)updateDefinedRules:(NSArray *)rules {
    if ([rules count] == 0) {
        return;
    }
    
    for (NSString *rule in rules) {
        if ([rule isKindOfClass:[NSString class]] && rule.length > 0) {
            NSString *prefix = [rule substringToIndex:1];
            if ([prefix isEqualToString:@"-"]) {
                NSString *ruleContent = [rule substringFromIndex:1];
                [_definedRules enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isEqualToString:ruleContent]) {
                        [_definedRules removeObject:obj];
                    }
                }];
            } else if ([_definedRules indexOfObject:rules] == NSNotFound) {
                [_definedRules addObject:rule];
            }
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //NOTHING
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)updateRuleFromDictionay:(NSDictionary *)ruleDictionary {
    [StylizeCSSRuleParser applyCSSDictionary:ruleDictionary to:self];
}

- (void)updateRuleFromRaw:(NSString *)ruleRaw {
    [StylizeCSSRuleParser applyCSSRaw:ruleRaw to:self];
}

- (void)updateRuleFromRule:(StylizeCSSRule *)rule {
    //TODO
}

@end
