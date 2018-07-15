//
//  WMQRCodeGenerator.m
//  SinQRCodeKit
//
//  Created by Sin on 17/1/11.
//  Copyright © 2017年 Sin. All rights reserved.
//

#import "WMQRCodeGenerator.h"
#import <CoreImage/CoreImage.h>
#import "WMUIUtility.h"

@implementation WMQRCodeGenerator
+ (UIImage *)generateQRCodeWithContent:(NSString *)content{
  CGFloat width = 100;
  //获得滤镜输出的图像
  CIImage *outputImage = [self getOutPutImage:content];
  
  return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:width];
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
  CGRect extent = CGRectIntegral(image.extent);
  CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
  // 1.创建bitmap;
  size_t width = CGRectGetWidth(extent) * scale;
  size_t height = CGRectGetHeight(extent) * scale;
  CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
  CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
  CIContext *context = [CIContext contextWithOptions:nil];
  CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
  CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
  CGContextScaleCTM(bitmapRef, scale, scale);
  CGContextDrawImage(bitmapRef, extent, bitmapImage);
  // 2.保存bitmap到图片
  CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
  UIImage *result = [UIImage imageWithCGImage:scaledImage];
  
  //释放相关资源
  CGImageRelease(scaledImage);
  CGImageRelease(bitmapImage);
  CGContextRelease(bitmapRef);
  CGColorSpaceRelease(cs);
  return result;
}

+ (UIImage *)generateInnerImageQRCodeWithContent:(NSString *)content innerImage:(UIImage *)innerImage scale:(CGFloat)scale {
  if(scale < 0 || scale > 1) {
    scale = 0.2;
  }
  
  //获得滤镜输出的图像
  CIImage *outputImage = [self getOutPutImage:content];
  
  // 图片小于(27,27),我们需要放大
  outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
  
  //将CIImage类型转成UIImage类型
  UIImage *start_image = [UIImage imageWithCIImage:outputImage];
  
  
  // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
  //开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
  UIGraphicsBeginImageContext(start_image.size);
  
  // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
  [start_image drawInRect:WM_CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
  
  // 再把小图片画上
  UIImage *icon_image = innerImage;
  CGFloat icon_imageW = start_image.size.width * scale;
  CGFloat icon_imageH = start_image.size.height * scale;
  CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
  CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
  
  [icon_image drawInRect:WM_CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
  
  //获取当前画得的这张图片
  UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
  
  //关闭图形上下文
  UIGraphicsEndImageContext();
  
  return final_image;
}

+ (CIImage *)getOutPutImage:(NSString *)content {
  // 1、创建滤镜对象
  CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  // 恢复滤镜的默认属性
  [filter setDefaults];
  
  // 2、设置数据
  // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
  NSData *qrImageData = [content dataUsingEncoding:NSUTF8StringEncoding];
  
  // 设置过滤器的输入值, KVC赋值
  [filter setValue:qrImageData forKey:@"inputMessage"];
  
  // 3、获得滤镜输出的图像
  return [filter outputImage];
}

@end
