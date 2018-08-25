//
//  WMMatchDeviceInfo.h
//  MiWei
//
//  Created by LiFei on 2018/8/25.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDevice.h"

@interface WMMatchDeviceInfo : NSObject
@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, copy)   NSString *deviceName;
@property (nonatomic, strong) NSArray <WMDevice *> *matchDevices;
@property (nonatomic, assign) BOOL linkControl;
@property (nonatomic, copy)   NSString *matchDeviceID;
@property (nonatomic, copy)   NSString *matchDeviceName;

+ (instancetype)matchDeviceInfoWithDic:(NSDictionary *)dic;
@end
