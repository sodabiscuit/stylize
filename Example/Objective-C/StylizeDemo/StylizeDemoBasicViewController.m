//
//  ViewController.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeDemoBasicViewController.h"
#import "Stylize.h"

@interface StylizeDemoBasicViewController ()

@property (nonatomic,strong) StylizeNode *rootNode;

@end

@implementation StylizeDemoBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rootNode = [[StylizeNode alloc] initWithViewClass:[UIView class]];
    _rootNode.nodeID = @"rootNode";
    [_rootNode applyCSSDictionary:@{
                                    @"margin-top" : @"64",
                                    @"width" : [NSString stringWithFormat:@"%ld", (long)self.view.frame.size.width],
                                    @"flex-direciton" : @"row",
                                    @"justify-content" : @"flex-start",
                                    @"background-color" : @"purple",
                                    @"align-items" : @"flex-start",
                                    @"flex-wrap" : @"wrap"
                                    }];
    
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode:@"first"];
    [_rootNode addSubnode:firstNode];
//    firstNode.CSSRule.flex = 2;
    firstNode.CSSRule.flexWrap = StylizeLayoutFlexFlexWrapWrap;
    firstNode.CSSRule.justifyContent = StylizeLayoutFlexJustifyContentSpaceAround;
//    firstNode.CSSRule.visibility = StylizeVisibilityHidden;
    
    StylizeNode *interFirstNode = [self createInterUnitNode:@"innerFirst"];
    [firstNode addSubnode:interFirstNode];
    
    StylizeNode *interSecondNode = [self createInterUnitNode:@"innerSecond"];
    [firstNode addSubnode:interSecondNode];
    
    StylizeNode *secondNode = [self createUnitNode:@"second"];
    secondNode.CSSRule.alignSelf = StylizeLayoutFlexAlignFlexEnd;
    [_rootNode addSubnode:secondNode];
    
    StylizeNode *thirdNode = [self createUnitNode:@"third"];
    [_rootNode addSubnode:thirdNode];
    
    StylizeNode *fourthNode = [self createUnitNode:@"fourth"];
    [_rootNode addSubnode:fourthNode];
    
//    _rootNode.width = 120;
    [_rootNode layoutNode];
}

- (StylizeNode *)createUnitNode:(NSString *)nodeID {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.CSSRule.width = 100;
    ret.CSSRule.height = 100;
    ret.CSSRule.flex = 1;
    ret.nodeID = nodeID;
//    ret.CSSRule.flex = 1;
//    ret.CSSRule.position = StylizePositionTypeAbsolute;
//    ret.CSSRule.alignSelf = StylizeLayoutFlexAlignFlexStart;
    ret.CSSRule.marginRight = 10;
    ret.CSSRule.marginBottom = 10;
//    ret.CSSRule.top = 50;
//    ret.CSSRule.bottom = 50;
//    ((UIView *)ret.view).backgroundColor = [UIColor orangeColor];
    ret.CSSRule.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ret.CSSRule.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    [ret.view addSubview:label];
    label.text = nodeID;
    
    return ret;
}


- (StylizeNode *)createInterUnitNode:(NSString *)nodeID {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.CSSRule.width = 20;
    ret.CSSRule.height = 20;
    ret.CSSRule.flex = 1;
    ret.CSSRule.marginRight = 10;
    ret.nodeID = nodeID;
    ((UIView *)ret.view).backgroundColor = [UIColor redColor];
    
    return ret;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //TODO
}

@end
