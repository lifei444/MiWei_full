//
//  WMUIUtility.h
//  MiWei
//
//  Created by LiFei on 2018/5/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WM_CGRectMake(X, Y, Width, Height) [WMUIUtility WMCGRectMakeWithX:X y:Y width:Width height:Height]
#define WM_CGSizeMake(Width, Height) [WMUIUtility WMCGSizeMakeWithWidth:Width height:Height]

@interface WMUIUtility : NSObject
+ (UIColor *)color:(NSString *)colorString;
+ (void)registerAutoSizeScale;
+ (CGRect)WMCGRectMakeWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                     height:(CGFloat)height;
+ (CGSize)WMCGSizeMakeWithWidth:(CGFloat)width
                         height:(CGFloat)height;
+ (CGFloat)WMCGFloatForX:(CGFloat)value;
+ (CGFloat)WMCGFloatForY:(CGFloat)value;
@end
