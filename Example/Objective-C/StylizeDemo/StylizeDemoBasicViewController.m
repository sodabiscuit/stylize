//
//  ViewController.m
//  StylizeDemo
//
//  Created by Yulin Ding on 2/4/15.
//  Copyright (c) 2015 Yulin Ding. All rights reserved.
//

#import "StylizeDemoBasicViewController.h"
#import "Stylize.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
               @"flex-direction" : @"row",
               @"justify-content" : @"flex-start",
               @"background-color" : @"purple",
               @"align-items" : @"flex-start",
               @"flex-wrap" : @"wrap"
               },nil);
    
    [self.view addStylizeNode:_rootNode];
    
    StylizeNode *firstNode = [self createUnitNode:@"first"];
    firstNode.CSS(@{
                    @"justify-content" : @"space-around",
                    @"flex-wrap" : @"wrap"
                    }, nil);
    StylizeNode *interFirstNode = [self createInterUnitNode:@"innerFirst"];
    StylizeNode *interSecondNode = [self createInterUnitNode:@"innerSecond"];
    
    firstNode.append(interFirstNode)
            .append(interSecondNode)
            .appendTo(_rootNode);
    
    StylizeNode *secondNode = [self createUnitNode:@"second"];
    secondNode.CSS(@{
                     @"align-self" : @"flex-end"
                     }, nil)
                .appendTo(_rootNode);
    
    StylizeNode *thirdNode = [self createUnitImageNode:@"third"];
    StylizeNode *fourthNode = [self createUnitButtonNode:@"fourth"];
    _rootNode.append(thirdNode).append(fourthNode);
    
    [_rootNode layoutNode];
    
//    thirdNode.measure = ^CGSize(CGFloat width) {
//        return CGSizeMake(100, 50);
//    };
    
    
    StylizeNode *fifthNode = [self createUnitNode:@"fifth"];
    [_rootNode addSubnode:fifthNode];
    
//    _rootNode.Query(@"#fourth")
//            .CSS(@{
//                   @"background-color" : @"cyan",
//                   @"opacity" : @"0.5",
//                   @"border-radius" : @"4 10 4",
//                   @"max-width" : @"50",
//                   }, nil);
    
    fifthNode.prependTo(_rootNode);
    
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
                   @"display" : @"inline",
                   @"background-color" : @"transparent",
                   @"font-size" : @"12",
                   @"text-align" : @"center"
                   }, nil);
    textNode.text = nodeID;
    [ret addSubnode:textNode];
    
    return ret;
}

- (StylizeButtonNode *)createUnitButtonNode:(NSString *)nodeID {
    StylizeButtonNode *ret = [StylizeButtonNode new];
   
    ret.CSS(@{
              @"margin-right" : @"10",
              @"margin-bottom" : @"10",
              @"width" : @"100",
              @"height" : @"100",
              @"flex" : @"1",
              @"background-color" : @"orange"
              }, nil)
        .CSS(@":selected", @{
              @"background-color" : @"red"
             })
        .Class(@"child")
        .ID(nodeID);
    
    [ret setTitle:@"1" forState:UIControlStateNormal];
    [ret setTitle:@"2" forState:UIControlStateSelected];
    ret.selected = YES;
    
    [ret addTarget:self action:@selector(doTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (StylizeImageNode *)createUnitImageNode:(NSString *)nodeID {
    StylizeImageNode *ret = [StylizeImageNode new];
   
    ret.CSS(@{
              @"margin-right" : @"10",
              @"margin-bottom" : @"10",
              @"width" : @"100",
              @"height" : @"100",
              @"flex" : @"1",
              @"background-color" : @"orange",
              @"contentMode" : [NSNumber numberWithInteger:UIViewContentModeCenter]
              }, nil)
        .Class(@"child")
        .ID(nodeID);
    
//    ret.imageURL = [NSURL URLWithString:@"http://img.alicdn.com/tps/TB1erQQKFXXXXc7XpXXXXXXXXXX-520-280.jpg"];
    ret.image = [UIImage imageNamed:@"MDLaunchScreenLogo"];
    
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

- (void)doTap:(id)sender {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"alert"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertview show];
}


@end
