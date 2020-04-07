//
//  TimerViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2019/9/30.
//  Copyright © 2019 HuangJin. All rights reserved.
//

#import "TimerViewController.h"
#import "HJProxy.h"

@interface TimerViewController ()
@property (strong, nonatomic)  UILabel *count;
@property (strong, nonatomic)  UIButton *start;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) CADisplayLink *displayLink;
@end

@implementation TimerViewController
- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
    [_timer invalidate];
    _timer = nil;
    NSLog(@"TimerViewController dealloc");
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
    
//    [self setTimer];
    [self setCADisplayLink];
//    [self];
}

- (void)group{
 
}

- (void)setCADisplayLink {
    //循环引用
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAnimation)];
    _displayLink = [CADisplayLink displayLinkWithTarget:[HJProxy proxyWithTarget:self] selector:@selector(startAnimation)];
    if (@available(iOS 10.0, *)) {
        _displayLink.preferredFramesPerSecond = 1;// 默认频率1秒60次，这里设置1秒一次
    } else {
        _displayLink.frameInterval = 1;
    }
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.paused = YES;
    
}

- (void)setTimer{
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        //        _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        //            [weakSelf startAnimation];
        //        }];
        //        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf startAnimation];
        }];
    } else {
        //有循环引用
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[HJProxy proxyWithTarget:self] selector:@selector(startAnimation) userInfo:nil repeats:YES];
    }
    
    _timer.fireDate = [NSDate distantFuture];
}

- (void)fire:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        _timer.fireDate = [NSDate date];
        _displayLink.paused = NO;
    }else {
        _timer.fireDate = [NSDate distantFuture];
        _displayLink.paused = YES;
    }
}

- (void)startAnimation {
    _count.text = [NSString stringWithFormat:@"%ld",(_count.text.integerValue + 1)];
}

@end
