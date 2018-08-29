//
//  WMMessageFactory.m
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageFactory.h"
#import "WMStrainerAlarmMessage.h"
#import "WMDevShareNotiMessage.h"
#import "WMAirQualityNotiMessage.h"

@implementation WMMessageFactory

+ (WMMessage *)getMessageFromJson:(NSDictionary *)json {
    WMMessage *message = nil;
    int messageType = [json[@"type"] intValue];
    switch (messageType) {
        case WMMessageTypeStrainerAlarm: {
            message = [[WMStrainerAlarmMessage alloc] init];
            message.type = WMMessageTypeStrainerAlarm;
            message.messageId = json[@"id"];
            message.time = json[@"time"];
            NSDictionary *strainerAlarmDic = json[@"strainerAlarm"];
            WMStrainerAlarmMessage *strainAlarmMessage = (WMStrainerAlarmMessage *)message;
            strainAlarmMessage.deviceId = strainerAlarmDic[@"deviceID"];
            strainAlarmMessage.deviceName = strainerAlarmDic[@"deviceName"];
            NSArray *strainerStatusArray = strainerAlarmDic[@"strainerStatus"];
            if (strainerStatusArray) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *strainerStatusDic in strainerStatusArray) {
                    WMStrainerStatus *strainerStatus = [[WMStrainerStatus alloc] init];
                    strainerStatus.isAlarm = [strainerStatusDic[@"alarm"] boolValue];
                    strainerStatus.index = strainerStatusDic[@"index"];
                    strainerStatus.name = strainerStatusDic[@"name"];
                    strainerStatus.reaminingTime = strainerStatusDic[@"reaminingTime"];
                    [array addObject:strainerStatus];
                }
                strainAlarmMessage.strainerStatus = array;
            }
            break;
        }
            
        case WMMessageTypeDevShareNoti: {
            message = [[WMDevShareNotiMessage alloc] init];
            message.type = WMMessageTypeDevShareNoti;
            message.messageId = json[@"id"];
            message.time = json[@"time"];
            NSDictionary *devShareNotiDic = json[@"devShareNoti"];
            WMDevShareNotiMessage *devShareNotiMessage = (WMDevShareNotiMessage *)message;
            devShareNotiMessage.deviceId = devShareNotiDic[@"deviceID"];
            devShareNotiMessage.deviceName = devShareNotiDic[@"deviceName"];
            devShareNotiMessage.requestUserID = devShareNotiDic[@"requestUserID"];
            devShareNotiMessage.requestUserName = devShareNotiDic[@"requestUserName"];
            break;
        }
            
        case WMMessageTypeAirQualityNoti: {
            message = [[WMAirQualityNotiMessage alloc] init];
            message.type = WMMessageTypeAirQualityNoti;
            message.messageId = json[@"id"];
            message.time = json[@"time"];
            NSDictionary *airQualityNotiDic = json[@"airQualityNoti"];
            WMAirQualityNotiMessage *airQualityNotiMessage = (WMAirQualityNotiMessage *)message;
            airQualityNotiMessage.aqLevel = [airQualityNotiDic[@"aqLevel"] longValue];
            airQualityNotiMessage.ch2o = airQualityNotiDic[@"ch2o"];
            airQualityNotiMessage.co2 = airQualityNotiDic[@"co2"];
            airQualityNotiMessage.deviceId = airQualityNotiDic[@"deviceID"];
            airQualityNotiMessage.deviceName = airQualityNotiDic[@"deviceName"];
            airQualityNotiMessage.humidity = airQualityNotiDic[@"humidity"];
            airQualityNotiMessage.message = airQualityNotiDic[@"message"];
            airQualityNotiMessage.paramFlag = [airQualityNotiDic[@"paramFlag"] longValue];
            airQualityNotiMessage.pm25 = airQualityNotiDic[@"pm25"];
            airQualityNotiMessage.temp = airQualityNotiDic[@"temp"];
            airQualityNotiMessage.tvoc = airQualityNotiDic[@"tvoc"];
            break;
        }
            
        default:
            break;
    }
    return message;
}

@end
