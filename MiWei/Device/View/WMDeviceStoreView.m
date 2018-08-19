//
//  WMDeviceStoreView.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceStoreView.h"
#import "WMDeviceStoreItem.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

#define Store_X         16
#define Item_Width      75
#define Item_Height     28
#define Pay_X           (Screen_Width - Store_X - Item_Width)

@interface WMDeviceStoreView ()
@property (nonatomic, strong) WMDeviceStoreItem *storeItem;
@property (nonatomic, strong) WMDeviceStoreItem *payItem;
@end

@implementation WMDeviceStoreView
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.storeItem];
        [self addSubview:self.remainingTimeLabel];
        [self addSubview:self.payItem];
    }
    return self;
}

#pragma mark - Getters & setters
- (WMDeviceStoreItem *)storeItem {
    if (!_storeItem) {
        _storeItem = [[WMDeviceStoreItem alloc] initWithFrame:WM_CGRectMake(Store_X, 0, Item_Width, Item_Height)];
        _storeItem.label.text = @"商城";
        _storeItem.imageView.image = [UIImage imageNamed:@"device_store"];
    }
    return _storeItem;
}

- (UILabel *)remainingTimeLabel {
    if (!_remainingTimeLabel) {
        _remainingTimeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Item_Height)];
        _remainingTimeLabel.textAlignment = NSTextAlignmentCenter;
        _remainingTimeLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _remainingTimeLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
    }
    return _remainingTimeLabel;
}

- (WMDeviceStoreItem *)payItem {
    if (!_payItem) {
        _payItem = [[WMDeviceStoreItem alloc] initWithFrame:WM_CGRectMake(Pay_X, 0, Item_Width, Item_Height)];
        _payItem.label.text = @"续费";
        _payItem.imageView.image = [UIImage imageNamed:@"device_pay"];
    }
    return _payItem;
}

@end
