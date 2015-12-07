//
//  StylizeUtility.h
//  StylizeDemo
//
//  Created by Yulin Ding on 12/7/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StylizeRegexUtility : NSObject

+ (BOOL)isString:(NSString *)string
           match:(NSString *)regex
      ignoreCase:(BOOL)ignoreCase;

+ (NSArray *)string:(NSString *)string
            matches:(NSString *)regex
         ignoreCase:(BOOL)ignoreCase;

+ (NSString *)string:(NSString *)string
             replace:(NSString *)regex
                with:(NSString *)replacement
          ignoreCase:(BOOL)ignoreCase;

@end
