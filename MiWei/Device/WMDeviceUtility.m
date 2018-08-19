//
//  WMDeviceUtility.m
//  MiWei
//
//  Created by LiFei on 2018/8/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceUtility.h"

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
            model.image = modelDic[@"imageID"];
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

+ (void)setDevice:(NSDictionary *)dic response:(void (^)(WMHTTPResult *))responseBlock {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/control"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (responseBlock) {
                                        responseBlock(result);
                                    }
                                }];
}

+ (NSString *)descriptionOfAirSpeed:(WMAirSpeed)airSpeed {
    NSString *str = @"";
    if (airSpeed == WMAirSpeedAuto) {
        str = @"自动";
    } else if (airSpeed == WMAirSpeedSilent) {
        str = @"静音";
    } else if (airSpeed == WMAirSpeedComfort) {
        str = @"舒适";
    } else if (airSpeed == WMAirSpeedStandard) {
        str = @"标准";
    } else if (airSpeed == WMAirSpeedStrong) {
        str = @"强力";
    } else if (airSpeed == WMAirSpeedHurricane) {
        str = @"飓风";
    }
    return str;
}

+ (NSString *)descriptionOfVentilation:(WMVentilationMode)mode {
    NSString *str = @"";
    if (mode == WMVentilationModeLow) {
        str = @"低效";
    } else if (mode == WMVentilationModeOff) {
        str = @"关闭";
    } else if (mode == WMVentilationModeHigh) {
        str = @"高效";
    }
    return str;
}

+ (NSString *)generateWeekDayString:(NSNumber *)value {
    NSString *repeatString = @"";
    int repeatValue = [value intValue];
    if (repeatValue == 0) {
        repeatString = @"永不";
    } else if ((repeatValue & 0x7f) == 0x7f) {
        repeatString = @"每天";
    } else {
        int bit = 0x01;
        NSArray *weekDay = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        for (int i = 0; i < 7; i++) {
            if ((bit & repeatValue) != 0) {
                repeatString = [repeatString stringByAppendingString:[NSString stringWithFormat:@"%@ ", weekDay[i]]];
            }
            bit = 0x01 << (i + 1);
        }
        repeatString = [repeatString substringToIndex:(repeatString.length-1)];
    }
    return repeatString;
}

+ (NSArray<NSNumber *> *)generateWeekDayArray:(NSNumber *)value {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    int repeatValue = [value intValue];
    if (repeatValue == 0) {
    } else if ((repeatValue & 0x7f) == 0x7f) {
        for (int i = 0; i < 7; i++) {
            [temp addObject:@(i)];
        }
    } else {
        int bit = 0x01;
        for (int i = 0; i < 7; i++) {
            if ((bit & repeatValue) != 0) {
                [temp addObject:@(i)];
            }
            bit = 0x01 << (i + 1);
        }
    }
    return temp;
}

+ (NSString *)generatePriceStringFromPrice:(NSNumber *)fenNumber andRentTime:(NSNumber *)minuteNumber {
    int yuan = [fenNumber intValue] / 100;
    int fen = [fenNumber intValue] % 100;
    NSString *priceString = [NSString stringWithFormat:@"%d.%02d元/%d小时", yuan, fen, [minuteNumber intValue]/60];
    return priceString;
}

+ (NSString *)timeStringFromSecond:(NSNumber *)time {
    int timeInt = [time intValue];
    int hour = timeInt / 3600;
    int minute = (timeInt % 3600) / 60;
    int second = timeInt % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
}
@end
