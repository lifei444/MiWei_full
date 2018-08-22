//
//  WMDeviceEchartHeadView.m
//  MiWei
//
//  Created by LiFei on 2018/7/29.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceEchartHeadView.h"
#import "WMUIUtility.h"

#define Title_X             10
#define Title_Y             16
#define Title_Width         100
#define Title_Height        15

#define Day_X               133
#define Week_X              182
#define Month_X             233
#define Year_X              284

#define Label_Y             16
#define Label_Width         45
#define Label_Height        20

NSString *const WMDeviceEchartHeadViewSelectNotification = @"WMDeviceEchartHeadViewSelectNotification";

@interface WMDeviceEchartHeadView ()
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, assign) WMDeviceEchartHeadSelectLabel selectLabel;
@end

@implementation WMDeviceEchartHeadView
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.yearLabel];
        self.selectLabel = WMDeviceEchartHeadSelectDay;
    }
    return self;
}

#pragma mark - Target action
- (void)daySelect {
    self.selectLabel = WMDeviceEchartHeadSelectDay;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(self.from), @"from", @(WMDeviceEchartHeadSelectDay), @"select", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceEchartHeadViewSelectNotification object:nil userInfo:dic];
}

- (void)weekSelect {
    self.selectLabel = WMDeviceEchartHeadSelectWeek;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(self.from), @"from", @(WMDeviceEchartHeadSelectWeek), @"select", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceEchartHeadViewSelectNotification object:nil userInfo:dic];
}

- (void)monthSelect {
    self.selectLabel = WMDeviceEchartHeadSelectMonth;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(self.from), @"from", @(WMDeviceEchartHeadSelectMonth), @"select", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceEchartHeadViewSelectNotification object:nil userInfo:dic];
}

- (void)yearSelect {
    self.selectLabel = WMDeviceEchartHeadSelectYear;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(self.from), @"from", @(WMDeviceEchartHeadSelectYear), @"select", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceEchartHeadViewSelectNotification object:nil userInfo:dic];
}

#pragma mark - Getters & setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Title_X, Title_Y, Title_Width, Title_Height)];
        _titleLabel.textColor = [WMUIUtility color:@"0x444444"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [self labelWithX:Day_X];
        _dayLabel.text = @"日";
        _dayLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daySelect)];
        [_dayLabel addGestureRecognizer:tapRecognizer];
    }
    return _dayLabel;
}

- (UILabel *)weekLabel {
    if (!_weekLabel) {
        _weekLabel = [self labelWithX:Week_X];
        _weekLabel.text = @"周";
        _weekLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weekSelect)];
        [_weekLabel addGestureRecognizer:tapRecognizer];
    }
    return _weekLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel =  [self labelWithX:Month_X];
        _monthLabel.text = @"月";
        _monthLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monthSelect)];
        [_monthLabel addGestureRecognizer:tapRecognizer];
    }
    return _monthLabel;
}

- (UILabel *)yearLabel {
    if (!_yearLabel) {
        _yearLabel = [self labelWithX:Year_X];
        _yearLabel.text = @"年";
        _yearLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yearSelect)];
        [_yearLabel addGestureRecognizer:tapRecognizer];
    }
    return _yearLabel;
}

- (void)setSelectLabel:(WMDeviceEchartHeadSelectLabel)selectLabel {
    UILabel *label1, *label2;
    switch (self.selectLabel) {
        case WMDeviceEchartHeadSelectDay:
            label1 = self.dayLabel;
            break;
            
        case WMDeviceEchartHeadSelectWeek:
            label1 = self.weekLabel;
            break;
            
        case WMDeviceEchartHeadSelectMonth:
            label1 = self.monthLabel;
            break;
            
        case WMDeviceEchartHeadSelectYear:
            label1 = self.yearLabel;
            break;
            
        default:
            break;
    }
    [self labelUnselect:label1];
    switch (selectLabel) {
        case WMDeviceEchartHeadSelectDay:
            label2 = self.dayLabel;
            break;
            
        case WMDeviceEchartHeadSelectWeek:
            label2 = self.weekLabel;
            break;
            
        case WMDeviceEchartHeadSelectMonth:
            label2 = self.monthLabel;
            break;
            
        case WMDeviceEchartHeadSelectYear:
            label2 = self.yearLabel;
            break;
            
        default:
            break;
    }
    [self labelSelect:label2];
    _selectLabel = selectLabel;
}

#pragma mark - Private methods
- (UILabel *)labelWithX:(CGFloat)x {
    UILabel *label = [[UILabel alloc] initWithFrame:WM_CGRectMake(x, Label_Y, Label_Width, Label_Height)];
    label.layer.borderColor = (__bridge CGColorRef _Nullable)([WMUIUtility color:@"0xf6fafd"]);
    label.layer.borderWidth = 1;
    label.backgroundColor = [WMUIUtility color:@"0xdfeff8"];
    label.textColor = [WMUIUtility color:@"0xb1c1ca"];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)labelSelect:(UILabel *)label {
    label.layer.borderColor = (__bridge CGColorRef _Nullable)([WMUIUtility color:@"0x12938a"]);
    label.backgroundColor = [WMUIUtility color:@"0x0e837b"];
    label.textColor = [WMUIUtility color:@"0xffffff"];
}

- (void)labelUnselect:(UILabel *)label {
    label.layer.borderColor = (__bridge CGColorRef _Nullable)([WMUIUtility color:@"0xf6fafd"]);
    label.backgroundColor = [WMUIUtility color:@"0xdfeff8"];
    label.textColor = [WMUIUtility color:@"0xb1c1ca"];
}

@end
