//
//  TestItemViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/19.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "TestItemViewController.h"
#import "TestItemFirshViewController.h"
@interface TestItemViewController ()

@end

@implementation TestItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(kScreenWidth/4, 120, kScreenWidth/2, 40);
    [button1 setTitle:@"Firsh" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)push:(id)sender {
    
    NSLog(@"self.navigationController = %@",self.navigationController);
    [self.navigationController pushViewController:[TestItemFirshViewController new] animated:YES];
    [self.navigationController hidesBottomBarWhenPushed];
}


@end
