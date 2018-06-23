//
//  WaveViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "WaveViewController.h"
#import "WaveView.h"



@interface WaveViewController ()


@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化WaveView
    WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, (self.view.frame.size.height-self.view.frame.size.width/2)/2, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    waveView.layer.cornerRadius = self.view.frame.size.width/4;
    [self.view addSubview:waveView];
    
    
}



@end
