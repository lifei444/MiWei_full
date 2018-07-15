//
//  WMFeedbackViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMFeedbackViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMFeedbackViewController ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *placeholderLabel;
@end

@implementation WMFeedbackViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
//    [self.view addSubview:self.textView];
    
    [self addSubViews];
}

- (void)addSubViews {
    //反馈问题 view
    UIView *feedBackView = [[UIView alloc] initWithFrame:WM_CGRectMake(0,Navi_Height, Screen_Width, 50)];
    UILabel *feedBackLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 90, 50)];
    feedBackLabel.text = @"反馈问题";
    feedBackLabel.textAlignment = NSTextAlignmentCenter;
    [feedBackView addSubview:feedBackLabel];
    
    
    UIButton *feedBackBtn = [[UIButton alloc] initWithFrame:WM_CGRectMake(90, 0, Screen_Width-90-30, 50)];
    [feedBackBtn setTitle:@"请选择问题" forState:UIControlStateNormal];
    [feedBackBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [feedBackBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -200, 0, 0)];
    [feedBackView addSubview:feedBackBtn];
    
    UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:WM_CGRectMake(CGRectGetMaxX(feedBackBtn.frame), 22.5, 15, 15)];
    arrowIV.backgroundColor = [UIColor redColor];
    [feedBackView addSubview:arrowIV];

    [self.view addSubview:feedBackView];
    
    //textview
    UITextView *textView = [[UITextView alloc] initWithFrame:WM_CGRectMake(0, CGRectGetMaxY(feedBackView.frame) + 8, Screen_Width, 175)];
    textView.delegate = self;
    self.textView = textView;
    self.placeholderLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 45)];
    [textView addSubview:self.placeholderLabel];
    self.placeholderLabel.numberOfLines = 2;
    self.placeholderLabel.text = @"感谢您对我们的关注与支持，您的宝贵意见我们将尽快改进，谢谢.";
    [self.view addSubview:textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length != 0;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

#pragma mark - Getters and setters
//- (UITextView *)textView {
//    if (!_textView) {
//        
//    }
//    return _textView;
//}
@end
