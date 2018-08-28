//
//  WMScanViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMScanViewController.h"
#import "WMScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "WMQRCode.h"
#import "WMScanInputViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMDevice.h"
#import "WMDeviceAddViewController.h"

@interface WMScanViewController ()<WMQRCodeScannerDelegate>
@property(nonatomic, strong) WMScanView *scanningView;
@end

@implementation WMScanViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    titleLabel.text = @"扫描设备";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    [self setRightNavBar];
    [self.view addSubview:self.scanningView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    //鉴权
    if ([self isCameraExist]) {
        [self cameraAuthorize:^(BOOL result) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 二维码扫描
                    [self scanQRCodeWithCamera];
                    [[WMQRCode sharedWMQRCode] setScannerDelegate:self];
                    [_scanningView startTimer];
                });
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WMQRCode sharedWMQRCode] stopScanAndRemoveViews];
    [[WMQRCode sharedWMQRCode] setScannerDelegate:nil];
    [_scanningView stopTimer];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
}

#pragma mark - Target action
- (void)manualInput:(UIButton *)btn {
    WMScanInputViewController *vc = [[WMScanInputViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"手动输入" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(manualInput:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

//摄像头是否授权
- (void)cameraAuthorize:(void (^)(BOOL result))block {
    __block BOOL isAuthorized = NO;
    __block WMQRCodeScanType type = WMQRCodeScanUnknown;
    NSString *mediaType = AVMediaTypeVideo;                                                         //读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType]; //读取设备授权状态
    if (AVAuthorizationStatusAuthorized == authStatus) {
        isAuthorized = YES;
        block(YES);
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     if (granted) {
                                         isAuthorized = YES;
                                         block(YES);
                                     } else {
                                         type = WMQRCodeScanCameraDenied;
                                         [self errorDidOccured:type];
                                         block(NO);
                                     }
                                 }];
    }
}

- (BOOL)isCameraExist {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL isExist = NO;
    if (device) { //摄像头存在
        isExist = YES;
    } else { //摄像头不存在
        [self errorDidOccured:WMQRCodeScanCameraUnAccess];
    }
    return isExist;
}

- (void)scanQRCodeWithCamera {
    //保证在扫描动画所在的范围内识别二维码
    CGRect scanRect = [self.view convertRect:self.scanningView.scanContentView.frame toView:self.view];
    CGRect rect =
    CGRectMake(scanRect.origin.x / self.view.frame.size.width, scanRect.origin.y / self.view.frame.size.height,
               (scanRect.size.width + scanRect.origin.x) / self.view.frame.size.width,
               (scanRect.size.height + scanRect.origin.y) / self.view.frame.size.height);
    //    rect = CGRectMake(0, 0, 1, 1); -----rect即为最终的扫描比例范围，最大为（0，0，1，1），此时全屏都可扫描；
    [[WMQRCode sharedWMQRCode] scanQRCideWithCamera:self.view rectOfInterest:rect];
}

- (void)errorDidOccured:(WMQRCodeScanType)type {
    [self dealDelegateError:type];
}

#pragma mark - WMQRCodeScannerDelegate
//扫描出结果
- (void)scanQRCode:(WMQRCode *)code didScanOutResult:(NSArray<NSString *> *)results {
    NSLog(@"%s %@", __func__, results);
    NSString *resultString = results[0];
    NSArray *arr = [resultString componentsSeparatedByString:@"="];
    NSString *deviceId = arr[1];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:deviceId forKey:@"deviceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryBasicInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        WMDevice *device = [[WMDevice alloc] init];
                                        NSDictionary *content = result.content;
                                        device.deviceId = deviceId;
                                        device.name = content[@"deviceName"];
                                        device.deviceOwnerExist = [content[@"deviceOwnerExist"] boolValue];
                                        device.online = [content[@"online"] boolValue];
                                        NSDictionary *modelDic = content[@"modelInfo"];
                                        WMDeviceModel *model = [[WMDeviceModel alloc] init];
                                        model.connWay = [modelDic[@"connWay"] longValue];
                                        model.modelId = modelDic[@"id"];
                                        model.image = modelDic[@"imageID"];
                                        model.name = modelDic[@"name"];
                                        device.model = model;
                                        NSDictionary *prodDic = content[@"prodInfo"];
                                        WMDeviceProdInfo *prod = [[WMDeviceProdInfo alloc] init];
                                        prod.prodId = prodDic[@"id"];
                                        prod.name = prodDic[@"name"];
                                        device.prod = prod;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            WMDeviceAddViewController *vc = [[WMDeviceAddViewController alloc] init];
                                            vc.device = device;
                                            [self.navigationController pushViewController:vc animated:YES];
                                        });
                                    } else {
                                        NSLog(@"%s queryBasicInfo error %@", __func__, result);
                                    }
                                }];
}
//扫描失败回调
- (void)dealDelegateError:(NSInteger)type {
    NSLog(@"%s %ld", __func__, (long)type);
}

#pragma mark - Getters & setters
- (WMScanView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[WMScanView alloc] initWithSuperView:self.view];
    }
    return _scanningView;
}

@end
