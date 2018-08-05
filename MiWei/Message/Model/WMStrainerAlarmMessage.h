//
//  WMStrainerAlarmMessage.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessage.h"
#import "WMStrainerStatus.h"

@interface WMStrainerAlarmMessage : WMMessage

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, strong) NSArray <WMStrainerStatus *> *strainerStatus;

@end
