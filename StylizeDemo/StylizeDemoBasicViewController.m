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

@end

@implementation StylizeDemoBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StylizeNode *rootNode = [[StylizeNode alloc] initWithViewClass:[UIView class]];
    rootNode.layoutType = StylizeLayoutTypeFlex;
    rootNode.width = self.view.frame.size.width;
    rootNode.height = self.view.frame.size.height-64;
    rootNode.margin = StylizeMarginMake(64, 0, 0, 0);
    rootNode.view.backgroundColor = [UIColor grayColor];
    [self.view addStylizeNode:rootNode];
}

- (StylizeNode *)createUnitNode {
    StylizeNode *ret = [[StylizeNode alloc] initWithViewClass:[UIView class]];
    return ret;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
