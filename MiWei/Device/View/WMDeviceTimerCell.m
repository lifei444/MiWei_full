//
//  WMDeviceTimerCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimerCell.h"
#import "WMDeviceTimer.h"
#import "WMUIUtility.h"
#import "MBProgressHUD.h"
#import "WMHTTPUtility.h"
#import "WMDeviceUtility.h"

#define Time_X          10
#define Time_Y          11
#define Time_Width      50
#define Time_Height     18

#define Repeat_X        65
#define Repeat_Y        14
#define Repeat_Width    290
#define Repeat_Height   14

#define Detail_X        Time_X
#define Detail_Y        45
#define Detail_Width    290
#define Detail_Height   Repeat_Height

#define Switch_X        305
#define Switch_Y        18
#define Switch_Width    45
#define Switch_Height   20

@interface WMDeviceTimerCell()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) WMDeviceTimer *timer;
@end

@implementation WMDeviceTimerCell
#pragma mark - Life cycle
- (void)loadSubViews {
    self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.repeatLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.switchView];
}

- (void)setDataModel:(id)model {
    WMDeviceTimer *timer = model;
    self.timer = timer;
    
    self.switchView.on = timer.enable;
    if (self.totalOff) {
        self.switchView.hidden = YES;
    } else {
        self.switchView.hidden = NO;
    }
    [self refreshLabelColor:timer.enable];
    [self refreshTimeLabel:timer];
    [self refreshRepeatLabel:timer];
    [self refreshDetailLabel:timer];
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:70];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.switchView.hidden = YES;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!self.totalOff) {
            self.switchView.hidden = NO;
        }
    }
}

#pragma mark - Target action
- (void)onSwitch {
    [self refreshLabelColor:self.switchView.isOn];
    
    if (self.timer) {
        self.timer.enable = self.switchView.isOn;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.timer.timerId forKey:@"id"];
        [dic setObject:@(self.switchView.isOn) forKey:@"enable"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.vc.view animated:YES];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"mobile/timing/edit"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                            } else {
                                                [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self.vc];
                                                [self.switchView setOn:!self.switchView.isOn];
                                            }
                                        });
                                    }];
    }
}

#pragma mark - Private method
- (void)refreshLabelColor:(BOOL)enable {
    if (self.totalOff || !enable) {
        self.timeLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        self.repeatLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        self.detailLabel.textColor = [WMUIUtility color:@"0xcacaca"];
    } else {
        self.timeLabel.textColor = [WMUIUtility color:@"0x444444"];
        self.repeatLabel.textColor = [WMUIUtility color:@"0x666666"];
        self.detailLabel.textColor = [WMUIUtility color:@"0x666666"];
    }
}

- (void)refreshTimeLabel:(WMDeviceTimer *)timer {
    int hour = [timer.startTime intValue] / 60;
    int minute = [timer.startTime intValue] % 60;
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
    self.timeLabel.text = timeString;
}

- (void)refreshRepeatLabel:(WMDeviceTimer *)timer {
    self.repeatLabel.text = [NSString stringWithFormat:@"(%@)", [WMDeviceUtility generateWeekDayString:timer.repetition]];
}

- (void)refreshDetailLabel:(WMDeviceTimer *)timer {
    NSString *detailString = @"";
    if (timer.powerOn) {
        switch (timer.airSpeed) {
            case WMAirSpeedAuto:
                detailString = [detailString stringByAppendingString:@"自动、"];
                break;
            case WMAirSpeedSilent:
                detailString = [detailString stringByAppendingString:@"静音、"];
                break;
            case WMAirSpeedComfort:
                detailString = [detailString stringByAppendingString:@"舒适、"];
                break;
            case WMAirSpeedStandard:
                detailString = [detailString stringByAppendingString:@"标准、"];
                break;
            case WMAirSpeedStrong:
                detailString = [detailString stringByAppendingString:@"强力、"];
                break;
            case WMAirSpeedHurricane:
                detailString = [detailString stringByAppendingString:@"飓风、"];
                break;
            default:
                break;
        }
    } else {
        detailString = [detailString stringByAppendingString:@"关机、"];
    }
    if (timer.auxiliaryHeat) {
        detailString = [detailString stringByAppendingString:@"辅热开、"];
    } else {
        detailString = [detailString stringByAppendingString:@"辅热关、"];
    }
    switch (timer.ventilationMode) {
        case WMVentilationModeLow:
            detailString = [detailString stringByAppendingString:@"新风低效、"];
            break;
        case WMVentilationModeOff:
            detailString = [detailString stringByAppendingString:@"新风关、"];
            break;
        case WMVentilationModeHigh:
            detailString = [detailString stringByAppendingString:@"新风高效、"];
            break;
        default:
            break;
    }
    if (timer.powerOn) {
        detailString = [detailString stringByAppendingString:@"开机"];
    } else {
        detailString = [detailString stringByAppendingString:@"关机"];
    }
    self.detailLabel.text = detailString;
}

#pragma mark - Getters & setters
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Time_X, Time_Y, Time_Width, Time_Height)];
        if (self.switchView.isOn) {
            _timeLabel.textColor = [WMUIUtility color:@"0x444444"];
        } else {
            _timeLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        }
        _timeLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Time_Height]];
    }
    return _timeLabel;
}

- (UILabel *)repeatLabel {
    if (!_repeatLabel) {
        _repeatLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Repeat_X, Repeat_Y, Repeat_Width, Repeat_Height)];
        if (self.switchView.isOn) {
            _repeatLabel.textColor = [WMUIUtility color:@"0x666666"];
        } else {
            _repeatLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        }
        _repeatLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Repeat_Height]];
    }
    return _repeatLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Detail_X, Detail_Y, Detail_Width, Detail_Height)];
        if (self.switchView.isOn) {
            _detailLabel.textColor = [WMUIUtility color:@"0x666666"];
        } else {
            _detailLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        }
        _detailLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Detail_Height]];
    }
    return _detailLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] initWithFrame:WM_CGRectMake(Switch_X, Switch_Y, Switch_Width, Switch_Height)];
        _switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [_switchView addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
@end
