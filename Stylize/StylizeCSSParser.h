//
//  StylizeCSSParser.h
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSRule.h"

@interface StylizeCSSParser : NSObject

+ (StylizeCSSRule *)parseCSSRaw:(NSString *)CSSRaw;

@end
