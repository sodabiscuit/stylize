//
//  StylizeCSSRule.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/11/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import <objc/runtime.h>
#import "StylizeCSSRule.h"
#import "StylizeNode.h"

@implementation StylizeCSSRule

- (instancetype)init {
    if (self = [super init]) {
        self.position = StylizePositionTypeStatic;
        self.display = StylizeDisplayBlock;
        self.visibility = StylizeVisibilityVisible;
        
        self.width = 0;
        self.height = 0;
        self.margin = StylizeMarginMake(0, 0, 0, 0);
        self.padding = StylizePaddingMake(0, 0, 0, 0);
        
        self.flexDirection = StylizeLayoutFlexDirectionRow;
        self.justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
        self.alignItems = StylizeLayoutFlexAlignItemsFlexStart;
        self.flexWrap = StylizeLayoutFlexFlexWrapNowrap;
        self.alignContent = StylizeLayoutFlexAlignContentStretch;
        
        self.alignSelf = StylizeLayoutFlexAlignSelfStretch;
        
    }
    return self;
}

- (StylizeLayoutFlexFlow)flexFlow {
    return (StylizeLayoutFlexFlow){self.flexDirection, self.flexWrap};
}

- (void)setFlexFlow:(StylizeLayoutFlexFlow)flexFlow {
    self.flexDirection = flexFlow.direction;
    self.flexWrap = flexFlow.flexWrap;
}

- (StylizePadding)padding {
    return (StylizePadding){self.paddingTop, self.paddingRight, self.paddingBottom, self.paddingLeft};
}

- (void)setPadding:(StylizePadding)padding {
    self.paddingLeft = padding.paddingLeft;
    self.paddingRight = padding.paddingRight;
    self.paddingTop = padding.paddingTop;
    self.paddingBottom = padding.paddingBottom;
}

- (StylizeMargin)margin {
    return (StylizeMargin){self.marginTop, self.marginRight, self.marginBottom, self.marginLeft};
}

- (void)setMargin:(StylizeMargin)margin {
    self.marginLeft = margin.marginLeft;
    self.marginRight = margin.marginRight;
    self.marginTop = margin.marginTop;
    self.marginBottom = margin.marginBottom;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    StylizeCSSRule *CSSRule = [[[self class] allocWithZone:zone] init];
    return CSSRule;
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
    NSSet *ret = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"observerProperty"]) {
        NSMutableArray *keys = [NSMutableArray array];
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);  // see imports above!
        for (size_t i = 0; i < count; ++i) {
            NSString *property = [NSString stringWithCString:property_getName(properties[i])
                                                    encoding:NSASCIIStringEncoding];
            
            if (![property isEqualToString:@"observerProperty"]) {
                [keys addObject: property];
            }
        }
        free(properties);
        ret = [ret setByAddingObjectsFromArray: keys];
    }
    return ret;
}


@end
