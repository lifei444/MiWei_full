//
//  WMDeviceAirSpeedSettingViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"
#import "WMViewController.h"

typedef NS_ENUM(NSUInteger, WMDeviceAirSpeedSettingMode) {
    //选择结果已经处理完，直接返回
    WMDeviceAirSpeedSettingModeDirectReturn,
    //不处理选择结果，把选择结果通过回调返回
    WMDeviceAirSpeedSettingModeDelegate
};

@protocol WMDeviceAirSpeedSettingDelegate<NSObject>
- (void)onAirSpeedConfirm:(WMAirSpeed)speed;
@end

@interface WMDeviceAirSpeedSettingViewController : WMViewController
@property (nonatomic, assign) WMAirSpeed speed;
@property (nonatomic, copy)   NSString *deviceId;
@property (nonatomic, assign) WMDeviceAirSpeedSettingMode mode;
@property (nonatomic, weak)   id<WMDeviceAirSpeedSettingDelegate> delegage;
@end
