//
//  ViewController.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeDemoBasicViewController.h"
#import "Stylize.h"
#import "NSLogMan.h"

@interface StylizeDemoBasicViewController ()

@property (nonatomic,strong) StylizeNode *rootNode;

@end

@implementation StylizeDemoBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSDictionary *ruleSet = [StylizeCSSParser parseCSSRaw:@"body { padding:10; margin-left:10;}"];
    
    _rootNode = [[StylizeNode alloc] initWithViewClass:[UIView class]];
    _rootNode.nodeID = @"rootNode";
//    _rootNode.width = 500;
//    _rootNode.node->layout.dimensions[CSS_WIDTH] = self.view.frame.size.width;
    _rootNode.CSSRule.maxWidth = self.view.frame.size.width;
    _rootNode.CSSRule.height = 600;
    
    _rootNode.CSSRule.flexDirection = StylizeLayoutFlexDirectionColumn;
    _rootNode.CSSRule.justifyContent = StylizeLayoutFlexJustifyContentFlexStart;
//    _rootNode.height = self.view.frame.size.height-64;
//    _rootNode.height = 120;
    _rootNode.CSSRule.margin = StylizeMarginMake(64, 0, 0, 0);
    _rootNode.view.backgroundColor = [UIColor purpleColor];
    _rootNode.CSSRule.flexDirection = StylizeLayoutFlexDirectionRow;
//    _rootNode.CSSRule.alignItems = StylizeLayoutFlexAlignStretch;
    _rootNode.CSSRule.alignItems = StylizeLayoutFlexAlignFlexStart;
    _rootNode.CSSRule.flexWrap = StylizeLayoutFlexFlexWrapWrap;
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode:@"first"];
    [_rootNode addSubnode:firstNode];
//    firstNode.CSSRule.flex = 2;
    firstNode.CSSRule.flexWrap = StylizeLayoutFlexFlexWrapWrap;
    firstNode.CSSRule.justifyContent = StylizeLayoutFlexJustifyContentSpaceAround;
    firstNode.CSSRule.visibility = StylizeVisibilityHidden;
    
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
   
    NSLogMan(@"linetest1");
    NSLogMan(@"multiple\nline\ntest1");
    NSLogMan(@"linetest2");
}

- (StylizeNode *)createUnitNode:(NSString *)nodeID {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.CSSRule.width = 100;
    ret.CSSRule.height = 100;
    ret.nodeID = nodeID;
//    ret.CSSRule.flex = 1;
//    ret.CSSRule.position = StylizePositionTypeAbsolute;
//    ret.CSSRule.alignSelf = StylizeLayoutFlexAlignFlexStart;
    ret.CSSRule.marginRight = 10;
    ret.CSSRule.marginBottom = 10;
//    ret.CSSRule.top = 50;
//    ret.CSSRule.bottom = 50;
    ret.view.backgroundColor = [UIColor orangeColor];
    
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
//    ret.CSSRule.flex = 1;
    ret.CSSRule.marginRight = 10;
    ret.nodeID = nodeID;
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
