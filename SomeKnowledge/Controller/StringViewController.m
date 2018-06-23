//
//  StringViewController.m
//  SomeKnowledge
//
//  Created by HuangJin on 2018/6/13.
//  Copyright © 2018年 HuangJin. All rights reserved.
//

#import "StringViewController.h"

@interface StringViewController ()

@end

@implementation StringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    double maxWidth;
    if (([UIScreen mainScreen].bounds.size.width - 144) > 231) {
        maxWidth = 231;
    }else{
        maxWidth = ([UIScreen mainScreen].bounds.size.width - 144);
    }
    NSString *_layoutLabelContentString = @"地方建设\n开发建设路口";
    CGFloat contentHeight = [_layoutLabelContentString boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:NULL].size.height;
    contentHeight = ceil(contentHeight);
    NSLog(@"contentHeight====%f",contentHeight);
    
    
    //文本
    NSString *text = @"副书记🤣风口浪尖动手了🤾🏻‍♀️的房价🏘快速福建省地方；了\n    dffdfksf🐛 /n   dff\n副书记🤣风口浪尖动手了🤾🏻‍♀️的房价🏘快速福建省地方；了\n    dffdfksf🐛 /n   dff\nfdsfsfsfsd沙发斯蒂芬斯蒂芬是否是的佛山市发送的方式发送方式的方法是🤾🏻‍♀️的房价🏘🤾🏻‍♀️的房价🏘🤾🏻‍♀️的房价🏘https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html#//apple_ref/doc/uid/TP40009542-CH4-SW1🤾🏻‍♀️的房价🏘🤾🏻‍♀️的房价🏘ksf🐛 ksf🐛 ksf🐛 ksf🐛 ";
    NSTextStorage *textStorage = [[NSTextStorage alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    paragraphStyle.firstLineHeadIndent = 20.0f;//首行缩进
    paragraphStyle.alignment = NSTextAlignmentJustified;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    //    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    //    paragraphStyle.headIndent = 20;//整体缩进(首行除外)
    //    paragraphStyle.tailIndent = 20;//
    paragraphStyle.minimumLineHeight = 10;//最低行高
    paragraphStyle.maximumLineHeight = 20;//最大行高
    paragraphStyle.paragraphSpacing = 15;//段与段之间的间距
    //    paragraphStyle.paragraphSpacingBefore = 22.0f;//段首行空白空间/* Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any) and the top of this paragraph. */
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;//从左到右的书写方向（一共➡️三种）
    paragraphStyle.lineHeightMultiple = 15;/* Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. */
    paragraphStyle.hyphenationFactor = 1;//连字属性 在iOS，唯一支持的值分别为0和1
    
    NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html#//apple_ref/doc/uid/TP40009542-CH4-SW1"];
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSLinkAttributeName:url};
    [textStorage addAttributes:dic range:NSMakeRange(0, text.length - 1)];
    
    //  CGRect rect = [textStorage.string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:dic context:NULL];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 100)];
    textView.attributedText = textStorage;
    textView.editable = NO;
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
}



@end
