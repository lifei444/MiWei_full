//
//  WMDeviceSwitchContainerView.m
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceSwitchContainerView.h"
#import "WMUIUtility.h"
#import "WMDeviceUtility.h"
#import "MBProgressHUD.h"
#import "WMDeviceVentilationSettingViewController.h"
#import "WMDeviceAirSpeedSettingViewController.h"

#define Radius                  60

#define PowerOn_X               28
#define PowerOn_Y               13//33

#define GapBetweenCircleLabel   8
#define Label_Y1                (PowerOn_Y + Radius + GapBetweenCircleLabel)
#define Label_Height            16

#define Gap_X                   54
#define Gap_Y                   8

#define Ventilation_X           (PowerOn_X + Radius + Gap_X)
#define Ventilation_Y           PowerOn_Y

#define AuxiliaryHeat_X         (Ventilation_X + Radius + Gap_X)
#define AuxiliaryHeat_Y         PowerOn_Y

#define AirSpeed_X              PowerOn_X
#define AirSpeed_Y              (Label_Y1 + Label_Height + Gap_Y)

#define Timing_X                Ventilation_X
#define Timing_Y                AirSpeed_Y

#define Setting_X               AuxiliaryHeat_X
#define Setting_Y               AirSpeed_Y

#define Label_Y2                (AirSpeed_Y + Radius + GapBetweenCircleLabel)

@interface WMDeviceSwitchContainerView () <WMDeviceSwitchViewDelegate>
@property (nonatomic, strong) UILabel *powerOnLabel;
@property (nonatomic, strong) UILabel *ventilationLabel;
@property (nonatomic, strong) UILabel *auxiliaryHeatLabel;
@property (nonatomic, strong) UILabel *airSpeedLabel;
@property (nonatomic, strong) UILabel *timingLabel;
@property (nonatomic, strong) UILabel *settingLabel;
@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceSwitchContainerView
#pragma mark - Life cycle
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
        [self addSubview:self.powerOnLabel];
        [self addSubview:self.ventilationLabel];
        [self addSubview:self.auxiliaryHeatLabel];
        [self addSubview:self.airSpeedLabel];
        [self addSubview:self.timingLabel];
        [self addSubview:self.settingLabel];

   }
    return self;
}

#pragma mark - Public method
- (void)setModel:(WMDeviceDetail *)detail {
    self.deviceDetail = detail;
    if (detail.online) {
        if (detail.powerOn) {
            self.powerOnView.name.text = @"开";
            self.powerOnView.status = 1;
        } else {
            self.powerOnView.name.text = @"关";
            self.powerOnView.status = 0;
        }
        self.powerOnView.isOn = YES;
        if (detail.ventilationMode == WMVentilationModeLow) {
            self.ventilationView.name.text = @"低效";
        } else if (detail.ventilationMode == WMVentilationModeOff) {
            self.ventilationView.name.text = @"关闭";
        } else if (detail.ventilationMode == WMVentilationModeHigh) {
            self.ventilationView.name.text = @"高效";
        }
        self.ventilationView.status = detail.ventilationMode;
        self.ventilationView.isOn = YES;
        if (detail.auxiliaryHeat) {
            self.auxiliaryHeatView.name.text = @"开";
            self.auxiliaryHeatView.status = 1;
        } else {
            self.auxiliaryHeatView.name.text = @"关";
            self.auxiliaryHeatView.status = 0;
        }
        self.auxiliaryHeatView.isOn = YES;
        switch (detail.airSpeed) {
            case WMAirSpeedAuto:
                self.airSpeedView.name.text = @"自动";
                break;
            case WMAirSpeedSilent:
                self.airSpeedView.name.text = @"静音";
                break;
            case WMAirSpeedComfort:
                self.airSpeedView.name.text = @"舒适";
                break;
            case WMAirSpeedStandard:
                self.airSpeedView.name.text = @"标准";
                break;
            case WMAirSpeedStrong:
                self.airSpeedView.name.text = @"强力";
                break;
            case WMAirSpeedHurricane:
                self.airSpeedView.name.text = @"飓风";
                break;
                
            default:
                break;
        }
        self.airSpeedView.status = detail.airSpeed;
        self.airSpeedView.isOn = YES;
    } else {
        self.powerOnView.isOn = NO;
        self.ventilationView.isOn = NO;
        self.auxiliaryHeatView.isOn = NO;
        self.airSpeedView.isOn = NO;
    }
    if (detail.permission == WMDevicePermissionTypeOwner) {
        self.settingView.isOn = YES;
    } else {
        self.settingView.isOn = NO;
    }
    self.timingView.isOn = YES;
}

#pragma mark - WMDeviceSwitchViewDelegate
- (void)viewDidTap:(WMDeviceSwitchViewTag)tag {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.deviceDetail.deviceId forKey:@"deviceID"];

    switch (tag) {
        case WMDeviceSwitchViewTagPowerOn: {
            BOOL powerOn = (self.powerOnView.status == 1);
            [dic setObject:@(!powerOn) forKey:@"powerOn"];
            self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            [WMDeviceUtility setDevice:dic
                              response:^(WMHTTPResult *result) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.hud hideAnimated:YES];
                                      if (result.success) {
                                          [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self.vc];
                                          if (self.powerOnView.status == 1) {
                                              self.powerOnView.status = 0;
                                              self.powerOnView.name.text = @"关";
                                          } else {
                                              self.powerOnView.status = 1;
                                              self.powerOnView.name.text = @"开";
                                          }
                                      } else {
                                          NSLog(@"poweron set fail, result is %@", result);
                                          [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self.vc];
                                      }
                                  });
                              }];
            break;
        }
        case WMDeviceSwitchViewTagVentilation: {
            WMDeviceVentilationSettingViewController *vc = [[WMDeviceVentilationSettingViewController alloc] init];
            vc.mode = self.deviceDetail.ventilationMode;
            vc.deviceId = self.deviceDetail.deviceId;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WMDeviceSwitchViewTagAuxiliaryHeat: {
            BOOL auxiliaryHeat = (self.auxiliaryHeatView.status == 1);
            [dic setObject:@(!auxiliaryHeat) forKey:@"auxiliaryHeat"];
            self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            [WMDeviceUtility setDevice:dic
                              response:^(WMHTTPResult *result) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.hud hideAnimated:YES];
                                      if (result.success) {
                                          [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self.vc];
                                          if (self.auxiliaryHeatView.status == 1) {
                                              self.auxiliaryHeatView.status = 0;
                                              self.auxiliaryHeatView.name.text = @"关";
                                          } else {
                                              self.auxiliaryHeatView.status = 1;
                                              self.auxiliaryHeatView.name.text = @"开";
                                          }
                                      } else {
                                          NSLog(@"poweron set fail, result is %@", result);
                                          [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self.vc];
                                      }
                                  });
                              }];
            break;
        }
        case WMDeviceSwitchViewTagAirSpeed: {
            WMDeviceAirSpeedSettingViewController *vc = [[WMDeviceAirSpeedSettingViewController alloc] init];
            vc.speed = self.deviceDetail.airSpeed;
            vc.deviceId = self.deviceDetail.deviceId;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WMDeviceSwitchViewTagTiming: {
            
            break;
        }
        case WMDeviceSwitchViewTagSetting: {
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Getters & setters
- (WMDeviceSwitchView *)powerOnView {
    if (!_powerOnView) {
        _powerOnView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(PowerOn_X, PowerOn_Y, Radius, Radius)];
        _powerOnView.name.text = @"关";
        _powerOnView.viewTag = WMDeviceSwitchViewTagPowerOn;
        _powerOnView.delegate = self;
    }
    return _powerOnView;
}

- (WMDeviceSwitchView *)ventilationView {
    if (!_ventilationView) {
        _ventilationView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Ventilation_X, Ventilation_Y, Radius, Radius)];
        _ventilationView.name.text = @"关闭";
        _ventilationView.viewTag = WMDeviceSwitchViewTagVentilation;
        _ventilationView.delegate = self;
    }
    return _ventilationView;
}

- (WMDeviceSwitchView *)auxiliaryHeatView {
    if (!_auxiliaryHeatView) {
        _auxiliaryHeatView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(AuxiliaryHeat_X, AuxiliaryHeat_Y, Radius, Radius)];
        _auxiliaryHeatView.name.text = @"关";
        _auxiliaryHeatView.viewTag = WMDeviceSwitchViewTagAuxiliaryHeat;
        _auxiliaryHeatView.delegate = self;
    }
    return _auxiliaryHeatView;
}

- (WMDeviceSwitchView *)airSpeedView {
    if (!_airSpeedView) {
        _airSpeedView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(AirSpeed_X, AirSpeed_Y, Radius, Radius)];
        _airSpeedView.name.text = @"自动";
        _airSpeedView.viewTag = WMDeviceSwitchViewTagAirSpeed;
        _airSpeedView.delegate = self;
   }
    return _airSpeedView;
}

- (WMDeviceSwitchView *)timingView {
    if (!_timingView) {
        _timingView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Timing_X, Timing_Y, Radius, Radius)];
        _timingView.name.text = @"定时";
        _timingView.viewTag = WMDeviceSwitchViewTagTiming;
        _timingView.delegate = self;
    }
    return _timingView;
}

- (WMDeviceSwitchView *)settingView {
    if (!_settingView) {
        _settingView = [[WMDeviceSwitchView alloc] initWithFrame:WM_CGRectMake(Setting_X, Setting_Y, Radius, Radius)];
        _settingView.name.text = @"设置";
        _settingView.viewTag = WMDeviceSwitchViewTagSetting;
        _settingView.delegate = self;
    }
    return _settingView;
}

- (UILabel *)powerOnLabel {
    if (!_powerOnLabel) {
        _powerOnLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(PowerOn_X, Label_Y1, Radius, 16)];
        _powerOnLabel.text = @"开关";
        _powerOnLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _powerOnLabel.textAlignment = NSTextAlignmentCenter;
        _powerOnLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _powerOnLabel;
}

- (UILabel *)ventilationLabel {
    if (!_ventilationLabel) {
        _ventilationLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Ventilation_X, Label_Y1, Radius, 16)];
        _ventilationLabel.text = @"新风";
        _ventilationLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _ventilationLabel.textAlignment = NSTextAlignmentCenter;
        _ventilationLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _ventilationLabel;
}

- (UILabel *)auxiliaryHeatLabel {
    if (!_auxiliaryHeatLabel) {
        _auxiliaryHeatLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(AuxiliaryHeat_X, Label_Y1, Radius, 16)];
        _auxiliaryHeatLabel.text = @"辅热";
        _auxiliaryHeatLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _auxiliaryHeatLabel.textAlignment = NSTextAlignmentCenter;
        _auxiliaryHeatLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _auxiliaryHeatLabel;
}

- (UILabel *)airSpeedLabel {
    if (!_airSpeedLabel) {
        _airSpeedLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(AirSpeed_X, Label_Y2, Radius, 16)];
        _airSpeedLabel.text = @"风速";
        _airSpeedLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _airSpeedLabel.textAlignment = NSTextAlignmentCenter;
        _airSpeedLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _airSpeedLabel;
}

- (UILabel *)timingLabel {
    if (!_timingLabel) {
        _timingLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Timing_X, Label_Y2, Radius, 16)];
        _timingLabel.text = @"定时";
        _timingLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _timingLabel.textAlignment = NSTextAlignmentCenter;
        _timingLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _timingLabel;
}

- (UILabel *)settingLabel {
    if (!_settingLabel) {
        _settingLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Setting_X, Label_Y2, Radius, 16)];
        _settingLabel.text = @"设置";
        _settingLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _settingLabel.textAlignment = NSTextAlignmentCenter;
        _settingLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _settingLabel;
}
@end
