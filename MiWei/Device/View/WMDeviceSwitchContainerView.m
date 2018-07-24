//
//  WMDeviceSwitchContainerView.m
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceSwitchContainerView.h"
#import "WMUIUtility.h"

#define Radius              60

#define PowerOn_X           28
#define PowerOn_Y           33

#define Gap_X               54
#define Gap_Y               19

#define Ventilation_X       (PowerOn_X + Radius + Gap_X)
#define Ventilation_Y       PowerOn_Y

#define AuxiliaryHeat_X     (Ventilation_X + Radius + Gap_X)
#define AuxiliaryHeat_Y     PowerOn_Y

#define AirSpeed_X          PowerOn_X
#define AirSpeed_Y          (PowerOn_Y + Radius + Gap_Y)

#define Timing_X            Ventilation_X
#define Timing_Y            AirSpeed_Y

#define Setting_X           AuxiliaryHeat_X
#define Setting_Y           AirSpeed_Y

@implementation WMDeviceSwitchContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.powerOnView];
        [self addSubview:self.ventilationView];
        [self addSubview:self.auxiliaryHeatView];
        [self addSubview:self.airSpeedView];
        [self addSubview:self.timingView];
        [self addSubview:self.settingView];
   }
    return self;
}

- (WMDeviceSwitchView *)powerOnView {
    if (!_powerOnView) {
        _powerOnView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(PowerOn_X, PowerOn_Y, Radius, Radius)];
        _powerOnView.name.text = @"开关";
    }
    return _powerOnView;
}

- (WMDeviceSwitchView *)ventilationView {
    if (!_ventilationView) {
        _ventilationView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Ventilation_X, Ventilation_Y, Radius, Radius)];
        _ventilationView.name.text = @"新风";
    }
    return _ventilationView;
}

- (WMDeviceSwitchView *)auxiliaryHeatView {
    if (!_auxiliaryHeatView) {
        _auxiliaryHeatView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(AuxiliaryHeat_X, AuxiliaryHeat_Y, Radius, Radius)];
        _auxiliaryHeatView.name.text = @"电辅热";
    }
    return _auxiliaryHeatView;
}

- (WMDeviceSwitchView *)airSpeedView {
    if (!_airSpeedView) {
        _airSpeedView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(AirSpeed_X, AirSpeed_Y, Radius, Radius)];
        _airSpeedView.name.text = @"风速";
    }
    return _airSpeedView;
}

- (WMDeviceSwitchView *)timingView {
    if (!_timingView) {
        _timingView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Timing_X, Timing_Y, Radius, Radius)];
        _timingView.name.text = @"定时";
    }
    return _timingView;
}

- (WMDeviceSwitchView *)settingView {
    if (!_settingView) {
        _settingView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Setting_X, Setting_Y, Radius, Radius)];
        _settingView.name.text = @"设置";
    }
    return _settingView;
}

@end
