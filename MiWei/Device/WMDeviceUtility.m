//
//  WMDeviceUtility.m
//  MiWei
//
//  Created by LiFei on 2018/8/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceUtility.h"
#import "WMHTTPUtility.h"

@implementation WMDeviceUtility

+ (void)addDevice:(WMDevice *)device
         location:(CLLocationCoordinate2D)coord
             ssid:(NSString *)ssid
         complete:(void (^)(BOOL))completeBlock {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:device.deviceId forKey:@"deviceID"];
    [dic setObject:@(coord.latitude) forKey:@"latitude"];
    [dic setObject:@(coord.longitude) forKey:@"longitude"];
    [dic setObject:ssid forKey:@"wifiSSID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/addDevice"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (result.success) {
                                            if (completeBlock) {
                                                completeBlock(YES);
                                            }
                                        } else {
                                            NSLog(@"addDevice error, result is %@", result);
                                            if (completeBlock) {
                                                completeBlock(NO);
                                            }
                                        }
                                    });
                                }];
}

+ (NSArray<WMDevice *> *)deviceListFromJson:(NSDictionary *)json {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSArray *devices = json[@"devices"];
    for (NSDictionary *dic in devices) {
        WMDevice *device = [[WMDevice alloc] init];
        device.deviceId = dic[@"deviceID"];
        device.name = dic[@"deviceName"];
        device.online = [dic[@"online"] boolValue];
        device.permission = [dic[@"permission"] longValue];
        NSDictionary *modelDic = dic[@"modelInfo"];
        if (modelDic) {
            WMDeviceModel *model = [[WMDeviceModel alloc] init];
            model.connWay = [modelDic[@"connWay"] longValue];
            model.modelId = modelDic[@"id"];
            model.name = modelDic[@"name"];
            device.model = model;
        }
        NSDictionary *prodDic = dic[@"prodInfo"];
        if (prodDic) {
            WMDeviceProdInfo *prod = [[WMDeviceProdInfo alloc] init];
            prod.prodId = prodDic[@"id"];
            prod.name = prodDic[@"name"];
            device.prod = prod;
        }
        NSDictionary *rentDic = dic[@"rentInfo"];
        if (rentDic) {
            WMDeviceRentInfo *rent = [[WMDeviceRentInfo alloc] init];
            rent.price = rentDic[@"price"];
            rent.remainingTime = rentDic[@"rentRemainingTime"];
            rent.startTime = rentDic[@"rentStartTime"];
            rent.rentTime = rentDic[@"rentTime"];
            device.rentInfo = rent;
        }
        [resultArray addObject:device];
    }
    return [resultArray copy];
}

@end
