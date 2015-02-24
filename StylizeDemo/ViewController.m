//
//  ViewController.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "ViewController.h"
#import "Stylize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 50)];
    [button setTitle:@"clickme" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
