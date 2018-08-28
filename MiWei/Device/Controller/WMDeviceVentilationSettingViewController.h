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

typedef NS_ENUM(NSUInteger, WMDeviceVentilationSettingMode) {
    //选择结果已经处理完，直接返回
    WMDeviceVentilationSettingModeDirectReturn,
    //不处理选择结果，把选择结果通过回调返回
    WMDeviceVentilationSettingModeDelegate
};

@protocol WMDeviceVentilationSettingDelegate<NSObject>
- (void)onVentilationConfirm:(WMVentilationMode)mode;
@end

@interface WMDeviceVentilationSettingViewController : WMViewController
@property (nonatomic, assign) WMVentilationMode mode;
@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, assign) WMDeviceVentilationSettingMode vcMode;
@property (nonatomic, weak)   id<WMDeviceVentilationSettingDelegate> delegate;
@end
