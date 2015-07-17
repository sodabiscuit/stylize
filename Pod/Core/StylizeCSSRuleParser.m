//
//  StylizeCSSRuleParser.m
//  StylizeDemo
//
//  Created by Yulin Ding on 4/13/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSRuleParser.h"
#import "StylizeCSSRule.h"

@interface StylizeCSSRuleParser()

@property (nonatomic,strong) NSString *CSSRaw;
@end

@implementation StylizeCSSRuleParser

- (instancetype)initWithCSSRaw:(NSString *)CSSRaw {
    if (self = [super init]) {
        [self parseCSSRaw:CSSRaw];
    }
    
    return self;
}

- (StylizeCSSRule *)parseCSSRaw:(NSString *)CSSRaw {
    _CSSRaw = CSSRaw;
    
    NSSet *CSSSet = [NSSet setWithArray:[_CSSRaw componentsSeparatedByString:@";"]];
    StylizeCSSRule *CSSRule = [[StylizeCSSRule alloc] init];
    
    [CSSSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSArray *keyAndValue = [obj componentsSeparatedByString:@":"];
        if ([keyAndValue count] != 2) {
            return;
        }
        
        NSString *key = [keyAndValue[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value = [keyAndValue[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self setRule:value forKey:key inRule:CSSRule];
    }];
    
    return CSSRule;
}

- (NSString *)getRuleKey:(NSString *)key {
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

- (void)setRule:(NSString *)value forKey:(NSString *)key inRule:(StylizeCSSRule *)CSSRule {
    NSString *ruleKey = [self getRuleKey:key];
}

@end
