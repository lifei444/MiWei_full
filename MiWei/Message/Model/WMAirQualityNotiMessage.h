//
//  WMAirQualityNotiMessage.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessage.h"

@interface WMAirQualityNotiMessage : WMMessage

@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, copy)   NSString *deviceName;
//室内甲醛告警数值
@property (nonatomic, strong) NSNumber *ch2o;
//室内CO2告警数值
@property (nonatomic, strong) NSNumber *co2;
//室内湿度告警数值
@property (nonatomic, strong) NSNumber *humidity;
//空气告警文案
@property (nonatomic, copy)   NSString *message;
//告警参数标识
@property (nonatomic, strong) NSNumber *paramFlag;
//室内PM2.5告警数值
@property (nonatomic, strong) NSNumber *pm25;
//室内温度告警数值
@property (nonatomic, strong) NSNumber *temp;
//室内TVOC告警数值
@property (nonatomic, strong) NSNumber *tvoc;

@end
