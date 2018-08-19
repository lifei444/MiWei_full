//
//  WMDeviceTimerEditViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceTimer.h"
#import "WMViewController.h"

typedef NS_ENUM(NSUInteger, WMDeviceTimerEditVCMode) {
    WMDeviceTimerEditVCModeAdd,
    WMDeviceTimerEditVCModeEdit
};

@interface WMDeviceTimerEditViewController : WMViewController
@property (nonatomic, assign) WMDeviceTimerEditVCMode mode;
@property (nonatomic, strong) WMDeviceTimer *timer;
@property (nonatomic, copy)   NSString *deviceId;
@end
