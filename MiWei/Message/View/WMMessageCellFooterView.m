//
//  WMMessageCellFooterView.m
//  MiWei
//
//  Created by LiFei on 2018/8/9.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageCellFooterView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

#define Separator_Width     325
#define Separator_X         ((345 - Separator_Width)/2)

@interface WMMessageCellFooterView ()
@property (nonatomic, strong) UIView *separator;
@end

@implementation WMMessageCellFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.separator];
        [self addSubview:self.label];
    }
    return self;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:WM_CGRectMake(Separator_X, 0, Separator_Width, 1)];
        _separator.backgroundColor = [WMUIUtility color:@"0xebebeb"];
    }
    return _separator;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:WM_CGRectMake(15, 1, 300, self.frame.size.height-1)];
        _label.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
        _label.textColor = [WMUIUtility color:@"0x222222"];
    }
    return _label;
}

@end
