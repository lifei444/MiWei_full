//
//  WMDeviceRentPrice.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceRentPrice.h"

@implementation WMDeviceRentPrice

+ (instancetype)rentPriceWithDic:(NSDictionary *)dic {
    WMDeviceRentPrice *price = [[WMDeviceRentPrice alloc] init];
    price.priceId = dic[@"id"];
    price.price = dic[@"price"];
    price.time = dic[@"time"];
    return price;
}
@end
