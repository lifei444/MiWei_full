//
//  WMScanViewController.h
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMViewController.h"

/**
 扫描二维码发生的错误，主要是申请相册权限出问题
 */
typedef NS_ENUM(NSUInteger, WMQRCodeScanType) {
    WMQRCodeScanPhotoNotDetermined = 0,  //用户尚未选择是否授权（相册）
    WMQRCodeScanPhotoRestricted = 1,     //用户拒绝授权（相册）
    WMQRCodeScanPhotoDenied = 2,         //用户没有权限（相册）
    WMQRCodeScanCameraUnAccess = 3,      //无法获取相机：模拟器（相机）
    WMQRCodeScanCameraNotDetermined = 4, //用户尚未选择是否授权（相机）
    WMQRCodeScanCameraRestricted = 5,    //用户拒绝授权（相机）
    WMQRCodeScanCameraDenied = 6,        //用户没有权限（相机）
    WMQRCodeScanUnknown = 7,             //未知错误
};

@interface WMScanViewController : WMViewController

@end
