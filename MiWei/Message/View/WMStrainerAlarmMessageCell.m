//
//  WMStrainerAlartMessageCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/6.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMStrainerAlarmMessageCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMStrainerAlarmMessage.h"
#import "WMDeviceUtility.h"

#define Alarm_X             140
#define Alarm_Y             80
#define Alarm_Width         16
#define Alarm_Height        16

#define FirstName_X         (Alarm_X + Alarm_Width + 7)
#define FirstName_Y         Alarm_Y
#define FirstName_Width     300
#define FirstName_Height    Alarm_Height

#define FirstTime_Y         (Alarm_Y + Alarm_Height + 20)
#define FirstTime_Height    24

#define Second_X            15
#define Second_Y            (FirstTime_Y + FirstTime_Height + 57)
#define Second_Width        150
#define Second_Height       15

#define Third_X             207
#define Third_Y             Second_Y
#define Third_Width         150
#define Third_Height        Second_Height

@interface WMStrainerAlarmMessageCell()
@property (nonatomic, strong) UIImageView *alarmImageView;
@property (nonatomic, strong) UILabel *firstNameLabel;
@property (nonatomic, strong) UILabel *firstTimeLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@end

@implementation WMStrainerAlarmMessageCell
#pragma mark - Life cycle
- (void)loadSubViews {
    [super loadSubViews];
    [self.contentView addSubview:self.alarmImageView];
    [self.contentView addSubview:self.firstNameLabel];
    [self.contentView addSubview:self.firstTimeLabel];
    [self.contentView addSubview:self.secondLabel];
    [self.contentView addSubview:self.thirdLabel];
}

- (void)setDataModel:(id)model {
    WMStrainerAlarmMessage *message = model;
    self.titleLabel.text = @"滤网报警提醒";
    if (message.strainerStatus[0]) {
        self.firstNameLabel.text = message.strainerStatus[0].name;
        self.firstTimeLabel.text = [WMDeviceUtility timeStringFromSecond:message.strainerStatus[0].reaminingTime];
    }
    if (message.strainerStatus[1]) {
        self.secondLabel.text = [NSString stringWithFormat:@"%@: %@", message.strainerStatus[1].name, [WMDeviceUtility timeStringFromSecond:message.strainerStatus[1].reaminingTime]];
    }
    if (message.strainerStatus[2]) {
        self.thirdLabel.text = [NSString stringWithFormat:@"%@: %@", message.strainerStatus[2].name, [WMDeviceUtility timeStringFromSecond:message.strainerStatus[2].reaminingTime]];
    }
    self.footerView.label.text = [self timeStringWithTimestamp:message.time];
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:269];
}

#pragma mark - Getters & setters
- (UIImageView *)alarmImageView {
    if (!_alarmImageView) {
        _alarmImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Alarm_X, Alarm_Y, Alarm_Width, Alarm_Height)];
        _alarmImageView.image = [UIImage imageNamed:@"message_alarm"];
    }
    return _alarmImageView;
}

- (UILabel *)firstNameLabel {
    if (!_firstNameLabel) {
        _firstNameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(FirstName_X, FirstName_Y, FirstName_Width, FirstName_Height)];
        _firstNameLabel.textColor = [WMUIUtility color:@"0x666666"];
        _firstNameLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
    }
    return _firstNameLabel;
}

- (UILabel *)firstTimeLabel {
    if (!_firstTimeLabel) {
        _firstTimeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, FirstTime_Y, MessageCell_Width, FirstTime_Height)];
        _firstTimeLabel.textColor = [WMUIUtility color:@"0x222222"];
        _firstTimeLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:24]];
        _firstTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstTimeLabel;
}

- (UILabel *)secondLabel {
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Second_X, Second_Y, Second_Width, Second_Height)];
        _secondLabel.textColor = [WMUIUtility color:@"0x222222"];
        _secondLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
    }
    return _secondLabel;
}

- (UILabel *)thirdLabel {
    if (!_thirdLabel) {
        _thirdLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Third_X, Third_Y, Third_Width, Third_Height)];
        _thirdLabel.textColor = [WMUIUtility color:@"0x222222"];
        _thirdLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
    }
    return _thirdLabel;
}

@end
