//
//  WMMessage.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WMMessageType) {
    WMMessageTypeStrainerAlarm = 1,
    WMMessageTypeDevShareNoti = 2,
    WMMessageTypeAirQualityNoti = 3
};

@interface WMMessage : NSObject
@property (nonatomic, assign) WMMessageType type;
@property (nonatomic, strong) NSNumber *messageId;
@property (nonatomic, strong) NSNumber *time;
@end
