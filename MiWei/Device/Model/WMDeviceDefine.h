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

#endif /* WMDeviceDefine_h */
