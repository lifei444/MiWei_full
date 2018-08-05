//
//  WMDeviceConfigViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceConfigViewController.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMDeviceConfigCell.h"
#import <FogV3/FogV3.h>

#define Image_Y             (63 + Navi_Height)
#define Image_Width         90
#define Image_Height        90

#define Cell_Height         60

#define Wifi_Cell_Y         (216 + Navi_Height)

#define Psw_Cell_Y          (Wifi_Cell_Y + Cell_Height)

#define Button_Gap          88
#define Button_Height       44

#define Button_X            10
#define Button_Y            (Psw_Cell_Y + Cell_Height + Button_Gap)
#define Button_Width        (Screen_Width - Button_X * 2)

@interface WMDeviceConfigViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WMDeviceConfigCell *wifiCell;
@property (nonatomic, strong) WMDeviceConfigCell *pswCell;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation WMDeviceConfigViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"配置设备";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.wifiCell];
    [self.view addSubview:self.pswCell];
    [self.view addSubview:self.confirmButton];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - Target action
- (void)addEvent:(UIButton *)button {
    NSLog(@"%s",__func__);
    [[FogEasyLinkManager sharedInstance] startEasyLinkWithPassword:self.pswCell.textField.text];
    
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Getters & setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake((Screen_Width - Image_Width)/2, Image_Y, Image_Width, Image_Height)];
        _imageView.image = [UIImage imageNamed:@"device_config_wifi"];
    }
    return _imageView;
}

- (WMDeviceConfigCell *)wifiCell {
    if (!_wifiCell) {
        _wifiCell = [[WMDeviceConfigCell alloc] initWithFrame:WM_CGRectMake(0, Wifi_Cell_Y, Screen_Width, Cell_Height)];
        _wifiCell.titleLabel.text = @"wifi";
        _wifiCell.textField.text = self.ssid;
        _wifiCell.textField.delegate = self;
    }
    return _wifiCell;
}

- (WMDeviceConfigCell *)pswCell {
    if (!_pswCell) {
        _pswCell = [[WMDeviceConfigCell alloc] initWithFrame:WM_CGRectMake(0, Psw_Cell_Y, Screen_Width, Cell_Height)];
        _pswCell.titleLabel.text = @"密码";
        _pswCell.textField.placeholder = @"请输入密码";
        _pswCell.textField.delegate = self;
    }
    return _pswCell;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Button_X, Button_Y, Button_Width, Button_Height)];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        [_confirmButton setTitle:@"添加" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 5;
    }
    return _confirmButton;
}
@end
