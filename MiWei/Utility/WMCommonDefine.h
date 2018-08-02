//
//  WMCommonDefine.h
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#ifndef WMCommonDefine_h
#define WMCommonDefine_h

FOUNDATION_EXPORT NSString *const WMWechatAuthNotification;

//都以iPhone 6 为准
//#define Screen_Bounds [UIScreen mainScreen].bounds
//#define Screen_Size [UIScreen mainScreen].bounds.size

#define Screen_Height 667//[UIScreen mainScreen].bounds.size.height
#define Screen_Width 375//[UIScreen mainScreen].bounds.size.width

#define Navi_Height 20 + 44//[UIApplication sharedApplication].statusBarFrame.size.height + 44
#define Bottom_height (Navi_Height>64?34.0:0.0)

#endif /* WMCommonDefine_h */
