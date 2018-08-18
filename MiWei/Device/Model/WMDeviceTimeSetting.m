//
//  WMDeviceTimeSetting.m
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimeSetting.h"

@implementation WMDeviceTimeSetting

+ (instancetype)settingWithDic:(NSDictionary *)dic {
    WMDeviceTimeSetting *setting = [[WMDeviceTimeSetting alloc] init];
    setting.deviceId = dic[@"deviceID"];
    setting.enable = [dic[@"enable"] boolValue];
    NSArray *dicArray = dic[@"timers"];
    NSMutableArray *timers = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dicArray) {
        WMDeviceTimer *timer = [WMDeviceTimer timerWithDic:dic];
        [timers addObject:timer];
    }
    setting.timers = timers;
    return setting;
}
@end
