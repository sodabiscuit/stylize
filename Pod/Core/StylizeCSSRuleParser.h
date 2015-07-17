//
//  StylizeCSSRuleParser.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/13/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StylizeCSSRule;

@interface StylizeCSSRuleParser : NSObject

- (instancetype)initWithCSSRaw:(NSString *)CSSRaw;
- (StylizeCSSRule *)parseCSSRaw:(NSString *)CSSRaw;

@end
