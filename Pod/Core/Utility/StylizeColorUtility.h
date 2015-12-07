//
//  StylizeColorUtility.h
//  StylizeDemo
//
//  Created by Yulin Ding on 12/7/15.
//  Copyright © 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StylizeColorUtility : NSObject

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
