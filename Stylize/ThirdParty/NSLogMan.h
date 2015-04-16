//
//  NSLogMan.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/15/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#define NSLOGMAN 1

#ifdef NSLOGMAN
//    #define NSLogMan(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #define NSLogMan(fmt, ...) NSLog((@"[%s] " fmt), "Info", ##__VA_ARGS__)
    #define NSLogManInfo(fmt, ...) NSLog((@"[%s] " fmt), "Info", ##__VA_ARGS__)
    #define NSLogManWarning(fmt, ...) NSLog((@"[%s] " fmt), "Warning", ##__VA_ARGS__)
    #define NSLogManError(fmt, ...) NSLog((@"[%s] " fmt), "Error", ##__VA_ARGS__)
#else
    #define NSLogMan(fmt, ...)
    #define NSLogManInfo(fmt, ...)
    #define NSLogManWarning(fmt, ...)
    #define NSLogManError(fmt, ...)
#endif
