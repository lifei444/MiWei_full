//
//  WMDevShareNotiMessage.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessage.h"

@interface WMDevShareNotiMessage : WMMessage

@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, copy)   NSString *deviceName;
//发起请求的用户ID
@property (nonatomic, strong) NSNumber *requestUserID;
//发起请求的用户昵称
@property (nonatomic, copy)   NSString *requestUserName;

@end
