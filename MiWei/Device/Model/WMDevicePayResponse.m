//
//  WMDevicePayResponse.m
//  MiWei
//
//  Created by LiFei on 2018/8/20.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePayResponse.h"

@implementation WMDevicePayResponse

+ (instancetype)payResponseWithDic:(NSDictionary *)dic {
    WMDevicePayResponse *result = [[WMDevicePayResponse alloc] init];
    result.orderId = dic[@"orderID"];
    result.orderStatus = [dic[@"orderStatus"] longValue];
    NSDictionary *payParams = dic[@"payParams"];
    result.nonceStr = payParams[@"nonceStr"];
    result.partnerId = payParams[@"partnerId"];
    result.prepayId = payParams[@"prepayId"];
    result.sign = payParams[@"sign"];
    result.signType = payParams[@"signType"];
    result.timeStamp = payParams[@"timeStamp"];
    return result;
}
@end
