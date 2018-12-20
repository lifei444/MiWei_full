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
#import "MBProgressHUD.h"
#import "WMDeviceUtility.h"
#import "WMDeviceViewController.h"

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

@interface WMDeviceConfigViewController () <UITextFieldDelegate, FogDeviceDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WMDeviceConfigCell *wifiCell;
@property (nonatomic, strong) WMDeviceConfigCell *pswCell;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *searchTimer;
@property (nonatomic, strong) NSTimer *addTimer;
@property (nonatomic, assign) BOOL isAdding;

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
    [FogDeviceManager sharedInstance].delegate = self;
    [[FogDeviceManager sharedInstance] startSearchDevices];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:90
                                                  target:self
                                                selector:@selector(onSearchTimeExpire)
                                                userInfo:nil
                                                 repeats:NO];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)onSearchTimeExpire {
    NSLog(@"lifei, onSearchTimeExpire");
    [self stopSearchTimer];
    [[FogDeviceManager sharedInstance] stopSearchDevices];
    [[FogEasyLinkManager sharedInstance] stopEasyLink];
    [self.hud hideAnimated:YES];
    [WMUIUtility showAlertWithMessage:@"配网失败" viewController:self];
}

- (void)onAddTimeExpire {
    NSLog(@"lifei, onAddTimeExpire");
    [self stopAddTimer];
    [self.hud hideAnimated:YES];
    [WMUIUtility showAlertWithMessage:@"配网失败" viewController:self];
}

#pragma mark - FogDeviceDelegate
- (void)didSearchDeviceReturnArray:(NSArray *)array {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"lifei, didSearchDeviceReturnArray, count is %d", array.count);
        [self stopSearchTimer];
        if (array.count > 0) {
            NSLog(@"lifei, deviceId is %@", self.deviceId);
            if (self.deviceId) {
                self.addTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                 target:self
                                                               selector:@selector(onAddTimeExpire)
                                                               userInfo:nil
                                                                repeats:NO];
                self.isAdding = YES;
                [self checkAndAddDevice:^(BOOL success) {
                    NSLog(@"lifei, didSearchDeviceReturnArray checkAndAddDevice success %d", success);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[FogDeviceManager sharedInstance] stopSearchDevices];
                        [[FogEasyLinkManager sharedInstance] stopEasyLink];
                        [self stopAddTimer];
                        [self.hud hideAnimated:YES];
                        if (success) {
                            [self popToDeviceListView];
                        } else {
                            [WMUIUtility showAlertWithMessage:@"添加失败" viewController:self];
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.hud hideAnimated:YES];
                    [self popToDeviceListView];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
            });
        }
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private method
- (void)stopSearchTimer {
    if([self.searchTimer isValid]) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
}

- (void)stopAddTimer {
    if ([self.addTimer isValid]) {
        [self.addTimer invalidate];
        self.addTimer = nil;
    }
    self.isAdding = NO;
}

- (void)popToDeviceListView {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[WMDeviceViewController class]]) {
            WMDeviceViewController *vc = (WMDeviceViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)checkAndAddDevice:(void (^)(BOOL))completeBlock {
    if (self.isAdding) {
        NSLog(@"lifei, checkAndAddDevice isAdding");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *deviceId = self.deviceId ?: @"";
        [dic setObject:deviceId forKey:@"deviceID"];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                                   URLString:@"/mobile/device/queryBasicInfo"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        if (result.success) {
                                            NSLog(@"lifei, checkAndAddDevice isAdding success");
                                            WMDevice *device = [WMDevice deviceFromHTTPData:result.content];
                                            if (device.online) {
                                                NSLog(@"lifei, checkAndAddDevice isAdding success online");
                                                [WMDeviceUtility addDevice:self.deviceId
                                                                  location:self.coord
                                                                      ssid:self.ssid
                                                                  complete:^(BOOL success) {
                                                                      NSLog(@"lifei, checkAndAddDevice isAdding success online success %d", success);
                                                                      if (success) {
                                                                          completeBlock(YES);
                                                                      } else {
                                                                          NSLog(@"checkAndAddDevice addDevice error");
                                                                          completeBlock(NO);
                                                                      }
                                                                  }];
                                            } else {
                                                NSLog(@"lifei, checkAndAddDevice isAdding success not online");
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    [self checkAndAddDevice:completeBlock];
                                                });
                                            }
                                        } else {
                                            NSLog(@"%s queryBasicInfo error %@", __func__, result);
                                            completeBlock(NO);
                                        }
                                    }];
    } else {
        NSLog(@"%s add timer expired", __func__);
        completeBlock(NO);
    }
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
        NSString *ssid = [[FogEasyLinkManager sharedInstance] getSSID];
        self.ssid = ssid;
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
