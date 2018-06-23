//
//  ECLExtendCalendar.m
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/30.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "ECLExtendCalendar.h"
#import <EventKit/EventKit.h>
#import "FSCalendar.h"


static CGFloat viewHeight = 40.f;
static CGFloat itemHeight = 50.f;

@interface ECLExtendCalendar ()<FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nullable, readwrite, nonatomic)      NSDate *selectedDate;
@property (readwrite, nonatomic)                NSArray<NSDate *> *selectedDates;
@property (strong, nonatomic)                   NSDateFormatter *dateFormatter;
//@property (strong, nonatomic)                   NSDictionary<NSString *, UIImage *> *images;
//@property (strong, nonatomic)                   NSCache *cache;
//@property (strong, nonatomic)                   NSArray<EKEvent *> *events;
@property (nonatomic, strong)                   UIView *headerView;
@property (nonatomic, strong)                   UIView *weekDayView;
@property (nonatomic, strong)                   UILabel *dateLabel;
@property (nonatomic, strong)                   UITableView *bottomView;
@property (nonatomic, weak)                     FSCalendar *calendar;
@property (nonatomic, strong)                   NSCalendar *gregorian;
@property (nonatomic, assign)                   CGFloat calendarHeight;
@property (nonatomic, strong)                   NSMutableArray *ItemDataSource;
@property (nonatomic, strong)                   UIView  *backgroundView;
@end

@implementation ECLExtendCalendar
@synthesize minimumDate = _minimumDate;
@synthesize maximumDate = _maximumDate;
@synthesize allowsMultipleSelection = _allowsMultipleSelection;
@synthesize scrollDirection = _scrollDirection;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)dealloc {
    _calendar.delegate = nil;
    _calendar.dataSource = nil;
}

- (void)setUpView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    //topView
    CGFloat marginTop = 10;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, itemHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    self.headerView = topView;
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, marginTop, 80, viewHeight);
    [clearButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _cancelButton = clearButton;
    [topView addSubview:clearButton];
    
    UIButton *makeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSureButton.frame = CGRectMake(self.bounds.size.width - 80, marginTop, 80, viewHeight);
    [makeSureButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [makeSureButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [makeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    makeSureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _makeSureButton = makeSureButton;
    [topView addSubview:makeSureButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/4, marginTop, self.bounds.size.width/2, viewHeight)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"日期";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    self.weekDayView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), self.frame.size.width, viewHeight - 10);
    //calendar
    CGFloat height = 240; //[[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 :
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 120 - 1, self.frame.size.width, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.today = nil;
    calendar.headerHeight = 0;
    calendar.weekdayHeight = 0;
    calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
    calendar.placeholderType = FSCalendarPlaceholderTypeFillSixRows;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    [self addSubview:calendar];
    self.calendar = calendar;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    self.dateLabel.frame = CGRectMake(0, 50 + 30, self.frame.size.width, viewHeight);
    
    //BottomView
    self.bottomView = [[UITableView alloc]initWithFrame:CGRectMake(0,120 + 240, self.bounds.size.width, 0) style:UITableViewStylePlain];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.scrollEnabled = NO;
    _bottomView.delegate = self;
    _bottomView.dataSource = self;
    [self addSubview:self.bottomView];
    self.calendarHeight = CGRectGetMaxY(_bottomView.frame);

}

- (void)setDaySelectionColor:(UIColor *)daySelectionColor {
    _daySelectionColor = daySelectionColor;
    _calendar.appearance.selectionColor = daySelectionColor;
}

- (void)setWeekDayTitleFont:(UIFont *)weekDayTitleFont {
    _weekDayTitleFont = weekDayTitleFont;
    for (UILabel *label in self.weekDayView.subviews) {
        label.font = weekDayTitleFont;
    }
}

- (void)setWeekDayTitleColor:(UIColor *)weekDayTitleColor {
    _weekDayTitleColor = weekDayTitleColor;
    for (UILabel *label in self.weekDayView.subviews) {
        label.textColor = weekDayTitleColor;
    }
}

- (void)setWeekDayBackgroundColor:(UIColor *)weekDayBackgroundColor {
    _weekDayBackgroundColor = weekDayBackgroundColor;
    for (UILabel *label in self.weekDayView.subviews) {
        label.backgroundColor = weekDayBackgroundColor;
    }
}

- (void)setDateTitleFont:(UIFont *)dateTitleFont {
    _dateTitleFont = dateTitleFont;
    _dateLabel.font = dateTitleFont;
}

- (void)setDateTitleColor:(UIColor *)dateTitleColor {
    _dateTitleColor = dateTitleColor;
    _dateLabel.textColor = dateTitleColor;
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

#pragma mark - Interaction

- (void)showCalendar{
    self.hidden = NO;
}

- (void)hideCalendar{
    self.hidden = YES;
}

- (void)cancelAction {
    if([self.delegate respondsToSelector:@selector(clikedExtendCalendarCancelButton)]){
        [self.delegate clikedExtendCalendarCancelButton];
    }
   // [self hideCalendar];
}

- (void)makeSureAction {
    if([self.delegate respondsToSelector:@selector(clikedExtendCalendarMakeSureButton)]){
        [self.delegate clikedExtendCalendarMakeSureButton];
    }
   // [self showCalendar];
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
    if ([self.delegate respondsToSelector:@selector(calendarDidSelectDate:)]) {
        [self.delegate calendarDidSelectDate:date];
    }
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

#pragma mark - UITableViewDelegate And UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return itemHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger itemCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItems)]) {
        itemCount = [self.dataSource numberOfItems];
    }
    _bottomView.frame = CGRectMake(0, 360, self.bounds.size.width, itemCount * itemHeight);
    return itemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([self.dataSource respondsToSelector:@selector(itemForIndex:)]) {
       cell = [self.dataSource itemForIndex:indexPath.row];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(calendarDidSelectExtendItemAtIndex:)]) {
        [self.delegate calendarDidSelectExtendItemAtIndex:indexPath.row];
    }
}

#pragma mark - LazyLoad


- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 10, viewHeight)];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:15];
        dateLabel.text = @"    2018年5月";
        [self addSubview:dateLabel];
        dateLabel.backgroundColor = [UIColor whiteColor];
        _dateLabel = dateLabel;
    }
    return _dateLabel;
}

- (UIView *)weekDayView {
    if (_weekDayView == nil) {
        UIView *weekDayView = [[UIView alloc]init];
        NSArray *dayArrays = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        CGFloat width = self.bounds.size.width/dayArrays.count;
        for (int i = 0; i < dayArrays.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, viewHeight - 10)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:15];
            label.tag = i;
            label.text = dayArrays[i];
            [weekDayView addSubview:label];
        }
        weekDayView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:weekDayView];
        _weekDayView = weekDayView;
    }
    return _weekDayView;
}

@end
