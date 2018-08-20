//
//  WMDeviceRentInfoForPay.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceRentInfoForPay.h"

@implementation WMDeviceRentInfoForPay

+ (instancetype)rentInfoForPayWithDic:(NSDictionary *)dic {
    WMDeviceRentInfoForPay *info = [[WMDeviceRentInfoForPay alloc] init];
    NSDictionary *rentDevInfoDic = dic[@"rentDevInfo"];
    NSDictionary *currentRentInfo = rentDevInfoDic[@"currentRentInfo"];
    info.rentOwner = currentRentInfo[@"rentOwner"];
    info.rentStatus = [currentRentInfo[@"rentStatus"] longValue];
    NSDictionary *deviceDataDic = rentDevInfoDic[@"deviceData"];
    info.outdoorPM25 = deviceDataDic[@"outdoorPM25"];
    info.pm25 = deviceDataDic[@"pm25"];
    info.lastMaintTime = rentDevInfoDic[@"lastMaintTime"];
    NSDictionary *lastRentInfoDic = rentDevInfoDic[@"lastRentInfo"];
    info.deconAmount = lastRentInfoDic[@"deconAmount"];
    info.rentStartPM25 = lastRentInfoDic[@"rentStartPM25"];
    info.rentStartTime = lastRentInfoDic[@"rentStartTime"];
    info.rentTime = lastRentInfoDic[@"rentTime"];
    info.owner = [rentDevInfoDic[@"owner"] boolValue];
    info.payText = rentDevInfoDic[@"payText"];
    NSArray *rentPricesArray = rentDevInfoDic[@"rentPrices"];
    NSMutableArray *prices = [[NSMutableArray alloc] init];
    for (NSDictionary *priceDic in rentPricesArray) {
        WMDeviceRentPrice *price = [WMDeviceRentPrice rentPriceWithDic:priceDic];
        [prices addObject:price];
    }
    info.rentPrices = prices;
    return info;
}
@end
