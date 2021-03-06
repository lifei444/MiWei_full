//
//  WMDeviceDefine.h
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#ifndef WMDeviceDefine_h
#define WMDeviceDefine_h

typedef NS_ENUM(NSUInteger, WMDevicePermissionType) {
    WMDevicePermissionTypeView = 0x01,
    WMDevicePermissionTypeViewAndControl = 0x03,
    WMDevicePermissionTypeOwner = 0x07,
};

typedef NS_ENUM(NSUInteger, WMDeviceType) {
    WMDeviceTypeSell = 0,
    WMDeviceTypeRent = 1,
};

typedef NS_ENUM(NSUInteger, WMAqLevel) {
    WMAqLevelGreen = 0,
    WMAqLevelBlue = 1,
    WMAqLevelYellow = 2,
    WMAqLevelRed = 3
};

typedef NS_ENUM(NSUInteger, WMDeviceSwitchViewTag) {
    WMDeviceSwitchViewTagPowerOn,
    WMDeviceSwitchViewTagVentilation,
    WMDeviceSwitchViewTagAuxiliaryHeat,
    WMDeviceSwitchViewTagAirSpeed,
    WMDeviceSwitchViewTagTiming,
    WMDeviceSwitchViewTagSetting
};

typedef NS_ENUM(NSUInteger, WMVentilationMode) {
    WMVentilationModeLow = 0,
    WMVentilationModeOff = 1,
    WMVentilationModeHigh = 2
};

typedef NS_ENUM(NSUInteger, WMAirSpeed) {
    WMAirSpeedAuto = 0,
    WMAirSpeedSilent = 1,
    WMAirSpeedComfort = 2,
    WMAirSpeedStandard = 3,
    WMAirSpeedStrong = 4,
    WMAirSpeedHurricane = 5
};

typedef NS_ENUM(NSUInteger, WMRentStatus) {
    //空闲
    WMRentStatusIdle = 0,
    //租赁中
    WMRentStatusRent = 1,
    //锁定中
    WMRentStatusLocked = 2
};

typedef NS_ENUM(NSUInteger, WMOrderStatus) {
    //已提交,等待支付
    WMOrderStatusOrderSubmit = 0,
    //支付成功,租赁中
    WMOrderStatusRentSuccess = 1,
    //支付超时,取消订单
    WMOrderStatusPayTimeOut = 2,
    //用户手动取消订单
    WMOrderStatusUserCancel = 3,
    //租赁结束,订单完成
    WMOrderStatusOrderComplete = 4,
    //系统取消订单
    WMOrderStatusSystemCancel = 5,
    //支付成功，等待租赁安排
    WMOrderStatusPaySuccessWaitingForRent = 6,
    //支付失败
    WMOrderStatusPayFailed = 7,
    //退款中
    WMOrderStatusMoneyReturning = 8,
    //退款成功
    WMOrderStatusMoneyReturnSuccess = 9,
    //退款失败
    WMOrderStatusMoneyReturnFailed = 10
};

typedef NS_OPTIONS(NSUInteger, WMAirQualityNotiFlag) {
    WMAirQualityNotiFlagCh2o = 1,
    WMAirQualityNotiFlagPm25 = 1 << 1,
    WMAirQualityNotiFlagHumidity = 1 << 2,
    WMAirQualityNotiFlagTvoc = 1 << 3,
    WMAirQualityNotiFlagTemp = 1 << 4,
    WMAirQualityNotiFlagCo2 = 1 << 5
};
#endif /* WMDeviceDefine_h */
