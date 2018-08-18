//
//  WMDeviceTimer.h
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDeviceDefine.h"

@interface WMDeviceTimer : NSObject
@property (nonatomic, assign) WMAirSpeed airSpeed;
@property (nonatomic, assign) BOOL auxiliaryHeat;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSNumber *timerId;
//true:开机 false：关机，必须
@property (nonatomic, assign) BOOL powerOn;
//Bit0:周一 Bit1:周二 Bit2:周三 …. Bit6:周日 全0：不重复
@property (nonatomic, strong) NSNumber *repetition;
//定时开始时间点（分钟）例如：245，表示4点零5分
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, assign) WMVentilationMode ventilationMode;

+ (instancetype)timerWithDic:(NSDictionary *)dic;
@end
