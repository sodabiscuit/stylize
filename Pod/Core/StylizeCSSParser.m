//
//  StylizeCSSParser.m
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSParser.h"
#import "ESCssParser.h"

@implementation StylizeCSSParser

+ (NSDictionary *)parseCSSRaw:(NSString *)CSSRaw {
    ESCssParser *parser = [[ESCssParser alloc] init];
    NSDictionary *CSSDictionary = [parser parseText:CSSRaw];
    
    NSMutableDictionary *CSSRuleSet = [NSMutableDictionary dictionary];
    
    [CSSDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        StylizeCSSRule *rule = [StylizeCSSParser parseCSSDictionary:obj];
        [CSSRuleSet setObject:rule forKey:key];
    }];
    
    return [CSSRuleSet copy];
}

+ (NSString *)getRuleKey:(NSString *)key {
    NSString *ret = key;
    NSArray *keys = [key componentsSeparatedByString:@"-"];
    
    if ([keys count] == 2) {
        NSString *mainKey = keys[0];
        NSString *suffixKey = [keys[1] capitalizedString];
        ret = [NSString stringWithFormat:@"%@%@", mainKey, suffixKey];
    } else {
        //NOTHING
    }
    
    return ret;
}

+ (StylizeCSSRule *)parseCSSDictionary:(NSDictionary *)aDict {
    StylizeCSSRule *ret = [[StylizeCSSRule alloc] init];
    
    [aDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //TODO
    }];
    
    return ret;
}

@end
