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

#endif /* WMDeviceDefine_h */
