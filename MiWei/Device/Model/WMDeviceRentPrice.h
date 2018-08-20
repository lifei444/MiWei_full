//
//  WMDeviceRentPrice.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDeviceRentPrice : NSObject
@property (nonatomic, strong) NSNumber *priceId;
//单位：分
@property (nonatomic, strong) NSNumber *price;
//租赁时间，单位：分钟
@property (nonatomic, strong) NSNumber *time;

+ (instancetype)rentPriceWithDic:(NSDictionary *)dic;
@end
