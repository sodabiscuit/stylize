//
//  StylizeCSSParser.h
//  StylizeMobile
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeCSSRule.h"

@interface StylizeCSSParser : NSObject

/**
 *  解析CSS文本
 *
 *  @param CSSRaw CSS文本
 *
 *  @return StylizeCSSRule
 */
+ (StylizeCSSRule *)parseCSSRaw:(NSString *)CSSRaw;

@end
