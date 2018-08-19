//
//  WMDeviceTimer.m
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimer.h"

@implementation WMDeviceTimer

+ (instancetype)timerWithDic:(NSDictionary *)dic {
    WMDeviceTimer *timer = [[WMDeviceTimer alloc] init];
    timer.airSpeed = [dic[@"airSpeed"] longValue];
    timer.auxiliaryHeat = [dic[@"auxiliaryHeat"] boolValue];
    timer.enable = [dic[@"enable"] boolValue];
    timer.timerId = dic[@"id"];
    timer.powerOn = [dic[@"powerOn"] boolValue];
    timer.repetition = dic[@"repetition"];
    timer.startTime = dic[@"startTime"];
    timer.ventilationMode = [dic[@"ventilationMode"] longValue];
    
    return timer;
}
@end
