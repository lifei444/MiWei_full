//
//  WMDeviceSwitchContainerView.h
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceSwitchView.h"
#import "WMDeviceDetail.h"

@interface WMDeviceSwitchContainerView : UIView

//开关
@property (nonatomic, strong) WMDeviceSwitchView *powerOnView;
//新风
@property (nonatomic, strong) WMDeviceSwitchView *ventilationView;
//电辅热
@property (nonatomic, strong) WMDeviceSwitchView *auxiliaryHeatView;
//风速
@property (nonatomic, strong) WMDeviceSwitchView *airSpeedView;
//定时
@property (nonatomic, strong) WMDeviceSwitchView *timingView;
//设置
@property (nonatomic, strong) WMDeviceSwitchView *settingView;
//设备类型
@property (nonatomic, strong) NSNumber *prodId;

@property (nonatomic, weak)   UIViewController *vc;

- (void)setModel:(WMDeviceDetail *)detail;

- (void)stopTimerIfNeeded;

@end
