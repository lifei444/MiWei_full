//
//  WMDevicePayResponse.h
//  MiWei
//
//  Created by LiFei on 2018/8/20.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDeviceDefine.h"

@interface WMDevicePayResponse : NSObject
@property (nonatomic, strong) NSNumber *orderId;
@property (nonatomic, assign) WMOrderStatus orderStatus;
@property (nonatomic, copy)   NSString *nonceStr;
@property (nonatomic, copy)   NSString *partnerId;
@property (nonatomic, copy)   NSString *prepayId;
@property (nonatomic, copy)   NSString *sign;
@property (nonatomic, copy)   NSString *signType;
@property (nonatomic, copy)   NSString *timeStamp;

+ (instancetype)payResponseWithDic:(NSDictionary *)dic;
@end
