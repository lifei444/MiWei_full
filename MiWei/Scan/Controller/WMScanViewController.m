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

@interface WMScanViewController ()<WMQRCodeScannerDelegate>
@property(nonatomic, strong) WMScanView *scanningView;
@end

@implementation WMScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightNavBar];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    titleLabel.text = @"设备扫描";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    //设置导航栏
    [self.view addSubview:[self scanContentView]];
    //鉴权
    if ([self isCameraAuthorized] && [self isCameraExist]) {
        
        // 二维码扫描
        [self scanQRCodeWithCamera];
    }
    
    [[WMQRCode sharedWMQRCode] setScannerDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    
    [_scanningView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_scanningView stopTimer];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
}

- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"手动输入" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setting:(UIButton *)btn {
    WMScanInputViewController *vc = [[WMScanInputViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)scanContentView {
    if (!_scanningView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = self.view.bounds.origin.y - 64 * (1 - 0.24);
        _scanningView = [[WMScanView alloc] initWithSuperView:self.view];
    }
    return _scanningView;
}

- (void)scanQRCodeWithCamera {
    //保证在扫描动画所在的范围内识别二维码
    CGRect scanRect = [self.view convertRect:self.scanningView.scanContentView.frame toView:self.view];
    CGRect rect =
    WM_CGRectMake(scanRect.origin.x / self.view.frame.size.width, scanRect.origin.y / self.view.frame.size.height,
               (scanRect.size.width + scanRect.origin.x) / self.view.frame.size.width,
               (scanRect.size.height + scanRect.origin.y) / self.view.frame.size.height);
    //    rect = CGRectMake(0, 0, 1, 1); -----rect即为最终的扫描比例范围，最大为（0，0，1，1），此时全屏都可扫描；
    [[WMQRCode sharedWMQRCode] scanQRCideWithCamera:self.view rectOfInterest:rect];
}

//进入相册（添加按钮点击事件来实现）
- (void)enterAlbum {
    if ([self isAlbumAuthorized]) {
        
        [[WMQRCode sharedWMQRCode] scanQRCodeWithAlbum:nil];
    }
}

//摄像头是否授权
- (BOOL)isCameraAuthorized {
    __block BOOL isAuthorized = NO;
    __block WMQRCodeScanType type = WMQRCodeScanUnknown;
    NSString *mediaType = AVMediaTypeVideo;                                                         //读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType]; //读取设备授权状态
    if (AVAuthorizationStatusAuthorized == authStatus) {
        isAuthorized = YES;
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     if (granted) {
                                         isAuthorized = YES;
                                     } else {
                                         type = WMQRCodeScanCameraDenied;
                                     }
                                 }];
    }
    if (type == WMQRCodeScanUnknown) {
        type = authStatus + 4; //相机权限从4开始
    }
    if (!isAuthorized) {
        [self errorDidOccured:type];
    }
    return isAuthorized;
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

- (BOOL)isAlbumAuthorized {
    //检测是否获取了相册权限
    __block BOOL isAuthorized = NO;
    __block NSUInteger type = WMQRCodeScanUnknown;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (PHAuthorizationStatusAuthorized == status) { //已授权
        isAuthorized = YES;
    } else if (status == PHAuthorizationStatusNotDetermined) {                 // 用户还没有做出选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { // 弹框请求用户授权
            if (status == PHAuthorizationStatusAuthorized) {                   // 用户点击了好
                isAuthorized = YES;
            } else {
                type = status;
            }
        }];
    } else {
        type = status;
    }
    
    if (!isAuthorized) {
        NSLog(@"用户没有打开相册权限");
    }
    return isAuthorized;
}

- (void)errorDidOccured:(WMQRCodeScanType)type {
    [self dealDelegateError:type];
}

#pragma mark - WMQRCodeScannerDelegate
//扫描出结果
- (void)scanQRCode:(WMQRCode *)code didScanOutResult:(NSArray<NSString *> *)results {
    NSLog(@"%s %@",__func__,results);
}
//扫描失败回调
- (void)dealDelegateError:(NSInteger)type {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resouWMs that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
