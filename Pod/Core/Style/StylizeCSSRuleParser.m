//
//  StylizeCSSRuleParser.m
//  StylizeDemo
//
//  Created by Yulin Ding on 4/13/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSRuleParser.h"
#import "StylizeCSSRule.h"
#import "StylizeUtility.h"

@implementation StylizeCSSRuleParser

+ (void)applyCSSRaw:(NSString *)CSSRaw
                 to:(StylizeCSSRule *)CSSRule {
    NSSet *CSSSet = [NSSet setWithArray:[CSSRaw componentsSeparatedByString:@";"]];
    
    [CSSSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSArray *keyAndValue = [obj componentsSeparatedByString:@":"];
        if ([keyAndValue count] != 2) {
            return;
        }
        
        NSString *key = [keyAndValue[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value = [keyAndValue[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self setRule:value forKey:key pseudoKey:nil inRule:CSSRule];
    }];
}

+ (void)applyCSSDictionary:(NSDictionary *)CSSDictionary
                        to:(StylizeCSSRule *)CSSRule {
    [CSSDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:[NSString class]]) {
            NSString *k = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([k hasPrefix:@":"] &&
                [obj isKindOfClass:[NSDictionary class]]) {
                NSString *pseudo = [k substringFromIndex:1];
                [((NSDictionary *)obj) enumerateKeysAndObjectsUsingBlock:^(id pseudoKey, id pseudoObj, BOOL *pseudoStop) {
                    pseudoKey = [pseudoKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if ([pseudoObj isKindOfClass:[NSString class]]) {
                        NSString *val = [pseudoObj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        [self setRule:val forKey:pseudoKey pseudoKey:pseudo inRule:CSSRule];
                    } else {
                        [self setRuleObject:pseudoObj forKey:pseudoKey pseudoKey:pseudo inRule:CSSRule];
                    }
                }];
            } else {
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *val = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [self setRule:val forKey:k pseudoKey:nil inRule:CSSRule];
                } else {
                    [self setRuleObject:obj forKey:k pseudoKey:nil inRule:CSSRule];
                }
            }
        }
    }];
}

+ (NSString *)getRuleKey:(NSString *)key {
    NSArray *keys = [key componentsSeparatedByString:@"-"];
    
    NSMutableString *ret = [@"" mutableCopy];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != 0) {
            [ret appendString:[((NSString *)obj) capitalizedString]];
        } else {
            [ret appendString:obj];
        }
    }];
    
    return ret;
}

+ (void)setRuleObject:(id)value
               forKey:(NSString *)key
            pseudoKey:(NSString *)pseudo
               inRule:(StylizeCSSRule *)CSSRule {
    NSString *ruleKey = [self getRuleKey:key];
    pseudo = pseudo.length > 0 ? pseudo : @"";
    NSString *outputKey = [NSString stringWithFormat:@"%@%@", ruleKey, [pseudo capitalizedString]];
    
    if ([CSSRule.ruleKeys indexOfObject:ruleKey] == NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStylizeCSSRuleParserUnrecoginzeNotification
                                                            object:@{@"ruleUUID": CSSRule.ruleUUID,
                                                                     @"key" : key,
                                                                     @"value": value}];
        return;
    }
    
    if ([ruleKey isEqualToString:@"font"]) {
        if ([value isKindOfClass:[UIFont class]]) {
            [CSSRule setValue:value forKey:outputKey];
        }
        return;
    }
    
    if ([ruleKey hasPrefix:@"backgroundColor"] ||
        [ruleKey hasPrefix:@"color"]) {
        if ([value isKindOfClass:[UIColor class]]) {
            [CSSRule setValue:value forKey:outputKey];
        }
        return;
    }
    
    if ([ruleKey isEqualToString:@"top"] ||
        [ruleKey isEqualToString:@"right"] ||
        [ruleKey isEqualToString:@"bottom"] ||
        [ruleKey isEqualToString:@"left"] ||
        [ruleKey isEqualToString:@"width"] ||
        [ruleKey isEqualToString:@"height"] ||
        [ruleKey isEqualToString:@"maxWidth"] ||
        [ruleKey isEqualToString:@"maxHeight"] ||
        [ruleKey isEqualToString:@"minWidth"] ||
        [ruleKey isEqualToString:@"minHeight"] ||
        ([ruleKey hasPrefix:@"margin"] && ![ruleKey isEqualToString:@"margin"]) ||
        ([ruleKey hasPrefix:@"padding"] && ![ruleKey isEqualToString:@"padding"]) ||
        [ruleKey isEqualToString:@"opacity"] ||
        [ruleKey isEqualToString:@"fontSize"]
        ) {
        if ([value isKindOfClass:[NSNumber class]]) {
            [CSSRule setValue:value forKey:outputKey];
        }
        return;
    }
    
}

+ (void)setRule:(NSString *)value
         forKey:(NSString *)key
      pseudoKey:(NSString *)pseudo
         inRule:(StylizeCSSRule *)CSSRule {
    NSString *ruleKey = [self getRuleKey:key];
    pseudo = pseudo.length > 0 ? pseudo : @"";
    NSString *outputKey = [NSString stringWithFormat:@"%@%@", ruleKey, [pseudo capitalizedString]];
    
    if ([CSSRule.ruleKeys indexOfObject:ruleKey] == NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStylizeCSSRuleParserUnrecoginzeNotification
                                                            object:@{@"ruleUUID": CSSRule.ruleUUID,
                                                                     @"key" : key,
                                                                     @"value": value}];
        return;
    }
    
    if ([ruleKey isEqualToString:@"padding"] ||
        [ruleKey isEqualToString:@"margin"] ||
        [ruleKey isEqualToString:@"borderRadius"] ||
        [ruleKey isEqualToString:@"borderWidth"]) {
        [StylizeCSSRuleParser setRuleOrdered:value
                                      forKey:key
                                   pseudoKey:pseudo
                                      inRule:CSSRule];
        return;
    }
    
    if ([ruleKey isEqualToString:@"top"] ||
        [ruleKey isEqualToString:@"right"] ||
        [ruleKey isEqualToString:@"bottom"] ||
        [ruleKey isEqualToString:@"left"] ||
        [ruleKey isEqualToString:@"width"] ||
        [ruleKey isEqualToString:@"height"] ||
        [ruleKey isEqualToString:@"maxWidth"] ||
        [ruleKey isEqualToString:@"maxHeight"] ||
        [ruleKey isEqualToString:@"minWidth"] ||
        [ruleKey isEqualToString:@"minHeight"] ||
        [ruleKey hasPrefix:@"margin"] ||
        [ruleKey hasPrefix:@"padding"] ||
        [ruleKey isEqualToString:@"opacity"] ||
        [ruleKey isEqualToString:@"fontSize"] ||
        ([ruleKey hasPrefix:@"border"] && [ruleKey hasSuffix:@"Radius"]) ||
        ([ruleKey hasPrefix:@"border"] && [ruleKey hasSuffix:@"Width"])
        ) {
        [CSSRule setValue:[NSNumber numberWithDouble:[value doubleValue]] forKey:outputKey];
        return;
    }
    
    if ([ruleKey isEqualToString:@"fontWeight"]
        ) {
        if ([value isEqualToString:@"normal"]) {
            [CSSRule setValue:[NSNumber numberWithInteger:400] forKey:outputKey];
        } else if ([value isEqualToString:@"bold"]) {
            [CSSRule setValue:[NSNumber numberWithInteger:700] forKey:outputKey];
        } else if ([value integerValue] >= 100) {
            [CSSRule setValue:[NSNumber numberWithInteger:[value integerValue]] forKey:outputKey];
        }
    }
    
    if ([ruleKey isEqualToString:@"position"] ||
        [ruleKey isEqualToString:@"flexDirection"] ||
        [ruleKey isEqualToString:@"flexWrap"] ||
        [ruleKey isEqualToString:@"justifyContent"] ||
        [ruleKey isEqualToString:@"alignItems"] ||
        [ruleKey isEqualToString:@"alignSelf"] ||
        [ruleKey isEqualToString:@"alignContent"]
        ) {
        [CSSRule setValue:[self getEnumValue:ruleKey value:value] forKey:outputKey];
        return;
    }
    
    if ([ruleKey isEqualToString:@"flex"]) {
        [CSSRule setValue:[NSNumber numberWithInteger:[value integerValue]] forKey:outputKey];
        return;
    }
    
    
    if ([ruleKey isEqualToString:@"display"] ||
        [ruleKey isEqualToString:@"visibility"]
        ) {
        [CSSRule setValue:[self getEnumValue:ruleKey value:value] forKey:outputKey];
        return;
    }
    
    if ([ruleKey isEqualToString:@"color"] ||
        [ruleKey isEqualToString:@"backgroundColor"]
        ) {
        if ([value hasPrefix:@"#"]) {
            [CSSRule setValue:[StylizeColorUtility colorWithHexString:value] forKey:outputKey];
        } else {
            [CSSRule setValue:[self getPresetColor:value] forKey:outputKey];
        }
        return;
    }
    
    if ([ruleKey isEqualToString:@"textAlign"]) {
        [CSSRule setValue:[self getEnumValue:ruleKey value:value] forKey:outputKey];
        return;
    }
}

+ (void)setRuleOrdered:(NSString *)value
                forKey:(NSString *)key
             pseudoKey:(NSString *)pseudo
                inRule:(StylizeCSSRule *)CSSRule {
    NSString *ruleKey = [self getRuleKey:key];
    pseudo = pseudo.length > 0 ? pseudo : @"";
    NSString *outputKey = [NSString stringWithFormat:@"%@%@", ruleKey, [pseudo capitalizedString]];
    
    NSString *orderedValueStr = [StylizeRegexUtility string:value
                                                         replace:@"\\s+"
                                                            with:@","
                                                      ignoreCase:YES];
    NSArray *orderedArray = [orderedValueStr componentsSeparatedByString:@","];
    StylizeOrdered ordered;
    
    if ([orderedArray count] == 4) {
        ordered = StylizeOrderedMake([orderedArray[0] doubleValue],
                                     [orderedArray[1] doubleValue],
                                     [orderedArray[2] doubleValue],
                                     [orderedArray[3] doubleValue]);
    } else if ([orderedArray count] == 3) {
        ordered = StylizeOrderedMake([orderedArray[0] doubleValue],
                                     [orderedArray[1] doubleValue],
                                     [orderedArray[2] doubleValue],
                                     [orderedArray[1] doubleValue]);
    } else if ([orderedArray count] == 2) {
        ordered = StylizeOrderedMake([orderedArray[0] doubleValue],
                                     [orderedArray[1] doubleValue],
                                     [orderedArray[0] doubleValue],
                                     [orderedArray[1] doubleValue]);
    } else if ([orderedArray count] == 1) {
        ordered = StylizeOrderedMake([orderedArray[0] doubleValue],
                                     [orderedArray[0] doubleValue],
                                     [orderedArray[0] doubleValue],
                                     [orderedArray[0] doubleValue]);
    }
    
    NSValue *orderedValue = [NSValue valueWithBytes:&ordered objCType:@encode(StylizeOrdered)];
    [CSSRule setValue:orderedValue forKey:outputKey];
}

+ (NSNumber *)getEnumValue:(NSString *)key value:(NSString *)value {
    NSNumber *ret = [NSNumber numberWithInt:-9999];
    
    NSDictionary *dict = @{
                           @"borderStyle" : @{
                               @"solid" : [NSNumber numberWithInt:StylizeBorderTypeSolid],
                               @"dash" : [NSNumber numberWithInt:StylizeBorderTypeDash],
                               @"dotted" : [NSNumber numberWithInt:StylizeBorderTypeDotted],
                               @"_" : [NSNumber numberWithInt:StylizeBorderTypeSolid]
                           },
                           @"textAlign" : @{
                               @"left" : [NSNumber numberWithInt:StylizeTextAlignLeft],
                               @"right" : [NSNumber numberWithInt:StylizeTextAlignRight],
                               @"center" : [NSNumber numberWithInt:StylizeTextAlignCenter],
                               @"justify" : [NSNumber numberWithInt:StylizeTextAlignJustify],
                               @"_" : [NSNumber numberWithInt:StylizeTextAlignLeft]
                           },
                           @"flexDirection" : @{
                               @"row" : [NSNumber numberWithInt:StylizeLayoutFlexDirectionRow],
                               @"row-reverse" : [NSNumber numberWithInt:StylizeLayoutFlexDirectionRowReverse],
                               @"column" : [NSNumber numberWithInt:StylizeLayoutFlexDirectionColumn],
                               @"column-reverse" : [NSNumber numberWithInt:StylizeLayoutFlexDirectionColumnReverse],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexDirectionRow]
                           },
                           @"flexWrap" : @{
                               @"wrap" : [NSNumber numberWithInt:StylizeLayoutFlexFlexWrapWrap],
                               @"nowrap" : [NSNumber numberWithInt:StylizeLayoutFlexFlexWrapNowrap],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexFlexWrapNowrap]
                           },
                           @"justifyContent" : @{
                               @"flex-start" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentFlexStart],
                               @"flex-end" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentFlexEnd],
                               @"center" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentCenter],
                               @"space-between" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentSpaceBetween],
                               @"space-around" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentSpaceAround],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexJustifyContentFlexStart]
                           },
                           @"alignItems" : @{
                               @"flex-start" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexStart],
                               @"flex-end" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexEnd],
                               @"center" : [NSNumber numberWithInt:StylizeLayoutFlexAlignCenter],
                               @"auto" : [NSNumber numberWithInt:StylizeLayoutFlexAlignAuto],
                               @"stretch" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch]
                           },
                           @"alignSelf" : @{
                               @"flex-start" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexStart],
                               @"flex-end" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexEnd],
                               @"center" : [NSNumber numberWithInt:StylizeLayoutFlexAlignCenter],
                               @"auto" : [NSNumber numberWithInt:StylizeLayoutFlexAlignAuto],
                               @"stretch" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch]
                           },
                           @"alignContent" : @{
                               @"flex-start" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexStart],
                               @"flex-end" : [NSNumber numberWithInt:StylizeLayoutFlexAlignFlexEnd],
                               @"center" : [NSNumber numberWithInt:StylizeLayoutFlexAlignCenter],
                               @"auto" : [NSNumber numberWithInt:StylizeLayoutFlexAlignAuto],
                               @"stretch" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch],
                               @"_" : [NSNumber numberWithInt:StylizeLayoutFlexAlignStretch]
                           },
                           @"position" : @{
                               @"relative" : [NSNumber numberWithInt:StylizePositionTypeRelative],
                               @"absolute" : [NSNumber numberWithInt:StylizePositionTypeAbsolute],
                               @"_" : [NSNumber numberWithInt:StylizePositionTypeRelative]
                           },
                           @"visibility" : @{
                               @"visible" : [NSNumber numberWithInt:StylizeVisibilityVisible],
                               @"hidden" : [NSNumber numberWithInt:StylizeVisibilityHidden],
                               @"_" : [NSNumber numberWithInt:StylizeVisibilityVisible]
                           },
                           @"display" : @{
                               @"block" : [NSNumber numberWithInt:StylizeDisplayBlock],
                               @"inline" : [NSNumber numberWithInt:StylizeDisplayInline],
                               @"none" : [NSNumber numberWithInt:StylizeDisplayNone],
                               @"_" : [NSNumber numberWithInt:StylizeDisplayBlock]
                           },
                       };
    
    
    if (dict[key] && [dict[key] count] > 0) {
        if (dict[key][value]) {
            ret = dict[key][value];
        } else if (dict[key][@"_"]) {
            ret = dict[key][@"_"];
        }
    }
    
    return ret;
}

+ (UIColor *)getPresetColor:(NSString *)presetKey {
    UIColor *ret = [UIColor blackColor];
    
    NSDictionary *dict = @{
        @"black" : [UIColor blackColor],
        @"darkGray" : [UIColor darkGrayColor],
        @"lightGray" : [UIColor lightGrayColor],
        @"white" : [UIColor whiteColor],
        @"gray" : [UIColor grayColor],
        @"red" : [UIColor redColor],
        @"green" : [UIColor greenColor],
        @"blue" : [UIColor blueColor],
        @"cyan" : [UIColor cyanColor],
        @"yellow" : [UIColor yellowColor],
        @"magenta" : [UIColor magentaColor],
        @"orange" : [UIColor orangeColor],
        @"purple" : [UIColor purpleColor],
        @"brown" : [UIColor brownColor],
        @"transparent" : [UIColor clearColor],
    };
    
    if (dict[presetKey]) {
        ret = dict[presetKey];
    }
    
    return ret;
}

@end
