//
//  StylizeCSSParser.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSParser.h"

@implementation StylizeCSSParser

+ (StylizeCSSRule *)parseCSSRaw:(NSString *)CSSRaw {
    StylizeCSSRule *CSSRule = [[StylizeCSSRule alloc] init];
    return CSSRule;
}
@end
