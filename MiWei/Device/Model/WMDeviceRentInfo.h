//
//  WMDeviceRentInfo.h
//  MiWei
//
//  Created by LiFei on 2018/7/16.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDeviceRentInfo : NSObject

//租赁价格，单位（分）
@property(nonatomic, strong) NSNumber *price;
//租赁剩余时间，单位（秒）
@property(nonatomic, strong) NSNumber *remainingTime;
//租赁开始时间（unix 时间戳）
@property(nonatomic, strong) NSNumber *startTime;
//租赁总时长，单位（分）
@property(nonatomic, strong) NSNumber *rentTime;

@end
