//
//  ECLStandardCalendar.m
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/30.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "ECLStandardCalendar.h"
#import "FSCalendar.h"

@interface ECLStandardCalendar ()<FSCalendarDelegate,FSCalendarDataSource>
@property (nullable, readwrite, nonatomic)      NSDate *selectedDate;
@property (readwrite, nonatomic)                NSArray<NSDate *> *selectedDates;
@property (strong, nonatomic)                   NSDateFormatter *dateFormatter;
@property (strong, nonatomic)                   NSCalendar *gregorian;
@property (nonatomic, weak)                     FSCalendar *calendar;
@end

@implementation ECLStandardCalendar
@synthesize minimumDate = _minimumDate;
@synthesize maximumDate = _maximumDate;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize scrollDirection = _scrollDirection;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [self setUpView];
    }
    return self;
}

- (void)dealloc {
    _calendar.dataSource = nil;
    _calendar.delegate = nil;
}

- (void)setUpView {
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:self.bounds];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.today = nil;
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
    calendar.placeholderType = FSCalendarPlaceholderTypeFillSixRows;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    [self addSubview:calendar];
    self.calendar = calendar;
}

- (NSDate *)selectedDate {
    return _calendar.selectedDate;
}

- (NSArray<NSDate *> *)selectedDates {
    return _calendar.selectedDates;
}

- (void)setMaximumDate:(NSString *)maximumDate {
    _maximumDate = maximumDate;
    [_calendar reloadData];
}

- (void)setMinimumDate:(NSString *)minimumDate {
    _minimumDate = minimumDate;
    [_calendar reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    _calendar.allowsMultipleSelection = allowsMultipleSelection;
}

- (void)setScrollDirection:(ECLCalendarScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    switch (scrollDirection) {
        case ECLCalendarScrollDirectionHorizontal:
            _calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
            break;
        case ECLCalendarScrollDirectionVertical:
            _calendar.scrollDirection = FSCalendarScrollDirectionVertical;
            break;
        default:
            break;
    }
}


#pragma mark - FSCalendarDataSource,FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    //  calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"should select date %@",[self.dateFormatter stringFromDate:date]);
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:_minimumDate];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:_maximumDate];
}

#pragma mark - ECLCalendar
- (void)scrollToPageAtScrollPosition:(ECLCalendarMonthPosition)monthPosition animated:(BOOL)animated {
    NSDate *currentMonth = self.calendar.currentPage;
    NSInteger page = 0;
    if (monthPosition == ECLCalendarMonthPositionPrevious) {
        page = -1;
    }else if (monthPosition == ECLCalendarMonthPositionNext){
        page = 1;
    }
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:page toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)scrollToPageForDate:(NSDate *)date animated:(BOOL)animated {
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:_calendar.selectedDates.count];
    [_calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    [_calendar setCurrentPage:date animated:YES];
}

@end
