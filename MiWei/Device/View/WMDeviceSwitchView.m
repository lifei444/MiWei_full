//
//  WMDeviceSwitchView.m
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceSwitchView.h"
#import "WMUIUtility.h"

@implementation WMDeviceSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        [self addSubview:self.name];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.isOn) {
        [[WMUIUtility color:@"0x168591"] set];
    } else {
        [[WMUIUtility color:@"0xaeaeae"] set];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:WM_CGRectMake(1, 1, 58, 58) cornerRadius:200];
    [path stroke];
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 60, 60)];
        _name.font = [UIFont systemFontOfSize:16];
        if (self.isOn) {
            _name.textColor = [WMUIUtility color:@"0x168591"];
        } else {
            _name.textColor = [WMUIUtility color:@"0xaeaeae"];
        }
        _name.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}

@end
