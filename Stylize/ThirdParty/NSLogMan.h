//
//  NSLogMan.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/15/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NSLOGMAN 1

#ifdef NSLOGMAN
    #define NSLogMan(fmt, ...) NSLog((@"\n__NSLOGMAN{{\nLevel:%s\nFunction:%s\nLine:%d\n__MESSAGE{{\n" fmt "\n}}MESSAGE__\n}}NSLOGMAN__"), "Info", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//    #define NSLogManInfo(fmt, ...) NSLog((@"__NSLOGMAN_START__LEVEL__%s__FUNCTION__%s__LINE__%d__MESSAGE__" fmt "__NSLOGMAN_END"), "Info", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #define NSLogManInfo(fmt, ...)
    #define NSLogManWarning(fmt, ...) NSLog((@"__NSLOGMAN_START__LEVEL__%s__FUNCTION__%s__LINE__%d__MESSAGE__" fmt "__NSLOGMAN_END"), "Warning", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #define NSLogManError(fmt, ...) NSLog((@"__NSLOGMAN_START__LEVEL__%s__FUNCTION__%s__LINE__%d__MESSAGE__" fmt "__NSLOGMAN_END"), "Error", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define NSLogMan(fmt, ...)
    #define NSLogManInfo(fmt, ...)
    #define NSLogManWarning(fmt, ...)
    #define NSLogManError(fmt, ...)
#endif
