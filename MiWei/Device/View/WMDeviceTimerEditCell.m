//
//  WMDeviceTimerEditCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimerEditCell.h"
#import "MBProgressHUD.h"
#import "WMDeviceTimer.h"
#import "WMUIUtility.h"

#define Delete_X        10
#define Delete_Y        25
#define Delete_Width    20
#define Delete_Height   20

#define Time_X          40
#define Time_Y          11
#define Time_Width      50
#define Time_Height     18

#define Repeat_X        95
#define Repeat_Y        14
#define Repeat_Width    290
#define Repeat_Height   14

#define Detail_X        Time_X
#define Detail_Y        45
#define Detail_Width    290
#define Detail_Height   Repeat_Height

//#define Switch_X        305
//#define Switch_Y        18
//#define Switch_Width    45
//#define Switch_Height   20

@interface WMDeviceTimerEditCell ()
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *repeatDays;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) WMDeviceTimer *timer;
@end

@implementation WMDeviceTimerEditCell
#pragma mark - Life cycle
- (void)loadSubViews {
    [self addSubview:self.deleteButton];
    [self addSubview:self.timeLabel];
    [self addSubview:self.repeatLabel];
    [self addSubview:self.detailLabel];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setDataModel:(id)model {
    WMDeviceTimer *timer = model;
    self.timer = timer;
    
    [self refreshLabelColor:timer.enable];
    [self refreshTimeLabel:timer];
    [self refreshRepeatLabel:timer];
    [self refreshDetailLabel:timer];
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:70];
}

#pragma mark - Target action
- (void)onDelete {
    
}

#pragma mark - Private method
- (void)refreshLabelColor:(BOOL)enable {
    if (enable) {
        self.timeLabel.textColor = [WMUIUtility color:@"0x444444"];
        self.repeatLabel.textColor = [WMUIUtility color:@"0x666666"];
        self.detailLabel.textColor = [WMUIUtility color:@"0x666666"];
    } else {
        self.timeLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        self.repeatLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        self.detailLabel.textColor = [WMUIUtility color:@"0xcacaca"];
    }
}

- (void)refreshTimeLabel:(WMDeviceTimer *)timer {
    int hour = [timer.startTime intValue] / 60;
    int minute = [timer.startTime intValue] % 60;
    NSString *timeString = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
    self.timeLabel.text = timeString;
}

- (void)refreshRepeatLabel:(WMDeviceTimer *)timer {
    NSString *repeatString = @"(";
    int repeatValue = [timer.repetition intValue];
    if (repeatValue == 0) {
        repeatString = @"(永不)";
    } else if ((repeatValue & 0x7f) == 0x7f) {
        repeatString = @"(每天)";
    } else {
        int bit = 0x01;
        NSArray *weekDay = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        for (int i = 0; i < 7; i++) {
            if ((bit & repeatValue) != 0) {
                repeatString = [repeatString stringByAppendingString:[NSString stringWithFormat:@"%@ ", weekDay[i]]];
                [self.repeatDays addObject:@(i)];
            }
            bit = 0x01 << (i + 1);
        }
        repeatString = [repeatString substringToIndex:(repeatString.length-1)];
        repeatString = [repeatString stringByAppendingString:@")"];
    }
    self.repeatLabel.text = repeatString;
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
            detailString = [detailString stringByAppendingString:@"新风低效"];
            break;
        case WMVentilationModeOff:
            detailString = [detailString stringByAppendingString:@"新风关"];
            break;
        case WMVentilationModeHigh:
            detailString = [detailString stringByAppendingString:@"新风高效"];
            break;
        default:
            break;
    }
    self.detailLabel.text = detailString;
}

#pragma mark - Getters & setters
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Delete_X, Delete_Y, Delete_Width, Delete_Height)];
        [_deleteButton setImage:[UIImage imageNamed:@"device_time_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Time_X, Time_Y, Time_Width, Time_Height)];
        if (self.timer.enable) {
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
        if (self.timer.enable) {
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
        if (self.timer.enable) {
            _detailLabel.textColor = [WMUIUtility color:@"0x666666"];
        } else {
            _detailLabel.textColor = [WMUIUtility color:@"0xcacaca"];
        }
        _detailLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Detail_Height]];
    }
    return _detailLabel;
}

- (NSMutableArray<NSNumber *> *)repeatDays {
    if (!_repeatDays) {
        _repeatDays = [[NSMutableArray alloc] init];
    }
    return _repeatDays;
}

@end
