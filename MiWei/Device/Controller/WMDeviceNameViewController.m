//
//  WMDeviceNameViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceNameViewController.h"
#import "WMHTTPUtility.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMDeviceNameViewController ()
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UITextField *nameField;
@property(nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMDeviceNameViewController
#pragma mark - Life cycle;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改设备名称";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - Target action
- (void)save {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.nameField.text forKey:@"deviceName"];
    [dic setObject:self.detail.deviceId forKey:@"deviceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/modifyDevice"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (result.success) {
                                            self.detail.name = self.nameField.text;
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } else {
                                            NSLog(@"WMDeviceNameViewController save failed");
                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                        }
                                    });
                                }];
}

#pragma mark - Getters & setters
- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 10, 100, 50)];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.text = @"设备名称";
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [WMUIUtility color:@"0x424345"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UITextField *)nameField {
    if(!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:WM_CGRectMake(100, Navi_Height + 10, Screen_Width - 100, 50)];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.text = self.detail.name;
        _nameField.font = [UIFont systemFontOfSize:16];
        _nameField.textColor = [WMUIUtility color:@"0x737474"];
    }
    return _nameField;
}

- (UIButton *)confirmButton {
    if(!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(10, Navi_Height + 90, Screen_Width - 20, 40)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
