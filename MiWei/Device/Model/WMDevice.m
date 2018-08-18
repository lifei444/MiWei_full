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

- (NSString*)formatRemainingTime {
    long seconds = [self.rentInfo.remainingTime longValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

@end
