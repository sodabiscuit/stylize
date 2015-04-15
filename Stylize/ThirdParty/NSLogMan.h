//
//  NSLogMan.h
//  StylizeDemo
//
//  Created by Yulin Ding on 4/15/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//


#ifdef NSLOGMAN_DEBUG
    #define NSLogMan(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLogManInfo(fmt, ...)
#else
    #define NSLogMan(...)
#endif