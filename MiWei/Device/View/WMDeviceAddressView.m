//
//  WMDeviceAddressView.m
//  MiWei
//
//  Created by LiFei on 2018/7/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceAddressView.h"
#import "WMUIUtility.h"

#define Gap 10

@implementation WMDeviceAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, 14, 18)];
        _imageView.image = [UIImage imageNamed:@"device_location"];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:WM_CGRectMake(14 + Gap, 0, 200, 18)];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = [WMUIUtility color:@"0xffffff"];
    }
    return _label;
}

@end
