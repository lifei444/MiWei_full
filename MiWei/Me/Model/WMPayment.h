//
//  WMPayment.h
//  MiWei
//
//  Created by LiFei on 2018/8/15.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMPayment : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, strong) NSNumber *payTime;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *rentTime;

@end
