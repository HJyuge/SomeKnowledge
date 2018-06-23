//
//  KeyBoradInputViewViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "KeyBoradInputViewViewController.h"


@interface KeyBoradInputViewViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *emojiInputView;

@end

@implementation KeyBoradInputViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 1);
    _scrollView.delegate = self;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_scrollView];
    
    
    //键盘
    _barView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    _barView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_barView];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 10, 30, 30)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"emoji" forState:UIControlStateNormal];
    [button setTitle:@"keyboard" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(showInputView:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:button];
    
    _emojiInputView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    _emojiInputView.backgroundColor = [UIColor greenColor];
    
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(30, self.view.bounds.size.height - 120, self.view.bounds.size.width - 60, 50)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.scrollView addSubview:_textField];
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)showInputView:(UIButton *)button {
    if (button.selected) {
        _textField.inputView = nil;
        [_textField reloadInputViews];
        // _barView.transform = CGAffineTransformMakeTranslation(0, -271 );
    }else{
        _textField.inputView = _emojiInputView;
        [_textField reloadInputViews];
        //  _barView.transform = CGAffineTransformMakeTranslation(0, -200 );
    }
    button.selected = !button.selected;
    [_textField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"keyboardWillShow:%@",NSStringFromCGSize(kbSize));
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height + 50, 0);
    //    _scrollView.contentInset = contentInsets;
    //    _scrollView.scrollIndicatorInsets = contentInsets;
    _scrollView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    _barView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height);
    
}

- (void)keyboardDidShow:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"keyboardDidShow:%@",NSStringFromCGSize(kbSize));
    
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    //    _scrollView.scrollIndicatorInsets = contentInsets;
    //    _scrollView.contentInset = contentInsets;
    
    //    CGRect aRect = self.view.frame;
    //    aRect.size.height -= kbSize.height;
    //    if (!CGRectContainsPoint(aRect, _textField.frame.origin)) {
    //        [self.scrollView scrollRectToVisible:_textField.frame animated:YES];
    //    }
    
    //    NSDictionary* info = [aNotification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //    CGRect bkgndRect = _textField.superview.frame;
    //    bkgndRect.size.height += kbSize.height;
    //    [_textField.superview setFrame:bkgndRect];
    //    [_scrollView setContentOffset:CGPointMake(0.0, _textField.frame.origin.y-kbSize.height) animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    _barView.transform = CGAffineTransformMakeTranslation(0, 0);
}

@end
