//
//  WMScanInputViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMScanInputViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMDevice.h"
#import "WMDeviceAddViewController.h"

#define SNTextField_Y               163
#define SNTextField_Width           300
#define SNTextField_Height          44

#define GapBetweenFieldAndLabel     17

#define SNLabel_Y                   (SNTextField_Y + SNTextField_Height + GapBetweenFieldAndLabel)
#define SNLabel_Height              12

#define GapBetweenLabelAndButton    109

#define Button_Y                    (SNLabel_Y + SNLabel_Height + GapBetweenLabelAndButton)
#define Button_Width                SNTextField_Width
#define Button_Height               44

@interface WMScanInputViewController ()
@property (nonatomic,strong) UITextField *SNTextField;
@property (nonatomic,strong) UILabel *SNLabel;
@property (nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMScanInputViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    titleLabel.text = @"手动输入";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    [self setRightNavBar];
    [self.view addSubview:self.SNTextField];
    [self.view addSubview:self.SNLabel];
    [self.view addSubview:self.confirmButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
}

#pragma mark - Target action
- (void)setting:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(UIButton *)btn {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (self.SNTextField.text.length > 0) {
    [dic setObject:self.SNTextField.text forKey:@"deviceID"];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                                   URLString:@"/mobile/device/queryBasicInfo"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        if (result.success) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                WMDevice *device = [[WMDevice alloc] init];
                                                NSDictionary *content = result.content;
                                                device.deviceId = self.SNTextField.text;
                                                device.name = content[@"deviceName"];
                                                NSDictionary *modelDic = content[@"modelInfo"];
                                                WMDeviceModel *model = [[WMDeviceModel alloc] init];
                                                model.image = modelDic[@"imageID"];
                                                model.name = modelDic[@"name"];
                                                device.model = model;
                                                NSDictionary *prodDic = content[@"prodInfo"];
                                                WMDeviceProdInfo *prod = [[WMDeviceProdInfo alloc] init];
                                                prod.name = prodDic[@"name"];
                                                device.prod = prod;
                                                WMDeviceAddViewController *vc = [[WMDeviceAddViewController alloc] init];
                                                vc.device = device;
                                                [self.navigationController pushViewController:vc animated:YES];
                                            });
                                        } else {
                                            NSLog(@"%s queryBasicInfo error %@", __func__, result);
                                        }
                                    }];
    }
}

#pragma mark - Private methods
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"切换扫描" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Getters & setters
- (UITextField *)SNTextField {
    if (!_SNTextField) {
        _SNTextField = [[UITextField alloc] initWithFrame:WM_CGRectMake((Screen_Width - SNTextField_Width)/2, SNTextField_Y, SNTextField_Width, SNTextField_Height)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"请输入设备SN号" attributes:@{NSForegroundColorAttributeName:[WMUIUtility color:@"0x999999"], NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style}];
        _SNTextField.backgroundColor = [WMUIUtility color:@"0xffffff"];
        _SNTextField.attributedPlaceholder = attri;
        _SNTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _SNTextField;
}

- (UILabel *)SNLabel {
    if (!_SNLabel) {
        _SNLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, SNLabel_Y, Screen_Width, SNLabel_Height)];
        _SNLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _SNLabel.textAlignment = NSTextAlignmentCenter;
        _SNLabel.text = @"请输入设备SN号";
        _SNLabel.font = [UIFont systemFontOfSize:12];
    }
    return _SNLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake((Screen_Width - Button_Width)/2, Button_Y, Button_Width, Button_Height)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
