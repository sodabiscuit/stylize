//
//  StylizeCSSRule.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <objc/runtime.h>
#import "StylizeCSSRule.h"
#import "StylizeCSSRuleParser.h"

static void *PrivateKVOContext = &PrivateKVOContext;

@interface StylizeCSSRule()

@end

@implementation StylizeCSSRule

- (instancetype)init {
    if (self = [super init]) {
        _ruleUUID = [NSString stringWithFormat:@"%@", [[[NSUUID alloc] init] UUIDString]];
        
        _position = StylizePositionTypeRelative;
        _display = StylizeDisplayBlock;
        _visibility = StylizeVisibilityVisible;
        
        _flexDirection = StylizeLayoutFlexDirectionRow;
        _justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
        _alignItems = StylizeLayoutFlexAlignStretch;
        _flexWrap = StylizeLayoutFlexFlexWrapNowrap;
        _alignContent = StylizeLayoutFlexAlignStretch;
        _alignSelf = StylizeLayoutFlexAlignAuto;
        _flex = 0;
        
        _backgroundColor = [UIColor whiteColor];
        _color = [UIColor blackColor];
        
        _textAlign = StylizeTextAlignLeft;
        _opacity = 1;
        
        _fontSize = 14;
        _fontWeight = 400;
        
        _ruleKeys = [self.class getAllRuleKeys];
    }
    return self;
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

- (StylizeOrdered)padding {
    StylizeOrdered ret;
    ret.ordered[StylizeRuleOrderedTypeTop] = self.paddingTop;
    ret.ordered[StylizeRuleOrderedTypeRight] = self.paddingRight;
    ret.ordered[StylizeRuleOrderedTypeBottom] = self.paddingBottom;
    ret.ordered[StylizeRuleOrderedTypeLeft] = self.paddingLeft;
    return ret;
}

- (void)setPadding:(StylizeOrdered)padding {
    _paddingTop = padding.ordered[StylizeRuleOrderedTypeTop];
    _paddingRight = padding.ordered[StylizeRuleOrderedTypeRight];
    _paddingBottom = padding.ordered[StylizeRuleOrderedTypeBottom];
    _paddingLeft = padding.ordered[StylizeRuleOrderedTypeLeft];
}

- (StylizeOrdered)margin {
    StylizeOrdered ret;
    ret.ordered[StylizeRuleOrderedTypeTop] = self.marginTop;
    ret.ordered[StylizeRuleOrderedTypeRight] = self.marginRight;
    ret.ordered[StylizeRuleOrderedTypeBottom] = self.marginBottom;
    ret.ordered[StylizeRuleOrderedTypeLeft] = self.marginLeft;
    return ret;
}

- (void)setMargin:(StylizeOrdered)margin {
    _marginTop = margin.ordered[StylizeRuleOrderedTypeTop];
    _marginRight = margin.ordered[StylizeRuleOrderedTypeRight];
    _marginBottom = margin.ordered[StylizeRuleOrderedTypeBottom];
    _marginLeft = margin.ordered[StylizeRuleOrderedTypeLeft];
}

- (StylizeOrdered)borderWidth {
    StylizeOrdered ret;
    ret.ordered[StylizeRuleOrderedTypeTop] = self.borderTopWidth;
    ret.ordered[StylizeRuleOrderedTypeRight] = self.borderRightWidth;
    ret.ordered[StylizeRuleOrderedTypeBottom] = self.borderBottomWidth;
    ret.ordered[StylizeRuleOrderedTypeLeft] = self.borderLeftWidth;
    return ret;
}

- (void)setBorderWidth:(StylizeOrdered)borderWidth {
    _borderTopWidth = borderWidth.ordered[StylizeRuleOrderedTypeTop];
    _borderRightWidth = borderWidth.ordered[StylizeRuleOrderedTypeRight];
    _borderBottomWidth = borderWidth.ordered[StylizeRuleOrderedTypeBottom];
    _borderLeftWidth = borderWidth.ordered[StylizeRuleOrderedTypeLeft];
}

- (StylizeOverflow)overflow {
    return (StylizeOverflow){self.overflowX, self.overflowY};
}

- (void)setOverflow:(StylizeOverflow)overflow {
    _overflowX = overflow.overflowX;
    _overflowY = overflow.overflowY;
}

- (CGSize)maxSize {
    return (CGSize){_maxWidth, _maxHeight};
}

- (CGSize)minSize {
    return (CGSize){_minWidth, _minHeight};
}

- (StylizeLayoutFlexFlow)flexFlow {
    return (StylizeLayoutFlexFlow){self.flexDirection, self.flexWrap};
}

- (void)setFlexFlow:(StylizeLayoutFlexFlow)flexFlow {
    _flexDirection = flexFlow.direction;
    _flexWrap = flexFlow.flexWrap;
}

- (UIFont *)font {
    if (_font) {
        return _font;
    }
    
    if (_fontWeight >= 700) {
        if (_fontFamily.length > 0) {
            return [UIFont fontWithName:_fontFamily size:_fontSize];
        } else {
            return [UIFont boldSystemFontOfSize:_fontSize];
        }
    } else {
        if (_fontFamily.length > 0) {
            return [UIFont fontWithName:_fontFamily size:_fontSize];
        } else {
            return [UIFont systemFontOfSize:_fontSize];
        }
    }
    
    return [UIFont systemFontOfSize:14];
}

- (void)setOpacity:(CGFloat)opacity {
    if (opacity < 0) {
        _opacity = 0;
    } else if (opacity > 1) {
        _opacity = 1;
    } else {
        _opacity = opacity;
    }
}

- (StylizeOrdered)borderRadius {
    StylizeOrdered ret;
    ret.ordered[StylizeRuleOrderedTypeTop] = self.borderTopLeftRadius;
    ret.ordered[StylizeRuleOrderedTypeRight] = self.borderTopRightRadius;
    ret.ordered[StylizeRuleOrderedTypeBottom] = self.borderBottomRightRadius;
    ret.ordered[StylizeRuleOrderedTypeLeft] = self.borderBottomLeftRadius;
    return ret;
}

- (void)setBorderRadius:(StylizeOrdered)borderRadius {
    _borderTopLeftRadius = borderRadius.ordered[StylizeRuleOrderedTypeTop];
    _borderTopRightRadius = borderRadius.ordered[StylizeRuleOrderedTypeRight];
    _borderBottomRightRadius = borderRadius.ordered[StylizeRuleOrderedTypeBottom];
    _borderBottomLeftRadius = borderRadius.ordered[StylizeRuleOrderedTypeLeft];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    StylizeCSSRule *CSSRule = [[[self class] allocWithZone:zone] init];
    return CSSRule;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
//    if ([key isEqualToString:@"border"]) {
//        NSSet *affectingKeys = [NSSet setWithObjects:@"borderTop", @"borderRight", @"borderBottom", nil];
//        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKeys];
//    }
    
    return keyPaths;
}

- (void)updateDefinedRules:(NSArray *)rules {
    if ([rules count] == 0) {
        return;
    }
    
    for (NSString *rule in rules) {
        if ([rule isKindOfClass:[NSString class]] && rule.length > 0) {
            NSString *prefix = [rule substringToIndex:1];
            if ([prefix isEqualToString:@"-"]) {
                NSString *ruleKey = [rule substringFromIndex:1];
                [self resetDefault:ruleKey];
            }
        }
    }
}

- (void)resetDefault:(NSString *)key {
    //TODO
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

- (void)updatePositionAndDimensionFromRect:(CGRect)rect {
    self.top = rect.origin.x;
    self.left = rect.origin.y;
    self.width = rect.size.width;
    self.height = rect.size.height;
}

+ (NSArray *)getLayoutAffectedRuleKeys {
    return @[@"top", @"right", @"bottom", @"left",
             @"margin", @"marginTop", @"marginRight", @"marginBottom", @"marginLeft",
             @"padding", @"paddingTop", @"paddingRight", @"paddingBottom", @"paddingBottom",
             @"width", @"height", @"maxWidth", @"maxHeight", @"minWidth", @"minHeight",
             @"borderTopWidth", @"borderRightWidth", @"borderBottomWidth", @"borderLeftWidth",
             @"borderTopLeftRadius", @"borderTopRightRadius", @"borderBottomRightRadius", @"borderBottomLeftRadius",
             @"flexDirection", @"justifyContent", @"alignItems", @"alignContent", @"alignSelf", @"flexWrap", @"flex",
             @"position", @"display", @"visibility", @"overflow", @"overflowX", @"overflowY",
             @"font"];
}

+ (NSArray *)getBothAffectedRuleKeys {
    return @[@"display", @"visibility"];
}

+ (NSArray *)getUnAffectedRuleKeys {
    return @[@"ruleUUID", @"ruleKeys"];
}

+ (NSArray *)getRenderAffectedRuleKeys {
    NSMutableArray *ret = [@[] mutableCopy];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self, &count);  // see imports above!
    for (size_t i = 0; i < count; ++i) {
        NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSASCIIStringEncoding];
        
        if ([[self getLayoutAffectedRuleKeys] indexOfObject:property] == NSNotFound &&
            [[self getUnAffectedRuleKeys] indexOfObject:property] == NSNotFound) {
            [ret addObject: property];
        }
    }
    free(properties);
    
    return [ret copy];
}

+ (NSArray *)getAllRuleKeys {
    NSMutableArray *ret = [@[] mutableCopy];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self, &count);  // see imports above!
    for (size_t i = 0; i < count; ++i) {
        NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                encoding:NSASCIIStringEncoding];
        
        if ([[self getUnAffectedRuleKeys] indexOfObject:property] == NSNotFound) {
            [ret addObject: property];
        }
    }
    free(properties);
    
    return [ret copy];
}


@end
