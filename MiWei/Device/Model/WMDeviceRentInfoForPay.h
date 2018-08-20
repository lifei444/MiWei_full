//
//  WMDeviceRentInfoForPay.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"
#import "WMDeviceRentPrice.h"

@interface WMDeviceRentInfoForPay : NSObject
//currentRentInfo 暂不封装
@property (nonatomic, strong) NSNumber *rentOwner;
@property (nonatomic, assign) WMRentStatus rentStatus;
//deviceData 暂不封装
@property (nonatomic, strong) NSNumber *outdoorPM25;
@property (nonatomic, strong) NSNumber *pm25;
//unix 时间戳
//上次维护时间
@property (nonatomic, strong) NSNumber *lastMaintTime;
//lastRentInfo 暂不封装
//上次租赁去污量
@property (nonatomic, strong) NSNumber *deconAmount;
//上次租赁开始前PM25值
@property (nonatomic, strong) NSNumber *rentStartPM25;
//上次租赁开始的时间 unix 时间戳
@property (nonatomic, strong) NSNumber *rentStartTime;
//上次租赁时长（分钟）
@property (nonatomic, strong) NSNumber *rentTime;
//用户是否为该设备的owner
@property (nonatomic, assign) BOOL owner;
//支付文案
@property (nonatomic, copy)   NSString *payText;
@property (nonatomic, strong) NSArray <WMDeviceRentPrice *> *rentPrices;

+ (instancetype)rentInfoForPayWithDic:(NSDictionary *)dic;
@end
