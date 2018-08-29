//
//  WMAirQualityNotiMessageCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/6.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMAirQualityNotiMessageCell.h"
#import "WMUIUtility.h"
#import "WMAirQualityNotiMessage.h"

#define BG_Width            126
#define BG_Height           89
#define BG_X                (MessageCell_Width - BG_Width) / 2
#define BG_Y                63

#define PM25Value_Y         96
#define PM25Value_Height    50

#define PM25Name_Y          144
#define PM25Name_Height     14

#define Description_Y       181
#define Description_Height  15

@interface WMAirQualityNotiMessageCell ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *pm25ValueLabel;
@property (nonatomic, strong) UILabel *pm25NameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation WMAirQualityNotiMessageCell
- (void)loadSubViews {
    [super loadSubViews];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.pm25ValueLabel];
    [self.contentView addSubview:self.pm25NameLabel];
    [self.contentView addSubview:self.descriptionLabel];
}

- (void)setDataModel:(id)model {
    WMAirQualityNotiMessage *message = model;
    self.titleLabel.text = @"空气污染提醒";
    int v = 0;
    
    switch (message.paramFlag) {
        case WMAirQualityNotiFlagCh2o:
            self.pm25NameLabel.text = @"甲醛";
            v = [message.ch2o intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        case WMAirQualityNotiFlagPm25:
            self.pm25NameLabel.text = @"PM2.5";
            v = [message.pm25 intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        case WMAirQualityNotiFlagHumidity:
            self.pm25NameLabel.text = @"湿度";
            v = [message.humidity intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        case WMAirQualityNotiFlagTvoc:
            self.pm25NameLabel.text = @"TVOC";
            v = [message.tvoc intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        case WMAirQualityNotiFlagTemp:
            self.pm25NameLabel.text = @"温度";
            v = [message.temp intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        case WMAirQualityNotiFlagCo2:
            self.pm25NameLabel.text = @"CO2";
            v = [message.co2 intValue];
            self.pm25ValueLabel.text = [NSString stringWithFormat:@"%d", v];
            break;
            
        default:
            break;
    }
    
    self.descriptionLabel.text = message.message;
    self.footerView.label.text = [self timeStringWithTimestamp:message.time];
    switch (message.aqLevel) {
        case WMAqLevelGreen:
            self.bgView.image = [UIImage imageNamed:@"message_bg_green"];
            self.pm25ValueLabel.textColor = [WMUIUtility color:@"0x1dbc43"];
            self.pm25NameLabel.textColor = [WMUIUtility color:@"0x1dbc43"];
            break;
            
        case WMAqLevelBlue:
            self.bgView.image = [UIImage imageNamed:@"message_bg_blue"];
            self.pm25ValueLabel.textColor = [WMUIUtility color:@"0x5b81d0"];
            self.pm25NameLabel.textColor = [WMUIUtility color:@"0x5b81d0"];
            break;
            
        case WMAqLevelYellow:
            self.bgView.image = [UIImage imageNamed:@"message_bg_yellow"];
            self.pm25ValueLabel.textColor = [WMUIUtility color:@"0xf4d53f"];
            self.pm25NameLabel.textColor = [WMUIUtility color:@"0xf4d53f"];
            break;
            
        case WMAqLevelRed:
            self.bgView.image = [UIImage imageNamed:@"message_bg_red"];
            self.pm25ValueLabel.textColor = [WMUIUtility color:@"0xda3232"];
            self.pm25NameLabel.textColor = [WMUIUtility color:@"0xda3232"];
            break;
            
        default:
            break;
    }
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:280];
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(BG_X, BG_Y, BG_Width, BG_Height)];
    }
    return _bgView;
}

- (UILabel *)pm25ValueLabel {
    if (!_pm25ValueLabel) {
        _pm25ValueLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, PM25Value_Y, MessageCell_Width, PM25Value_Height)];
        _pm25ValueLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:PM25Value_Height]];
        _pm25ValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pm25ValueLabel;
}

- (UILabel *)pm25NameLabel {
    if (!_pm25NameLabel) {
        _pm25NameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, PM25Name_Y, MessageCell_Width, PM25Name_Height)];
        _pm25NameLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:PM25Name_Height]];
        _pm25NameLabel.text = @"PM2.5";
        _pm25NameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pm25NameLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Description_Y, MessageCell_Width, Description_Height)];
        _descriptionLabel.textColor = [WMUIUtility color:@"0x222222"];
        _descriptionLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Description_Height]];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel;
}

@end
