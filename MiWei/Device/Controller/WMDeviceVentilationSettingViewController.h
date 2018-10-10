//
//  WMDeviceVentilationSettingViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"
#import "WMViewController.h"
#import "WMDeviceDetail.h"

@protocol WMDeviceVentilationSettingDelegate<NSObject>
- (void)onVentilationConfirm:(WMVentilationMode)mode;
@end

@interface WMDeviceVentilationSettingViewController : WMViewController
@property (nonatomic, assign) WMVentilationMode mode;
@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, weak)   id<WMDeviceVentilationSettingDelegate> delegate;
@end
