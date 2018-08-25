//
//  WMMatchDeviceInfo.m
//  MiWei
//
//  Created by LiFei on 2018/8/25.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMatchDeviceInfo.h"

@implementation WMMatchDeviceInfo

+ (instancetype)matchDeviceInfoWithDic:(NSDictionary *)dic {
    WMMatchDeviceInfo *info = [[WMMatchDeviceInfo alloc] init];
    info.deviceId = dic[@"deviceID"];
    info.deviceName = dic[@"deviceName"];
    info.linkControl = [dic[@"linkControl"] boolValue];
    info.matchDeviceID = dic[@"matchDeviceID"];
    info.matchDeviceName = dic[@"matchDeviceName"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSArray *deviceList = dic[@"detectors"];
    for (NSDictionary *deviceDic in deviceList) {
        WMDevice *device = [[WMDevice alloc] init];
        device.deviceId = deviceDic[@"deviceID"];
        device.name = deviceDic[@"deviceName"];
        [temp addObject:device];
    }
    info.matchDevices = temp;
    return info;
}
@end
