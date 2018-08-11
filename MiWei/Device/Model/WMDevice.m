//
//  WMDevice.m
//  MiWei
//
//  Created by Fei Li on 2018/7/1.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevice.h"

@implementation WMDevice

- (BOOL)isRentDevice {
    return self.model.connWay == WMDeviceModelConnWay2G;
}

@end
