//
//  ECLCalendarProtocol.h
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/31.
//  Copyright © 2018年 HuangJin. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ECLCalendarScrollDirection) {
    ECLCalendarScrollDirectionVertical,
    ECLCalendarScrollDirectionHorizontal
};

typedef NS_ENUM(NSUInteger, ECLCalendarMonthPosition) {
    ECLCalendarMonthPositionPrevious,
    ECLCalendarMonthPositionCurrent,
    ECLCalendarMonthPositionNext,
    ECLCalendarMonthPositionNotFound = NSNotFound
};

@protocol ECLCalendarProtocol <NSObject>
@property (nonatomic, copy) NSString *minimumDate;//2016-01-08
@property (nonatomic, copy) NSString *maximumDate;//2018-10-08
@property (nullable, readonly, nonatomic) NSDate *selectedDate;
@property (readonly, nonatomic) NSArray<NSDate *> *selectedDates;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) ECLCalendarScrollDirection scrollDirection;

- (void)scrollToPageForDate:(NSDate *)date animated:(BOOL)animated;
- (void)scrollToPageAtScrollPosition:(ECLCalendarMonthPosition )monthPosition animated:(BOOL)animated;

@end

//@protocol ECLCalendarTransitioning <NSObject>
//- (void)showAnimationWithCalendar:( id<ECLCalendarProtocol> )calendar;
//- (void)hideAnimationWithCalendar:( id<ECLCalendarProtocol> )calendar;
//
//@end
