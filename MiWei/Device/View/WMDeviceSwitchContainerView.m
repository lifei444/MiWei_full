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
#import "WMDeviceTimeSettingViewController.h"
#import "WMDeviceSettingViewController.h"

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

#define Refresh_Max_Count       10
#define Refresh_Interval        2 //单位：秒

typedef NS_ENUM(NSUInteger, DeviceSetType) {
    DeviceSetTypePowerOn = 1,
    DeviceSetTypeVentilation = 2,
    DeviceSetTypeAuxiliary = 3,
    DeviceSetTypeAirSpeed = 4
};

@interface DeviceSetOperation : NSObject
@property (nonatomic, assign) DeviceSetType deviceSetType;
@property (nonatomic, strong) id deviceSetValue;
@end

@implementation DeviceSetOperation
@end

@interface WMDeviceSwitchContainerView () <WMDeviceSwitchViewDelegate, WMDeviceVentilationSettingDelegate, WMDeviceAirSpeedSettingDelegate>
@property (nonatomic, strong) UILabel *powerOnLabel;
@property (nonatomic, strong) UILabel *ventilationLabel;
@property (nonatomic, strong) UILabel *auxiliaryHeatLabel;
@property (nonatomic, strong) UILabel *airSpeedLabel;
@property (nonatomic, strong) UILabel *timingLabel;
@property (nonatomic, strong) UILabel *settingLabel;
@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) DeviceSetOperation *deviceSetOperation;
@property (nonatomic, assign) BOOL isSetting;
@property (nonatomic, assign) int refreshCount;
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
    if (detail.powerOn) {
        self.powerOnView.name.text = @"开";
        self.powerOnView.status = 1;
    } else {
        self.powerOnView.name.text = @"关";
        self.powerOnView.status = 0;
    }
    [self refreshVentilationMode:detail.ventilationMode];
    if (detail.auxiliaryHeat) {
        self.auxiliaryHeatView.name.text = @"开";
        self.auxiliaryHeatView.status = 1;
    } else {
        self.auxiliaryHeatView.name.text = @"关";
        self.auxiliaryHeatView.status = 0;
    }
    [self refreshAirSpeed:detail.airSpeed];
    if (detail.fanTiming) {
        self.timingView.name.text = @"开";
        self.timingView.status = 1;
    } else {
        self.timingView.name.text = @"关";
        self.timingView.status = 0;
    }
    //0: 净化器； 1: 检测仪
    if ([self.prodId intValue] == 0) {
        if ((detail.permission == WMDevicePermissionTypeViewAndControl || detail.permission == WMDevicePermissionTypeOwner)
            && detail.online) {
            self.powerOnView.isOn = YES;
            self.ventilationView.isOn = YES;
            self.auxiliaryHeatView.isOn = YES;
            self.airSpeedView.isOn = YES;
            self.timingView.isOn = YES;
            if (!detail.powerOn) {
                self.ventilationView.isOn = NO;
                self.auxiliaryHeatView.isOn = NO;
                self.airSpeedView.isOn = NO;
            }
        } else {
            self.powerOnView.isOn = NO;
            self.ventilationView.isOn = NO;
            self.auxiliaryHeatView.isOn = NO;
            self.airSpeedView.isOn = NO;
            self.timingView.isOn = NO;
        }
        self.settingView.isOn = YES;
    } else if ([self.prodId intValue] == 1) {
        if ((detail.permission == WMDevicePermissionTypeViewAndControl || detail.permission == WMDevicePermissionTypeOwner)
            && detail.online) {
            self.powerOnView.isOn = YES;
        } else {
            self.powerOnView.isOn = NO;
        }
        self.ventilationView.isOn = NO;
        self.auxiliaryHeatView.isOn = NO;
        self.airSpeedView.isOn = NO;
        self.timingView.isOn = NO;
        self.settingView.isOn = YES;
    }
}

- (void)refreshTimingView:(WMDeviceDetail *)detail {
    self.deviceDetail.fanTiming = detail.fanTiming;
    if (detail.fanTiming) {
        self.timingView.name.text = @"开";
        self.timingView.status = 1;
    } else {
        self.timingView.name.text = @"关";
        self.timingView.status = 0;
    }
}

- (void)stopTimerIfNeeded {
    if (self.refreshTimer) {
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
}

#pragma mark - Target action
- (void)onRefreshTimerExpired {
    [self stopTimerIfNeeded];
    [self loadDeviceDetail];
}

#pragma mark - WMDeviceSwitchViewDelegate
- (void)viewDidTap:(WMDeviceSwitchViewTag)tag {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.deviceDetail.deviceId forKey:@"deviceID"];

    switch (tag) {
        case WMDeviceSwitchViewTagPowerOn: {
            BOOL powerOn = (self.powerOnView.status == 1);
            DeviceSetOperation *operation = [[DeviceSetOperation alloc] init];
            operation.deviceSetType = DeviceSetTypePowerOn;
            operation.deviceSetValue = @(!powerOn);
            __weak typeof(self) ws = self;
            [self setDeviceWithOperation:operation response:^(BOOL success) {
                if (success) {
                    if (ws.powerOnView.status == 1) {
                        ws.powerOnView.status = 0;
                        ws.powerOnView.name.text = @"关";
                    } else {
                        ws.powerOnView.status = 1;
                        ws.powerOnView.name.text = @"开";
                    }
                }
            }];
            break;
        }
        case WMDeviceSwitchViewTagVentilation: {
            WMDeviceVentilationSettingViewController *vc = [[WMDeviceVentilationSettingViewController alloc] init];
            vc.mode = self.deviceDetail.ventilationMode;
            vc.deviceDetail = self.deviceDetail;
            vc.delegate = self;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WMDeviceSwitchViewTagAuxiliaryHeat: {
            BOOL auxiliaryHeat = (self.auxiliaryHeatView.status == 1);
            DeviceSetOperation *operation = [[DeviceSetOperation alloc] init];
            operation.deviceSetType = DeviceSetTypeAuxiliary;
            operation.deviceSetValue = @(!auxiliaryHeat);
            __weak typeof(self) ws = self;
            [self setDeviceWithOperation:operation response:^(BOOL success) {
                if (success) {
                    if (ws.auxiliaryHeatView.status == 1) {
                        ws.auxiliaryHeatView.status = 0;
                        ws.auxiliaryHeatView.name.text = @"关";
                    } else {
                        ws.auxiliaryHeatView.status = 1;
                        ws.auxiliaryHeatView.name.text = @"开";
                    }
                }
            }];
            break;
        }
        case WMDeviceSwitchViewTagAirSpeed: {
            WMDeviceAirSpeedSettingViewController *vc = [[WMDeviceAirSpeedSettingViewController alloc] init];
            vc.speed = self.deviceDetail.airSpeed;
            vc.deviceDetail = self.deviceDetail;
            vc.delegage = self;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WMDeviceSwitchViewTagTiming: {
            WMDeviceTimeSettingViewController *vc = [[WMDeviceTimeSettingViewController alloc] init];
            vc.deviceDetail = self.deviceDetail;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
        case WMDeviceSwitchViewTagSetting: {
            WMDeviceSettingViewController *vc = [[WMDeviceSettingViewController alloc] init];
            vc.detail = self.deviceDetail;
            vc.prodId = self.prodId;
            [self.vc.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - WMDeviceVentilationSettingDelegate
- (void)onVentilationConfirm:(WMVentilationMode)mode {
    DeviceSetOperation *operation = [[DeviceSetOperation alloc] init];
    operation.deviceSetType = DeviceSetTypeVentilation;
    operation.deviceSetValue = @(mode);
    __weak typeof(self) ws = self;
    [self setDeviceWithOperation:operation response:^(BOOL success) {
        if (success) {
            [ws refreshVentilationMode:mode];
        }
    }];
}

#pragma mark - WMDeviceAirSpeedSettingDelegate
- (void)onAirSpeedConfirm:(WMAirSpeed)speed {
    DeviceSetOperation *operation = [[DeviceSetOperation alloc] init];
    operation.deviceSetType = DeviceSetTypeAirSpeed;
    operation.deviceSetValue = @(speed);
    __weak typeof(self) ws = self;
    [self setDeviceWithOperation:operation response:^(BOOL success) {
        if (success) {
            [ws refreshAirSpeed:speed];
        }
    }];
}

#pragma mark - Private method
- (void)refreshVentilationMode:(WMVentilationMode)mode {
    if (mode == WMVentilationModeLow) {
        self.ventilationView.name.text = @"低效";
    } else if (mode == WMVentilationModeOff) {
        self.ventilationView.name.text = @"关闭";
    } else if (mode == WMVentilationModeHigh) {
        self.ventilationView.name.text = @"高效";
    }
    self.deviceDetail.ventilationMode = mode;
    self.ventilationView.status = mode;
}

- (void)refreshAirSpeed:(WMAirSpeed)speed {
    switch (speed) {
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
    self.deviceDetail.airSpeed = speed;
    self.airSpeedView.status = speed;
}

- (void)setDeviceWithOperation:(DeviceSetOperation *)operation
                      response:(void (^)(BOOL success))responseBlock {
    self.deviceSetOperation = operation;
    if (self.isSetting) {
        [WMUIUtility showAlertWithMessage:@"控制忙，请稍候。" viewController:self.vc];
        if (responseBlock) {
            responseBlock(NO);
        }
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.deviceDetail.deviceId forKey:@"deviceID"];
        if (operation.deviceSetType == DeviceSetTypePowerOn) {
            [dic setObject:operation.deviceSetValue forKey:@"powerOn"];
        } else if (operation.deviceSetType == DeviceSetTypeVentilation) {
            [dic setObject:operation.deviceSetValue forKey:@"ventilationMode"];
        } else if (operation.deviceSetType == DeviceSetTypeAuxiliary) {
            [dic setObject:operation.deviceSetValue forKey:@"auxiliaryHeat"];
        } else if (operation.deviceSetType == DeviceSetTypeAirSpeed) {
            [dic setObject:operation.deviceSetValue forKey:@"airSpeed"];
        } else {
            NSLog(@"setDeviceWithOperation type error");
            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self.vc];
            if (responseBlock) {
                responseBlock(NO);
            }
            return;
        }
        self.isSetting = YES;
        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [WMDeviceUtility setDevice:dic
                          response:^(WMHTTPResult *result) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self.hud hideAnimated:YES];
                                  if (result.success) {
                                      self.refreshCount = 0;
                                      [self startRefreshTimer];
                                      if (responseBlock) {
                                          responseBlock(YES);
                                      }
                                  } else {
                                      NSLog(@"setDevice fail, result is %@", result);
                                      self.isSetting = NO;
                                      [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self.vc];
                                      if (responseBlock) {
                                          responseBlock(NO);
                                      }
                                  }
                              });
                          }];
    }
}

- (void)loadDeviceDetail {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.deviceDetail.deviceId forKey:@"deviceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryDetails"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSDictionary *content = result.content;
                                        WMDeviceDetail *detail = [WMDeviceDetail deviceDetailFromHTTPData:content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if ([self checkOperation:detail]) {
                                                self.isSetting = NO;
                                                [WMUIUtility showAlertWithMessage:@"控制成功" viewController:self.vc];
                                            } else {
                                                if (++self.refreshCount >= Refresh_Max_Count) {
                                                    self.isSetting = NO;
                                                    [WMUIUtility showAlertWithMessage:@"控制失败" viewController:self.vc];
                                                } else {
                                                    [self startRefreshTimer];
                                                }
                                            }
                                        });
                                    } else {
                                        NSLog(@"loadDeviceDetail error");
                                    }
                                }];
}

- (BOOL)checkOperation:(WMDeviceDetail *)detail {
    if (!self.isSetting) {
        return NO;
    }
    if (self.deviceSetOperation.deviceSetType == DeviceSetTypePowerOn) {
        if ([self.deviceSetOperation.deviceSetValue boolValue] == detail.powerOn) {
            return YES;
        }
    } else if (self.deviceSetOperation.deviceSetType == DeviceSetTypeVentilation) {
        if ([self.deviceSetOperation.deviceSetValue intValue] == detail.ventilationMode) {
            return YES;
        }
    } else if (self.deviceSetOperation.deviceSetType == DeviceSetTypeAuxiliary) {
        if ([self.deviceSetOperation.deviceSetValue boolValue] == detail.auxiliaryHeat) {
            return YES;
        }
    } else if (self.deviceSetOperation.deviceSetType == DeviceSetTypeAirSpeed) {
        if ([self.deviceSetOperation.deviceSetValue intValue] == detail.airSpeed) {
            return YES;
        }
    }
    return NO;
}

- (void)startRefreshTimer {
    if ([self.refreshTimer isValid]) {
        [self.refreshTimer invalidate];
    }
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:Refresh_Interval
                                                         target:self
                                                       selector:@selector(onRefreshTimerExpired)
                                                       userInfo:nil
                                                        repeats:NO];
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
        _timingView.name.text = @"关";
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
