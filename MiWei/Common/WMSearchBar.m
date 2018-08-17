//
//  WMSearchBar.m
//  MiWei
//
//  Created by LiFei on 2018/8/17.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMSearchBar.h"
#import "WMUIUtility.h"

#define SearchBar_Width             359
#define SearchBar_Height            40

@interface WMSearchBar () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@end

@implementation WMSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.button];
    }
    return self;
}

- (void)showCancel {
    _textField.frame = WM_CGRectMake(0, 0, SearchBar_Width - 60, SearchBar_Height);
    _button.hidden = NO;
}

#pragma mark - Target action
- (void)onCancel {
    if ([self.delegate respondsToSelector:@selector(onCancel)]) {
        [self.delegate onCancel];
    }
}

- (void)onTextChange {
    if ([self.delegate respondsToSelector:@selector(onSearch:)]) {
        [self.delegate onSearch:self.textField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(onClick)]) {
        [self.delegate onClick];
    }
}

#pragma mark - Getters & setters
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:WM_CGRectMake(0, 0, SearchBar_Width, SearchBar_Height)];
        _textField.placeholder = @"搜索";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        UIView *leftView = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, 32, SearchBar_Height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(15, 11, 17, 17)];
        imageView.image = [UIImage imageNamed:@"device_search"];
        [leftView addSubview:imageView];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(onTextChange) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:WM_CGRectMake(310, 0, 50, SearchBar_Height)];
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        [_button setTitleColor:[WMUIUtility color:@"0x24938c"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        _button.hidden = YES;
    }
    return _button;
}

@end
