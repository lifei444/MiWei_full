//
//  WMDevicePayBGView.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePayBGView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@implementation WMDevicePayBGView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [WMUIUtility color:@"0x1d818c"];
        [self addSubview:self.lastUseLabel];
        [self addSubview:self.pmView];
        [self addSubview:self.totalLabel];
    }
    return self;
}

- (UILabel *)lastUseLabel {
    if (!_lastUseLabel) {
        _lastUseLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 15, Screen_Width, 14)];
        _lastUseLabel.textAlignment = NSTextAlignmentCenter;
        _lastUseLabel.textColor = [WMUIUtility color:@"0xffffff"];
    }
    return _lastUseLabel;
}

- (WMDevicePMView *)pmView {
    if (!_pmView) {
        _pmView = [[WMDevicePMView alloc] initWithFrame:WM_CGRectMake(0, 60, Screen_Width, 201)];
    }
    return _pmView;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 300, Screen_Width, 50)];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _totalLabel.numberOfLines = 2;
    }
    return _totalLabel;
}
@end
