//
//  WMDeviceDataView.m
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceDataView.h"
#import "WMUIUtility.h"

#define Label_Height    15

#define PM_X            10
#define PM_Y            20

#define CO2_X           138
#define CO2_Y           PM_Y

#define CH2O_X          260
#define CH2O_Y          PM_Y

#define TVOC_X          PM_X
#define TVOC_Y          57

#define Temp_X          CO2_X
#define Temp_Y          TVOC_Y

#define Humidity_X      CH2O_X
#define Humidity_Y      TVOC_Y

@implementation WMDeviceDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.PMLabel];
        [self addSubview:self.co2Label];
        [self addSubview:self.ch2oLabel];
        [self addSubview:self.tvocLabel];
        [self addSubview:self.tempLabel];
        [self addSubview:self.humidityLabel];
    }
    return self;
}

- (UILabel *)PMLabel {
    if (!_PMLabel) {
        _PMLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(PM_X, PM_Y, 100, Label_Height)];
        _PMLabel.text = @"PM2.5：";
        _PMLabel.font = [UIFont systemFontOfSize:Label_Height];
        _PMLabel.textColor = [WMUIUtility color:@"0x444444"];
        _PMLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _PMLabel;
}

- (UILabel *)co2Label {
    if (!_co2Label) {
        _co2Label = [[UILabel alloc] initWithFrame:WM_CGRectMake(CO2_X, CO2_Y, 100, Label_Height)];
        _co2Label.text = @"CO2：";
        _co2Label.font = [UIFont systemFontOfSize:Label_Height];
        _co2Label.textColor = [WMUIUtility color:@"0x444444"];
        _co2Label.textAlignment = NSTextAlignmentLeft;
    }
    return _co2Label;
}

- (UILabel *)ch2oLabel {
    if (!_ch2oLabel) {
        _ch2oLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(CH2O_X, CH2O_Y, 100, Label_Height)];
        _ch2oLabel.text = @"甲醛：";
        _ch2oLabel.font = [UIFont systemFontOfSize:Label_Height];
        _ch2oLabel.textColor = [WMUIUtility color:@"0x444444"];
        _ch2oLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _ch2oLabel;
}

- (UILabel *)tvocLabel {
    if (!_tvocLabel) {
        _tvocLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(TVOC_X, TVOC_Y, 100, Label_Height)];
        _tvocLabel.text = @"TVOC：";
        _tvocLabel.font = [UIFont systemFontOfSize:Label_Height];
        _tvocLabel.textColor = [WMUIUtility color:@"0x444444"];
        _tvocLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tvocLabel;
}

- (UILabel *)tempLabel {
    if (!_tempLabel) {
        _tempLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Temp_X, Temp_Y, 100, Label_Height)];
        _tempLabel.text = @"温度：";
        _tempLabel.font = [UIFont systemFontOfSize:Label_Height];
        _tempLabel.textColor = [WMUIUtility color:@"0x444444"];
        _tempLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tempLabel;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Humidity_X, Humidity_Y, 100, Label_Height)];
        _humidityLabel.text = @"湿度：";
        _humidityLabel.font = [UIFont systemFontOfSize:Label_Height];
        _humidityLabel.textColor = [WMUIUtility color:@"0x444444"];
        _humidityLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _humidityLabel;
}

@end
