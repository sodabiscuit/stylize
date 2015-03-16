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
    _rootNode.layoutType = StylizeLayoutTypeFlex;
    _rootNode.width = self.view.frame.size.width;
    _rootNode.CSSRule.justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
//    _rootNode.CSSRule.alignItems = StylizeLayoutFlexAlignCenter;
    _rootNode.height = self.view.frame.size.height-64;
    _rootNode.margin = StylizeMarginMake(64, 0, 0, 0);
    _rootNode.view.backgroundColor = [UIColor grayColor];
    _rootNode.CSSRule.flexDirection = StylizeLayoutFlexDirectionColumn;
//    _rootNode.CSSRule.alignItems = StylizeLayoutFlexAlignItemsStretch;
//    _rootNode.CSSRule.flexWrap = StylizeLayoutFlexFlexWrapWrap;
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode:@"first"];
    firstNode.CSSRule.bottom = 0;
    [_rootNode addSubnode:firstNode];
    
    StylizeNode *secondNode = [self createUnitNode:@"second"];
//    secondNode.CSSRule.flex = 1;
    [_rootNode addSubnode:secondNode];
    
    StylizeNode *thirdNode = [self createUnitNode:@"third"];
    [_rootNode addSubnode:thirdNode];
    
    StylizeNode *fourthNode = [self createUnitNode:@"fourth"];
    [_rootNode addSubnode:fourthNode];
    
    [_rootNode layout];
}

- (StylizeNode *)createUnitNode:(NSString *)nodeID {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.width = 100;
    ret.height = 100;
    ret.nodeID = nodeID;
    ret.CSSRule.position = StylizePositionTypeRelative;
//    ret.CSSRule.position = StylizePositionTypeAbsolute;
    ret.CSSRule.alignSelf = StylizeLayoutFlexAlignFlexEnd;
    ret.CSSRule.marginRight = 10;
    ret.CSSRule.marginBottom = 10;
//    ret.CSSRule.top = 50;
//    ret.CSSRule.bottom = 50;
    ret.view.backgroundColor = [UIColor redColor];
    
    return ret;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //TODO
}

@end
