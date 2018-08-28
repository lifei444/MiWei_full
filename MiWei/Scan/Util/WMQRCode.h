//
//  WMQRCode.h
//  SinQRCodeKit
//
//  Created by Sin on 17/1/12.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMQRCode;

@protocol WMQRCodeScannerDelegate <NSObject>

/**
 扫描出结果的代理方法
 
 @param code 二维码扫描管理类
 @param results 扫描结果。注：如果没有二维码，将会返回一个空数组
 */
- (void)scanQRCode:(WMQRCode *)code didScanOutResult:(NSArray<NSString *> *)results;

@end


/**
 二维码核心类，集二维码生成，二维码扫描于一体
 @discussion 该SDK并不会做相机和相册权限的检测，请开发者在调用生成二维码接口的时候自行检测权限
 */
@interface WMQRCode : NSObject

/**
 单例类

 @return 单例对象
 */
+ (instancetype)sharedWMQRCode;

#pragma mark 生成二维码
/**
 生成普通的二维码
 
 @param content 二维码携带的数据
 @return 二维码
 */
- (UIImage *)generateQRCodeWithContent:(NSString *)content;

/**
 生成内部带图片的二维码
 
 @param content 二维码携带的数据
 @param innerImage 内部图片
 @param scale 内部图片相对于二维码的缩放比例
 @return 二维码
 @discussion 0<=scale<=1，0代表不显示，1代表与二维码等大，建议设置为0.2，如果scale超出[0,1]，将被设置为0.2
 */
- (UIImage *)generateInnerImageQRCodeWithContent:(NSString *)content innerImage:(UIImage *)innerImage scale:(CGFloat)scale;

#pragma mark 扫描二维码
/**
 扫描仪的代理
 @warning 只有调用了下面三个scan开头的方法之后才能正确响应该代理的代理方法
 */
@property (nonatomic, weak) id<WMQRCodeScannerDelegate> scannerDelegate;

/**
 用相机扫描二维码（识别特定范围的二维码）

 @param containerView 需要识别的view，直接传二维码扫描ViewController的self.view即可
 @param rect 需要识别的相较于containerView的比例范围，详情参考 AVCaptureMetadataOutput 的 rectOfInterest 字段
 @discussion 如果需要扫描整个VC的范围，那么containerView传self.view，rect传CGRectMake(0, 0, 1, 1)
 */
- (void)scanQRCideWithCamera:(UIView *)containerView rectOfInterest:(CGRect)rect;


/**
 从相册的图片中扫描二维码
 
 @param currentVC 当前页面，需要从当前页面跳转到相册，扫描出结果会触发WMQRCodeScannerDelegate的代理方法
 */
- (void)scanQRCodeWithAlbum:(UIViewController *)currentVC;

/**
 识别图中的二维码

 @param image 包含二维码的图片，扫描出结果会触发WMQRCodeScannerDelegate的代理方法
 */
- (void)scanQRCodeFromImage:(UIImage *)image;

/**
 停止扫描并移除view
 */
- (void)stopScanAndRemoveViews;

@end

