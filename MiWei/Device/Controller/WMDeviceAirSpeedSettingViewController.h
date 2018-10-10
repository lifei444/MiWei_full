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
#import "WMDeviceDetail.h"

@protocol WMDeviceAirSpeedSettingDelegate<NSObject>
- (void)onAirSpeedConfirm:(WMAirSpeed)speed;
@end

@interface WMDeviceAirSpeedSettingViewController : WMViewController
@property (nonatomic, assign) WMAirSpeed speed;
@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, weak)   id<WMDeviceAirSpeedSettingDelegate> delegage;
@end
