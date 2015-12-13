//
//  StylizeUtility.m
//  StylizeDemo
//
//  Created by Yulin Ding on 12/7/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import "StylizeRegexUtility.h"

@implementation StylizeRegexUtility

+ (BOOL)isString:(NSString *)string
           match:(NSString *)regex
      ignoreCase:(BOOL)ignoreCase {
    BOOL ret = NO;
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:ignoreCase?NSRegularExpressionCaseInsensitive:0
                                                                                  error:nil];
    ret = [expression numberOfMatchesInString:string
                                      options:0
                                        range:NSMakeRange(0, string.length)] > 0;
    
    return ret;
    
}

+ (NSArray *)string:(NSString *)string
            matches:(NSString *)regex
         ignoreCase:(BOOL)ignoreCase {
    NSMutableArray *ret = [@[] mutableCopy];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:ignoreCase?NSRegularExpressionCaseInsensitive:0
                                                                                  error:nil];
    NSArray *matches = [expression matchesInString:string
                                           options:0
                                             range:NSMakeRange(0, string.length)];
    
    
    for (NSTextCheckingResult *match in matches) {
        [ret addObject:[string substringWithRange:match.range]];
    }
    
    return ret;
}

+ (NSString *)string:(NSString *)string
             replace:(NSString *)regex
                with:(NSString *)replacement
          ignoreCase:(BOOL)ignoreCase {
    NSString *ret = string;
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                options:ignoreCase?NSRegularExpressionCaseInsensitive:0
                                                                                  error:nil];
    ret = [expression stringByReplacingMatchesInString:string
                                               options:0
                                                 range:NSMakeRange(0, string.length)
                                          withTemplate:replacement];

    
    return ret;
}



@end
