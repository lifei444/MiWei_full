//
//  WMOrderListCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/15.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMOrderListCell.h"
#import "WMUIUtility.h"

#define Name_X          24
#define Name_Y          22
#define Name_Width      180
#define Name_Height     16

#define PayTime_X       Name_X
#define PayTime_Y       (Name_Y + Name_Height + 14)
#define PayTime_Width   180
#define PayTime_Height  15

#define Price_X         173
#define Price_Y         Name_Y
#define Price_Width     180
#define Price_Height    Name_Height

#define RentTime_X      173
#define RentTime_Y      PayTime_Y
#define RentTime_Width  180
#define RentTime_Height 14


@interface WMOrderListCell()
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *payTimeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *rentTimeLabel;
@end

@implementation WMOrderListCell
#pragma mark - Life cycle
- (void)loadSubViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.payTimeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.rentTimeLabel];
}

- (void)setDataModel:(id)model {
    WMPayment *payment = model;
    self.nameLabel.text = payment.deviceName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[payment.payTime longLongValue] / 1000];
    self.payTimeLabel.text = [self.formatter stringFromDate:date];
    
    int yuan = [payment.price intValue] / 100;
    int fen = [payment.price intValue] % 100;
    NSString *priceString = [NSString stringWithFormat:@"%d.%02d元/%@小时", yuan, fen, payment.rentTime];
    self.priceLabel.text = priceString;
    self.rentTimeLabel.text = @"01:20:09";
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:85];
}

#pragma mark - Getters & setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Name_X, Name_Y, Name_Width, Name_Height)];
        _nameLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Name_Height]];
        _nameLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _nameLabel;
}

- (UILabel *)payTimeLabel {
    if (!_payTimeLabel) {
        _payTimeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(PayTime_X, PayTime_Y, PayTime_Width, PayTime_Height)];
        _payTimeLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:PayTime_Height]];
        _payTimeLabel.textColor = [WMUIUtility color:@"0x999999"];
    }
    return _payTimeLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Price_X, Price_Y, Price_Width, Price_Height)];
        _priceLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Price_Height]];
        _priceLabel.textColor = [WMUIUtility color:@"0x444444"];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)rentTimeLabel {
    if (!_rentTimeLabel) {
        _rentTimeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(RentTime_X, RentTime_Y, RentTime_Width, RentTime_Height)];
        _rentTimeLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:RentTime_Height]];
        _rentTimeLabel.textColor = [WMUIUtility color:@"0x23938b"];
        _rentTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rentTimeLabel;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}
@end
