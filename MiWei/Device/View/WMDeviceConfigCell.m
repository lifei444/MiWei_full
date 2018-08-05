//
//  WMDeviceConfigCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceConfigCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMDeviceConfigCell()
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation WMDeviceConfigCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(24, 0, 40, 60)];
        _titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForX:16]];
        _titleLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:WM_CGRectMake(77, 0, 300, 60)];
        _textField.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForX:15]];
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] initWithFrame:WM_CGRectMake((Screen_Width-320)/2, 60-1, 320, 1)];
        _separatorView.backgroundColor = [WMUIUtility color:@"0xcdcdcd"];
    }
    return _separatorView;
}

@end
