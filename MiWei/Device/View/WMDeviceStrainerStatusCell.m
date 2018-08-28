//
//  WMDeviceStrainerStatusCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceStrainerStatusCell.h"
#import "WMUIUtility.h"

#define Cell_Height     30

#define Name_X          16
#define Name_Width      40

#define Progress_X      58
#define Progress_Y      14
#define Progress_Width  128
#define Progress_Height 7

#define Value_X         200
#define Value_Width     40

#define Button_X        250
#define Button_Width    50

@implementation WMDeviceStrainerStatusCell
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.valueLabel];
        [self addSubview:self.resetButton];
    }
    return self;
}

#pragma mark - Target action
- (void)reset {
    if ([self.delegate respondsToSelector:@selector(onReset:)]) {
        [self.delegate onReset:self.tag];
    }
}

#pragma mark - Getters & setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Name_X, 0, Name_Width, Cell_Height)];
        _nameLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:12]];
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:WM_CGRectMake(Progress_X, Progress_Y, Progress_Width, Progress_Height)];
        _progressView.progressTintColor = [WMUIUtility color:@"0x23938b"];
    }
    return _progressView;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Value_X, 0, Value_Width, Cell_Height)];
        _valueLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:14]];
    }
    return _valueLabel;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Button_X, 0, Button_Width, Cell_Height)];
        [_resetButton setTitle:@"复位" forState:UIControlStateNormal];
        _resetButton.backgroundColor = [WMUIUtility color:@"0x23938b"];
        _resetButton.layer.cornerRadius = 5;
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:14]];
        [_resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
@end
