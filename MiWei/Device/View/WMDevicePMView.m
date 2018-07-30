//
//  WMDevicePMView.m
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePMView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

#define Circle_X                66
#define Circle_Width            242
#define Circle_Height           201

#define InnerLabel_X            96
#define InnerLabel_Y            94//70  //94
#define InnerLabel_Height       16

#define InnerPMValue_Y          61//40  //61
#define InnerPMValue_Height     46

#define OutLabel_X              238
#define OutLabel_Y              138//115  //138
#define OutLabel_Height         16

#define OutPMValue_Y            130//110  //130
#define OutPMValue_Height       46

#define PMLabel_Y               180  //218
#define PMLabel_Height          16

@implementation WMDevicePMView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.circleImageView];
        [self addSubview:self.innerLabel];
        [self addSubview:self.innerPMValueLabel];
        [self addSubview:self.outLabel];
        [self addSubview:self.outPMVauleLabel];
        [self addSubview:self.pmLabel];
    }
    return self;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Circle_X, 0, Circle_Width, Circle_Height)];
        _circleImageView.image = [UIImage imageNamed:@"device_pm_circle"];
    }
    return _circleImageView;
}

- (UILabel *)innerLabel {
    if (!_innerLabel) {
        _innerLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(InnerLabel_X, InnerLabel_Y, 50, InnerLabel_Height)];
        _innerLabel.text = @"室内";
        _innerLabel.font = [UIFont systemFontOfSize:16];
        _innerLabel.textColor = [WMUIUtility color:@"0xffffff"];
    }
    return _innerLabel;
}

- (UILabel *)innerPMValueLabel {
    if (!_innerPMValueLabel) {
        _innerPMValueLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, InnerPMValue_Y, Screen_Width, InnerPMValue_Height)];
        _innerPMValueLabel.font = [UIFont systemFontOfSize:60];
        _innerPMValueLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _innerPMValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _innerPMValueLabel;
}

- (UILabel *)outLabel {
    if (!_outLabel) {
        _outLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(OutLabel_X, OutLabel_Y, 50, OutLabel_Height)];
        _outLabel.text = @"室外";
        _outLabel.font = [UIFont systemFontOfSize:16];
        _outLabel.textColor = [WMUIUtility color:@"0xffffff"];
    }
    return _outLabel;
}

- (UILabel *)outPMVauleLabel {
    if (!_outPMVauleLabel) {
        _outPMVauleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, OutPMValue_Y, Screen_Width, OutPMValue_Height)];
        _outPMVauleLabel.font = [UIFont systemFontOfSize:60];
        _outPMVauleLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _outPMVauleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _outPMVauleLabel;
}

- (UILabel *)pmLabel {
    if (!_pmLabel) {
        _pmLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, PMLabel_Y, Screen_Width, PMLabel_Height)];
        _pmLabel.text = @"pm2.5";
        _pmLabel.font = [UIFont systemFontOfSize:16];
        _pmLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _pmLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pmLabel;
}
@end
