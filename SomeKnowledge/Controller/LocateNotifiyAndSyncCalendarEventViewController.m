//
//  LocateNotifiyAndSyncCalendarEventViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "LocateNotifiyAndSyncCalendarEventViewController.h"

@interface LocateNotifiyAndSyncCalendarEventViewController ()

@end

@implementation LocateNotifiyAndSyncCalendarEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self configuration];
}

- (void)setUpView {
    
}

- (void)configuration{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd aa hh:mm:ss"];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date = [NSDate date];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"dateString:%@",dateString);
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *selfDateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    
}

@end
