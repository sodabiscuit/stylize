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
    
    _rootNode
        .ID(@"rootNode")
        .Class(@"root")
        .CSS(@{
               @"margin-top" : @"64",
               @"width" : [NSString stringWithFormat:@"%ld", (long)self.view.frame.size.width],
               @"flex-direciton" : @"row",
               @"justify-content" : @"flex-start",
               @"background-color" : @"purple",
               @"align-items" : @"flex-start",
               @"flex-wrap" : @"wrap"
               },nil);
    
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode:@"first"];
    [_rootNode addSubnode:firstNode];
    firstNode.CSS(@{
                    @"justify-content" : @"space-around",
                    @"flex-wrap" : @"wrap"
                    }, nil);
    
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
   
    ret.CSS(@{
              @"margin-right" : @"10",
              @"margin-bottom" : @"10",
              @"width" : @"100",
              @"height" : @"100",
              @"flex" : @"1",
              @"background-color" : @"orange"
              }, nil)
        .Class(@"child")
        .ID(nodeID);
    
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
