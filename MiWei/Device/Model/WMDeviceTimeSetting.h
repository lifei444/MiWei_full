//
//  WMDeviceTimeSetting.h
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDeviceTimer.h"

@interface WMDeviceTimeSetting : NSObject
@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSArray<WMDeviceTimer *> *timers;

+ (instancetype)settingWithDic:(NSDictionary *)dic;
@end
