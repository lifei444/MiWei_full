//
//  WMQRCodeScanner.h
//  SinQRCodeKit
//
//  Created by Sin on 17/1/11.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMQRCode.h"

@class WMQRCodeScanner,WMQRCodeScanViewController;

/**
 二维码扫描仪代理
 */
@protocol WMQRCodeScanResultDelegate <NSObject>

/**
 扫描出结果的代理方法

 @param scanner 二维码扫描仪
 @param results 扫描结果
 */
- (void)scanner:(WMQRCodeScanner *)scanner didScanOutResult:(NSArray<NSString *> *)results;

@end

/**
 二维码扫描仪
 */
@interface WMQRCodeScanner : NSObject

/**
 单例方法

 @return 单例对象
 */
+ (instancetype)sharedWMQRCodeScanner;

/**
 WMQRCodeScanResultDelegate
 */
@property(nonatomic,weak) id <WMQRCodeScanResultDelegate> delegate;

/**
 用相机扫描二维码（识别特定范围的二维码）
 
 @param scanView 需要识别的view
 @param rect 需要识别的比例范围，详情参考AVCaptureMetadataOutput的rectOfInterest字段
 */
- (void)scanQRCideWithCamera:(UIView *)scanView rectOfInterest:(CGRect)rect;

/**
 从相册的图片中扫描二维码

 @param currentVC 当前页面，需要从当前页面跳转到相册
 */
- (void)scanQRCodeWithAlbum:(UIViewController *)currentVC;

/**
 识别图中二维码

 @param image 包含二维码的图片
 */
- (void)scanQRCodeFromCurrentImage:(UIImage *)image;

@end
