//
//  CalendarViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "CalendarViewController.h"
#import "FSCalendar.h"
#import "ECLTimePickView.h"
#import "ECLExtendCalendar.h"
#import "ECLTimeCell.h"

@interface CalendarViewController ()<ECLExtendCalendarDelegate,ECLExtendCalendarDataSource,ECLTimePickViewDelegate>

@property (strong, nonatomic) ECLExtendCalendar *extendCalendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (nonatomic, strong) ECLTimePickView *pickView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //日历
    self.extendCalendar = [[ECLExtendCalendar alloc]initWithFrame:CGRectMake(30, (self.view.bounds.size.height - 400)/2, self.view.bounds.size.width - 60, 400)];
    self.extendCalendar.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    _extendCalendar.delegate = self;
    _extendCalendar.dataSource = self;
    [self.view addSubview:self.extendCalendar];
    
    _extendCalendar.daySelectionColor = [UIColor greenColor];
    _extendCalendar.weekDayTitleColor = [UIColor greenColor];
    [_extendCalendar.cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
}

#pragma mark - ECLExtendCalendarDelegate
- (NSInteger)numberOfItems {
    return 1;
}

- (UITableViewCell *)itemForIndex:(NSInteger)index {
    ECLTimeCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ECLTimeCell class]) owner:nil options:nil] lastObject];
    return cell;
}

- (void)calendarDidSelectDate:(NSDate *)date {
    
}

- (void)calendarDidSelectExtendItemAtIndex:(NSInteger)index {
    if (index == 0) {
        
        [self pickViewShowAnimation];
    }
}

- (void)clikedExtendCalendarCancelButton {
    [self pickViewShowAnimation];
}

- (void)clikedExtendCalendarMakeSureButton {
    [self pickViewShowAnimation];
}

#pragma mark - ECLTimePickViewDelegate
- (void)clikedTimePickViewCancelButton {
    [self calendarShowAnimation];
}

- (void)clikedTimePickViewMakeSureButton {
    [self calendarShowAnimation];
}

- (void)didSelectHour:(NSString *)hour minute:(NSString *)minute noon:(NSString *)noon {
    
}

#pragma mark - Other

- (void)pickViewShowAnimation {
    [self.pickView showTimePickView];
    self.pickView.bounds = CGRectMake(0, 0, self.pickView.bounds.size.width, 400);
    [self.pickView setNeedsLayoutPickerView];
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/4 animations:^{
            self.extendCalendar.bounds = CGRectMake(0, 0, self.extendCalendar.bounds.size.width, 180);
            self.extendCalendar.alpha = 0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            self.pickView.bounds = CGRectMake(0, 0, self.pickView.bounds.size.width, 180);
            [self.pickView setNeedsLayoutPickerView];
        }];
        
    } completion:^(BOOL finished) {
        self.extendCalendar.hidden = YES;
        self.extendCalendar.alpha = 1;
    }];
}

- (void)calendarShowAnimation {
    self.extendCalendar.hidden = NO;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/5 animations:^{
            self.pickView.alpha = 0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            self.extendCalendar.bounds = CGRectMake(0, 0, self.extendCalendar.bounds.size.width, 400);
        }];
    } completion:^(BOOL finished) {
        self.pickView.alpha = 1;
        self.pickView.hidden = YES;
    }];
}

- (ECLTimePickView *)pickView {
    if (_pickView == nil) {
        ECLTimePickView *pickView = [[ECLTimePickView alloc]initWithFrame:CGRectMake(30, (self.view.bounds.size.height - 180)/2, self.view.bounds.size.width - 60, 180)];
        pickView.delegate = self;
        _pickView  = pickView;
        [self.view addSubview:pickView];
    }
    return _pickView;
}

@end
