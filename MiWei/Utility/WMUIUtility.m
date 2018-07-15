//
//  WMUIUtility.m
//  MiWei
//
//  Created by LiFei on 2018/5/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMUIUtility.h"
#import "WMCommonDefine.h"

static float autoSizeScaleX;
static float autoSizeScaleY;

@implementation WMUIUtility

+ (UIColor *)color:(NSString *)colorString {
    NSArray *colorStrings =
    [[colorString stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"#"];
    
    NSString *rgbString = nil;
    NSString *alphaString = nil;
    
    if (colorStrings.count > 0) {
        rgbString = colorStrings[0];
    }
    if (colorStrings.count > 1) {
        alphaString = colorStrings[1];
    }
    
    unsigned long rgbValue = 0;
    if ([rgbString hasPrefix:@"0x"] || [rgbString hasPrefix:@"0X"]) {
        rgbValue = strtoul([rgbString UTF8String], NULL, 16);
    } else {
        rgbValue = strtoul([rgbString UTF8String], NULL, 10);
    }
    
    float alphaValue = 1.0f;
    if (alphaString.length > 0) {
        alphaValue = [alphaString floatValue];
        if ([alphaString hasSuffix:@"%"]) {
            alphaValue /= 100.0;
        }
    }
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgbValue & 0xFF)) / 255.0
                           alpha:alphaValue];
}

+ (void)registerAutoSizeScale {
    autoSizeScaleX = [UIScreen mainScreen].bounds.size.width / 375;
    autoSizeScaleY = [UIScreen mainScreen].bounds.size.height / 667;
}

+ (CGRect)WMCGRectMakeWithX:(CGFloat)x
                          y:(CGFloat)y
                      width:(CGFloat)width
                     height:(CGFloat)height {
    CGRect result;
    result.origin.x = x * autoSizeScaleX;
    result.origin.y = y * autoSizeScaleY;
    result.size.width = width * autoSizeScaleX;
    result.size.height = height * autoSizeScaleY;
    return result;
}

+ (CGSize)WMCGSizeMakeWithWidth:(CGFloat)width
                         height:(CGFloat)height {
    CGSize result;
    result.width = width * autoSizeScaleX;
    result.height = height * autoSizeScaleY;
    return result;
}

@end
