//
//  WMDeviceDetail.m
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceDetail.h"

@implementation WMDeviceDetail

+ (instancetype)deviceDetailFromHTTPData:(NSDictionary *)content {
    WMDeviceDetail *detail = [[WMDeviceDetail alloc] init];
    
    NSDictionary *deviceData = content[@"deviceData"];
    detail.aqLevel = deviceData[@"aqLevel"];
    detail.ch2o = deviceData[@"ch2o"];
    detail.co2 = deviceData[@"co2"];
    detail.humidity = deviceData[@"humidity"];
    detail.lastUpdateTime = deviceData[@"lastUpdateTime"];
    detail.outdoorPM25 = deviceData[@"outdoorPM25"];
    detail.pm25 = deviceData[@"pm25"];
    detail.temp = deviceData[@"temp"];
    detail.tvoc = deviceData[@"tvoc"];
    
    detail.deviceId = content[@"deviceID"];
    detail.name = content[@"deviceName"];
    
    NSDictionary *devicePos = content[@"devicePos"];
    detail.addrDetail = devicePos[@"addrDetail"];
    NSDictionary *district = devicePos[@"district"];
    detail.addrCode = district[@"addrCode"];
    detail.country = district[@"country"];
    detail.addrDepth = district[@"depth"];
    detail.addrLev1 = district[@"lev1"];
    detail.addrLev2 = district[@"lev2"];
    detail.addrLev3 = district[@"lev3"];
    NSDictionary *position = devicePos[@"position"];
    detail.latitude = position[@"latitude"];
    detail.longitude = position[@"longitude"];
    
    NSDictionary *deviceStatus = content[@"deviceStatus"];
    detail.airSpeed = [deviceStatus[@"airSpeed"] longValue];
    detail.auxiliaryHeat = [deviceStatus[@"auxiliaryHeat"] boolValue];
    detail.babyLock = [deviceStatus[@"babyLock"] boolValue];
    detail.fanTiming = [deviceStatus[@"fanTiming"] boolValue];
    detail.online = [deviceStatus[@"online"] boolValue];
    detail.powerOn = [deviceStatus[@"powerOn"] boolValue];
    detail.screenSwitch = [deviceStatus[@"screenSwitch"] boolValue];
    detail.ventilationMode = [deviceStatus[@"ventilationMode"] longValue];
    
    detail.modelName = content[@"modelName"];
    detail.newestVerFw = content[@"newestVerFw"];
    detail.newestVerFwDescr = content[@"newestVerFwDescr"];
    detail.permission = [content[@"permission"] longValue];
    detail.pm25AirText = content[@"pm25AirText"];
    detail.pm25RankText = content[@"pm25RankText"];
    detail.prodName = content[@"prodName"];
    
    NSDictionary *rentInfoDic = content[@"rentInfo"];
    WMDeviceRentInfo *rentInfo = [[WMDeviceRentInfo alloc] init];
    rentInfo.price = rentInfoDic[@"price"];
    rentInfo.rentOwner = rentInfoDic[@"rentOwner"];
    rentInfo.remainingTime = rentInfoDic[@"rentRemainingTime"];
    rentInfo.startTime = rentInfoDic[@"rentStartTime"];
    rentInfo.rentTime = rentInfoDic[@"rentTime"];
    detail.rentInfo = rentInfo;
    
    detail.verFW = content[@"verFW"];
    return detail;
}

@end
