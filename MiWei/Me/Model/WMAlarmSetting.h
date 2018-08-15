//
//  WMAlarmSetting.h
//  MiWei
//
//  Created by LiFei on 2018/8/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMAlarmSetting : NSObject

@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy)   NSString *name;

@end
