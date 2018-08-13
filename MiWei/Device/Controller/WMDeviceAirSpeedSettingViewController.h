//
//  WMDeviceAirSpeedSettingViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"

@interface WMDeviceAirSpeedSettingViewController : UIViewController
@property (nonatomic, assign) WMAirSpeed speed;
@property (nonatomic, copy)   NSString *deviceId;
@end
