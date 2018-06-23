//
//  NaviToPushViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/19.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "NaviToPushViewController.h"
#import "AppDelegate.h"
#import "TestItemFirshViewController.h"

@interface NaviToPushViewController ()

@end

@implementation NaviToPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kScreenWidth/4, 120, kScreenWidth/2, 40);
    [button1 setTitle:@"TopViewController" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kScreenWidth/4, 220, kScreenWidth/2, 40);
    [button2 setTitle:@"visibleViewController" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(visibleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

- (void)topAction:(id)sender {
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBarVC = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [tabBarVC setSelectedIndex:1];
    NSLog(@"tabBarVC.selectedViewController = %@",tabBarVC.selectedViewController);
    UINavigationController *navigationController = tabBarVC.selectedViewController;
    navigationController.hidesBottomBarWhenPushed = YES;
    NSLog(@"navigationController.topViewController = %@",navigationController.topViewController);
    [navigationController pushViewController:[TestItemFirshViewController new] animated:YES];
    
}

- (void)visibleAction:(id)sender {
    UITabBarController *tabBarVC = (UITabBarController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [tabBarVC setSelectedIndex:1];
    UINavigationController *navigationController = tabBarVC.selectedViewController;
    [navigationController hidesBottomBarWhenPushed];
     NSLog(@"navigationController.visibleViewController = %@",navigationController.visibleViewController);
    [navigationController pushViewController:[TestItemFirshViewController new] animated:YES];
}


@end
