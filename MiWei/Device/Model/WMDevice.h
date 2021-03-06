//
//  WMDevice.h
//  MiWei
//
//  Created by Fei Li on 2018/7/1.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDeviceModel.h"
#import "WMDeviceProdInfo.h"
#import "WMDeviceRentInfo.h"
#import "WMDeviceDefine.h"

@interface WMDevice : NSObject

@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, assign) BOOL deviceOwnerExist;
@property (nonatomic, strong) WMDeviceModel *model;
@property (nonatomic, assign) BOOL online;
@property (nonatomic, assign) WMDevicePermissionType permission;
@property (nonatomic, strong) WMDeviceProdInfo *prod;
@property (nonatomic, strong) WMDeviceRentInfo *rentInfo;

+ (instancetype)deviceFromHTTPData:(NSDictionary *)content;
- (BOOL)isRentDevice;
- (NSString*)formatRemainingTime;

@end
