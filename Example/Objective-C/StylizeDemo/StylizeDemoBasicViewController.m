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
    
//    thirdNode.measure = ^CGSize(CGFloat width) {
//        return CGSizeMake(100, 50);
//    };
    
    StylizeNode *fourthNode = [self createUnitNode:@"fourth"];
    [_rootNode addSubnode:fourthNode];
    
    [_rootNode layoutNode];
    
    _rootNode.Query(@"#fourth").CSS(@{
                     @"background-color" : @"cyan",
                     @"opacity" : @"0.5"
                     }, nil);
    
    StylizeNode *fifthNode = [self createUnitNode:@"fifth"];
    [_rootNode addSubnode:fifthNode];
    
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
    
    StylizeTextNode *textNode = [StylizeTextNode new];
    textNode.CSS(@{
                   @"position" : @"absolute",
                   @"background-color" : @"transparent",
                   @"font-size" : @"12",
                   }, nil);
    textNode.text = nodeID;
    [ret addSubnode:textNode];
    
    return ret;
}


- (StylizeNode *)createInterUnitNode:(NSString *)nodeID {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.ID(nodeID).CSS(@{
              @"width" : @"20",
              @"height" : @"20",
              @"flex" : @"1",
              @"margin-right" : @"10",
              @"background-color" : @"red"
              }, nil);
    
    return ret;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //TODO
}

@end
