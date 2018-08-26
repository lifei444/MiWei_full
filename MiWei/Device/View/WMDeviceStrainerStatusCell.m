//
//  WMDeviceStrainerStatusCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceStrainerStatusCell.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "MBProgressHUD.h"

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

@interface WMDeviceStrainerStatusCell ()
@property (nonatomic, strong) MBProgressHUD *hud;
@end

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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", self.strainerIndex, @"resetStrainerIndex", nil];
    self.hud = [MBProgressHUD showHUDAddedTo:self.vc.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/control"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            //debug
                                            [self.vc performSelector:@selector(loadData)];
                                        } else {
                                            //debug
//                                            [self.vc performSelector:@selector(loadData)];
                                            [WMUIUtility showAlertWithMessage:@"复位失败" viewController:self.vc];
                                        }
                                    });
                                }];
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
