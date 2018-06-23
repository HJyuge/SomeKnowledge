//
//  ECLTimePickView.m
//  ECLCalendar
//
//  Created by HuangJin on 2018/5/29.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "ECLTimePickView.h"

@interface ECLTimePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *makeSureButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *hoursArray;
@property (nonatomic, strong) NSArray *minuteArray;
@property (nonatomic, strong) NSArray *noonArray;
//@property (nonatomic, strong,readwrite) UIView   *headerView;
//@property (nonatomic, strong,readwrite) UIPickerView *pickView;
@property (nonatomic,readwrite,nonnull) NSString *hour;
@property (nonatomic,readwrite,nonnull) NSString *minute;
@property (nonatomic,readwrite,nonnull) NSString *noon;
@property (nonatomic, strong) UIView  *backgroundView;

@end

@implementation ECLTimePickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initPickViewData];
        [self setUpView];
        [self configuration];
    }
    return self;
}

- (void)setUpView {
    CGFloat marginTop = 10;
    
   // UIView *backgroundView = [UIView alloc]initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    self.headerView = topView;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, marginTop, 80, 40);
    [clearButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:clearButton];
    
    UIButton *makeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSureButton.frame = CGRectMake(self.bounds.size.width - 80, marginTop, 80, 40);
    [makeSureButton addTarget:self action:@selector(makeSureAction) forControlEvents:UIControlEventTouchUpInside];
    [makeSureButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [makeSureButton setTitle:@"确定" forState:UIControlStateNormal];
    makeSureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:makeSureButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/4, marginTop, self.bounds.size.width/2, 40)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.text = @"时间";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:titleLabel];
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.bounds.size.width,120)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self addSubview:self.pickView];
}

- (void)initPickViewData {
    _noonArray = @[@"上午",@"下午"];
    _minuteArray = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
    _hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    _hour = _hoursArray[7];
    _minute = _minuteArray[7];
    _noon = _noonArray[0];
    
}

- (void)configuration {
    self.hidden = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.pickView selectRow:7 inComponent:1 animated:NO];
    [self.pickView selectRow:7 inComponent:2 animated:NO];
}

- (void)layoutSubviews {

}

- (void)setNeedsLayoutPickerView {
    self.pickView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 25);
}
#pragma mark - Interaction

- (void)showTimePickView {
    self.hidden = NO;
}

- (void)hideTimePickView{
    self.hidden = YES;
}

- (void)cancelAction {
    if([self.delegate respondsToSelector:@selector(clikedTimePickViewCancelButton)]){
        [self.delegate clikedTimePickViewCancelButton];
    }
   // [self showTimePickView];
}

- (void)makeSureAction {
    if([self.delegate respondsToSelector:@selector(clikedTimePickViewMakeSureButton)]){
        [self.delegate clikedTimePickViewMakeSureButton];
    }
   // [self hideTimePickView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 2;
    }else if (component == 1){
        return _hoursArray.count;
    }else if (component == 2){
        return _minuteArray.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(didSelectHour:minute:noon:)]) {
        if (component == 0) {
            _noon = _noonArray[row];
        }else if (component == 1){
           _hour = _hoursArray[row];
        }else if (component == 2){
            _minute = _minuteArray[row];
        }
        [self.delegate didSelectHour:_hour minute:_minute noon:_noon];
    }
    NSLog(@"didSelectNoon%@,Hour:%@,Minute:%@",_noon,_hour,_minute);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:25]];
        [pickerLabel setTextColor:[UIColor darkGrayColor]];
    }
    if (component == 0) {
        pickerLabel.text = _noonArray[row];
    }else if (component == 1){
        pickerLabel.text = _hoursArray[row];
    }else if (component == 2){
        pickerLabel.text = _minuteArray[row];
    }
    
    return pickerLabel;
}

- (void)resetPickViewComponent{
    
}
@end

