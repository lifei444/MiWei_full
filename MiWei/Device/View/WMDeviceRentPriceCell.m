//
//  WMDeviceRentPriceCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/20.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceRentPriceCell.h"
#import "WMUIUtility.h"
#import "WMDeviceRentPrice.h"
#import "WMDeviceUtility.h"

@interface WMDeviceRentPriceCell ()
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation WMDeviceRentPriceCell
#pragma mark - Life cycle
- (void)loadSubViews {
    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.priceLabel];
}

- (void)setDataModel:(id)model {
    WMDeviceRentPrice *price = model;
    self.priceLabel.text = [WMDeviceUtility generatePriceStringFromPrice:price.price andRentTime:price.time];
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:59];
}

#pragma mark - Public method
- (void)refreshSelectState:(BOOL)isSelected {
    if (isSelected) {
        self.selectImageView.image = [UIImage imageNamed:@"dev_pay_select_selected"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"dev_pay_select_normal"];
    }
}

#pragma mark - Getters & setters
- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(10, 20, 17, 17)];
        _selectImageView.image = [UIImage imageNamed:@"dev_pay_select_normal"];
    }
    return _selectImageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(50, 0, 200, 59)];
    }
    return _priceLabel;
}
@end
