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
    _rootNode.height = self.view.frame.size.height-64;
    _rootNode.margin = StylizeMarginMake(64, 0, 0, 0);
    _rootNode.view.backgroundColor = [UIColor grayColor];
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode];
    [_rootNode addSubnode:firstNode];
    
    StylizeNode *secondNode = [self createUnitNode];
    [_rootNode addSubnode:secondNode];
    
}

- (StylizeNode *)createUnitNode {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
   
    ret.width = 50;
    ret.height = 50;
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
