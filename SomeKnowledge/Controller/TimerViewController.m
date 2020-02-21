//
//  TimerViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2019/9/30.
//  Copyright © 2019 HuangJin. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (strong, nonatomic)  UILabel *count;
@property (strong, nonatomic)  UIButton *start;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TimerViewController
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    _count = [[UILabel alloc] initWithFrame:CGRectMake((width - 100)/2, 200, 100, 100)];
    _count.text = @"0";
    _count.font = [UIFont systemFontOfSize:20];
    _count.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_count];
    
    _start = [UIButton buttonWithType:UIButtonTypeCustom];
    _start.frame = CGRectMake((width - 100)/2, 300, 100, 100);
    [self.view addSubview:_start];
    [_start setTitle:@"start" forState:UIControlStateNormal];
    [_start setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_start setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_start addTarget:self action:@selector(fire:) forControlEvents:UIControlEventTouchUpInside];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

- (void)fire:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        _timer.fireDate = [NSDate date];
    }else {
        _timer.fireDate = [NSDate distantFuture];
        
    }
}

- (void)startAnimation {
    _count.text = [NSString stringWithFormat:@"%ld",(_count.text.integerValue + 1)];
}

@end
