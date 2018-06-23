//
//  ECLTimePickView.h
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/29.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ECLTimePickViewDelegate <NSObject>
@optional
- (void)didSelectHour:(NSString *)hour minute:(NSString *)minute noon:(NSString *)noon;

@optional
- (void)clikedTimePickViewCancelButton;
- (void)clikedTimePickViewMakeSureButton;

@end

@interface ECLTimePickView : UIView
@property (nonatomic, strong) UIPickerView      *pickView;
@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic,readonly,nonnull) NSString *hour;
@property (nonatomic,readonly,nonnull) NSString *minute;
@property (nonatomic,readonly,nonnull) NSString *noon;

@property (nonatomic, assign) CGFloat animationHeight;
@property (nonatomic, weak) id<ECLTimePickViewDelegate> delegate;
- (void)setNeedsLayoutPickerView;
- (void)showTimePickView;
- (void)hideTimePickView;

@end
