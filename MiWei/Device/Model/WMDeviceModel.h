//
//  WMDeviceModel.h
//  MiWei
//
//  Created by LiFei on 2018/7/16.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WMDeviceModelConnWay) {
    WMDeviceModelConnWayWIFI = 0,
    WMDeviceModelConnWay2G = 1
};

@interface WMDeviceModel : NSObject

@property(nonatomic, assign) WMDeviceModelConnWay connWay;
@property(nonatomic, strong) NSNumber *modelId;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *name;

@end
