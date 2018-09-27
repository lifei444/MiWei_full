//
//  WMDevice.m
//  MiWei
//
//  Created by Fei Li on 2018/7/1.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevice.h"

@implementation WMDevice

+ (instancetype)deviceFromHTTPData:(NSDictionary *)content {
    WMDevice *device = [[WMDevice alloc] init];
    device.deviceId = content[@"deviceID"];
    device.name = content[@"deviceName"];
    device.deviceOwnerExist = [content[@"deviceOwnerExist"] boolValue];
    device.online = [content[@"online"] boolValue];
    NSDictionary *modelDic = content[@"modelInfo"];
    WMDeviceModel *model = [[WMDeviceModel alloc] init];
    model.connWay = [modelDic[@"connWay"] longValue];
    model.modelId = modelDic[@"id"];
    model.image = modelDic[@"imageID"];
    model.name = modelDic[@"name"];
    device.model = model;
    NSDictionary *prodDic = content[@"prodInfo"];
    WMDeviceProdInfo *prod = [[WMDeviceProdInfo alloc] init];
    prod.prodId = prodDic[@"id"];
    prod.name = prodDic[@"name"];
    device.prod = prod;
    
    return device;
}

- (BOOL)isRentDevice {
    return self.model.connWay == WMDeviceModelConnWay2G;
}

- (NSString*)formatRemainingTime {
    long seconds = [self.rentInfo.remainingTime longValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

@end
