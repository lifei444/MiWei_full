//
//  WMQRCodeGenerator.h
//  SinQRCodeKit
//
//  Created by Sin on 17/1/11.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 二维码生成器
 */
@interface WMQRCodeGenerator : NSObject

/**
 生成普通的二维码

 @param content 二维码携带的数据
 @return 二维码
 */
+ (UIImage *)generateQRCodeWithContent:(NSString *)content;

/**
 生成内部带图片的二维码

 @param content 二维码携带的数据
 @param innerImage 内部图片
 @param scale 内部图片相对于二维码的缩放比例
 @return 二维码
 @discussion 0<=scale<=1，0代表不显示，1代表与二维码等大，建议设置为0.2，如果scale超出[0,1]，将被设置为0.2
 */
+ (UIImage *)generateInnerImageQRCodeWithContent:(NSString *)content innerImage:(UIImage *)innerImage scale:(CGFloat)scale;
@end
