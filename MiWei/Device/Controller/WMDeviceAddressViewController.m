//
//  WMDeviceAddressViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceAddressViewController.h"
#import "WMHTTPUtility.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMDeviceAddressViewController ()
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UITextField *addressField;
@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UITextField *detailField;
@property(nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMDeviceAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressField];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.detailField];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - Target action
- (void)save {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:self.nameField.text forKey:@"deviceName"];
//    [dic setObject:self.detail.deviceId forKey:@"deviceID"];
//    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
//                               URLString:@"/mobile/device/modifyDevice"
//                              parameters:dic
//                                response:^(WMHTTPResult *result) {
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        if (result.success) {
//                                            self.detail.name = self.nameField.text;
//                                            [self.navigationController popViewControllerAnimated:YES];
//                                        } else {
//                                            NSLog(@"WMDeviceNameViewController save failed");
//                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
//                                        }
//                                    });
//                                }];
}

#pragma mark - Getters & setters
- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 10, 100, 50)];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        _addressLabel.text = @"省市区";
        _addressLabel.font = [UIFont systemFontOfSize:16];
        _addressLabel.textColor = [WMUIUtility color:@"0x424345"];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UITextField *)addressField {
    if(!_addressField) {
        _addressField = [[UITextField alloc] initWithFrame:WM_CGRectMake(100, Navi_Height + 10, Screen_Width - 100, 50)];
        _addressField.backgroundColor = [UIColor whiteColor];
        _addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressField.text = [NSString stringWithFormat:@"%@%@%@", self.detail.addrLev1, self.detail.addrLev2, self.detail.addrLev3];
        _addressField.font = [UIFont systemFontOfSize:16];
        _addressField.textColor = [WMUIUtility color:@"0x737474"];
    }
    return _addressField;
}

- (UILabel *)detailLabel {
    if(!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 10 + 50 + 10, 100, 50)];
        _detailLabel.backgroundColor = [UIColor whiteColor];
        _detailLabel.text = @"详细地址";
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textColor = [WMUIUtility color:@"0x424345"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UITextField *)detailField {
    if(!_detailField) {
        _detailField = [[UITextField alloc] initWithFrame:WM_CGRectMake(100, Navi_Height + 10 + 50 + 10, Screen_Width - 100, 50)];
        _detailField.backgroundColor = [UIColor whiteColor];
        _detailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailField.text = self.detail.addrDetail;
        _detailField.font = [UIFont systemFontOfSize:16];
        _detailField.textColor = [WMUIUtility color:@"0x737474"];
    }
    return _detailField;
}

- (UIButton *)confirmButton {
    if(!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(10, Navi_Height + 90 + 50 + 10, Screen_Width - 20, 40)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
