//
//  WMDeviceStrainerStatus.m
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceStrainerStatus.h"

@implementation WMDeviceStrainerStatus

+ (instancetype)statusWithDic:(NSDictionary *)dic {
    WMDeviceStrainerStatus *status = [[WMDeviceStrainerStatus alloc] init];
    status.alarm = [dic[@"alarm"] boolValue];
    status.remainingRatio = [dic[@"reaminingRatio"] floatValue];
    status.remainingTime = dic[@"reaminingTime"];
    status.strainerIndex = dic[@"strainerIndex"];
    status.strainerName = dic[@"strainerName"];
    return status;
}

@end
