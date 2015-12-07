//
//  StylizeCSSRuleParser.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/13/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class StylizeCSSRule;

@interface StylizeCSSRuleParser : NSObject

+ (void)applyCSSRaw:(NSString *)CSSRaw to:(StylizeCSSRule *)CSSRule;
+ (void)applyCSSDictionary:(NSDictionary *)CSSDictionary to:(StylizeCSSRule *)CSSRule;

@end


