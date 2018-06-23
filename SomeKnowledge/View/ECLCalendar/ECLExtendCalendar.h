//
//  ECLExtendCalendar.h
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/30.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "ECLStandardCalendar.h"

@protocol ECLExtendCalendarDataSource <NSObject>
@optional
- (UITableViewCell *)itemForIndex:(NSInteger )index;
- (NSInteger)numberOfItems;
@end


@protocol ECLExtendCalendarDelegate <NSObject>
@optional
- (void)calendarDidSelectDate:(NSDate *)date;
- (void)calendarDidSelectExtendItemAtIndex:(NSInteger )index;

- (void)clikedExtendCalendarCancelButton;
- (void)clikedExtendCalendarMakeSureButton;

@end


@interface ECLExtendCalendar : UIView<ECLCalendarProtocol>
//@property (nonatomic, weak) id<ECLCalendarTransitioning> calendarTransitioning;
@property (nonatomic, weak) id<ECLExtendCalendarDelegate> delegate;
@property (nonatomic, weak) id<ECLExtendCalendarDataSource> dataSource;
//样式
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *makeSureButton;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIColor  *daySelectionColor;
@property (nonatomic, strong) UIColor  *weekDayBackgroundColor;
@property (nonatomic, strong) UIColor  *weekDayTitleColor;
@property (nonatomic, strong) UIFont   *weekDayTitleFont;// 日、一、二...
@property (nonatomic, strong) UIColor  *dateTitleColor;//2018年5月
@property (nonatomic, strong) UIFont   *dateTitleFont;

- (void)showCalendar;
- (void)hideCalendar;

@end
