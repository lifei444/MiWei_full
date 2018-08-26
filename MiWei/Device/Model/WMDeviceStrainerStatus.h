//
//  WMDeviceStrainerStatus.h
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDeviceStrainerStatus : NSObject
@property (nonatomic, assign) BOOL alarm;
@property (nonatomic, assign) float remainingRatio;
@property (nonatomic, strong) NSNumber *remainingTime;
@property (nonatomic, strong) NSNumber *strainerIndex;
@property (nonatomic, copy)   NSString *strainerName;

+ (instancetype)statusWithDic:(NSDictionary *)dic;
@end
