//
//  WMDeviceDetail.h
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDeviceDefine.h"
#import "WMDeviceRentInfo.h"

@interface WMDeviceDetail : NSObject

//deviceData 暂时不封装
//空气质量等级
@property (nonatomic, strong) NSNumber *aqLevel;
//室内甲醛
@property (nonatomic, strong) NSNumber *ch2o;
//室内二氧化碳
@property (nonatomic, strong) NSNumber *co2;
//室内湿度
@property (nonatomic, strong) NSNumber *humidity;
//最后数据更新时间 Unix 时间戳
@property (nonatomic, strong) NSNumber *lastUpdateTime;
//室外PM2.5
@property (nonatomic, strong) NSNumber *outdoorPM25;
//室内PM2.5
@property (nonatomic, strong) NSNumber *pm25;
//室内温度
@property (nonatomic, strong) NSNumber *temp;
//室内TVOC
@property (nonatomic, strong) NSNumber *tvoc;

@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, copy)   NSString *name;

//devicePos 暂不封装
@property (nonatomic, copy)   NSString *addrDetail;
//地址码
@property (nonatomic, strong) NSNumber *addrCode;
@property (nonatomic, copy)   NSString *country;
@property (nonatomic, strong) NSNumber *addrDepth;
@property (nonatomic, copy)   NSString *addrLev1;
@property (nonatomic, copy)   NSString *addrLev2;
@property (nonatomic, copy)   NSString *addrLev3;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

//deviceStatus 暂不封装
//风速档位
@property (nonatomic, assign) WMAirSpeed airSpeed;
//电辅热开关
@property (nonatomic, assign) BOOL auxiliaryHeat;
//婴儿锁开关
@property (nonatomic, assign) BOOL babyLock;
//风机定时模式
@property (nonatomic, assign) BOOL fanTiming;
//设备是否在线
@property (nonatomic, assign) BOOL online;
//开关状态
@property (nonatomic, assign) BOOL powerOn;
//灯光面板开关
@property (nonatomic, assign) BOOL screenSwitch;
//新风模式
@property (nonatomic, assign) WMVentilationMode ventilationMode;

//设备型号
@property (nonatomic, copy)   NSString *modelName;
//最新固件版本
@property (nonatomic, strong) NSNumber *newestVerFw;
//最新固件描述
@property (nonatomic, copy)   NSString *newestVerFwDescr;
//用户设备权限
@property (nonatomic, assign) WMDevicePermissionType permission;
//PM2.5空气文案
@property (nonatomic, copy)   NSString *pm25AirText;
//PM2.5排名文案
@property (nonatomic, copy)   NSString *pm25RankText;
//设备类型
@property (nonatomic, copy)   NSString *prodName;

@property (nonatomic, strong) WMDeviceRentInfo *rentInfo;
//设备当前固件版本
@property (nonatomic, strong) NSNumber *verFW;

+ (instancetype)deviceDetailFromHTTPData:(NSDictionary *)content;
@end
