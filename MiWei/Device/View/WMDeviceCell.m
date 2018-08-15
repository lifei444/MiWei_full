//
//  WMDeviceCell.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceCell.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

#define Cell_width                  176

#define IconGap                     5
#define IconWidth                   166
#define IconHeight                  135

#define NameX                       8
#define GapYBetweenIconAndName      15
#define NameY                       (IconGap + IconHeight + GapYBetweenIconAndName)
#define NameHeight                  15

#define TypeX                       8
#define GapYBetweenNameAndType      8
#define TypeY                       (NameY + NameHeight + GapYBetweenNameAndType)
#define TypeHeight                  13

#define TimeX                       8
#define GapYBetweenTypeAndTime      22
#define TimeY                       (TypeY + TypeHeight + GapYBetweenTypeAndTime)
#define TimeHeight                  14

#define ResultX                     TimeX
#define ResultY                     TimeY
#define ResultHeight                TimeHeight

#define PriceY                      TimeY
#define PriceRightGap               8
#define PriceHeight                 TimeHeight

#define AuthorityY                  TimeY
#define AuthorityRightGap           PriceRightGap
#define AuthorityHeight             TimeHeight

#define ApplyAuthorityWidth         99
#define ApplyAuthorityHeight        22
#define ApplyAuthorityRightGap      PriceRightGap
#define ApplyAuthorityX             (Cell_width - ApplyAuthorityRightGap - ApplyAuthorityWidth)
#define ApplyAuthorityY             (AuthorityY - 4)

@interface WMDeviceCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;//租赁设备/在线/离线

//timeLable 和 resultLabel 在同一个地方出现，它们互斥，用同一个接口控制
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *resultLabel;//已结束

//priceLabel，authorityLabel 和 applyAuthorityLable 在同一个地方出现，它们互斥，用同一个接口控制
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *authorityLabel;//权限
@property (nonatomic, strong) UILabel *applyAuthorityLable;//申请权限
@end

@implementation WMDeviceCell

#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.resultLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.authorityLabel];
        [self.contentView addSubview:self.applyAuthorityLable];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataModel:(WMDevice *)model {
    self.nameLabel.text = model.name;
    
    if (model.rentInfo) {
        self.typeLabel.text = @"租赁设备";
        self.authorityLabel.hidden = YES;
        self.applyAuthorityLable.hidden = YES;
        
        if (model.rentInfo.remainingTime == 0) {
            self.timeLabel.hidden = YES;
            self.resultLabel.hidden = NO;
            self.resultLabel.text = @"已结束";
        } else {
            self.resultLabel.hidden = YES;
            self.timeLabel.hidden = NO;
            int intRemaining = [model.rentInfo.remainingTime intValue];
            int hour = intRemaining / 3600;
            int minute = ( intRemaining % 3600 ) / 60;
            int second = ( intRemaining % 60) % 60;
            NSString *timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
            self.timeLabel.text = timeString;
        }
        self.priceLabel.hidden = NO;
        int yuan = [model.rentInfo.price intValue] / 100;
        int fen = [model.rentInfo.price intValue] % 100;
        NSString *priceString = [NSString stringWithFormat:@"%d.%02d元/%@小时", yuan, fen, model.rentInfo.rentTime];
        self.priceLabel.text = priceString;
    } else {
        self.timeLabel.hidden = YES;
        self.resultLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        if (model.online) {
            self.typeLabel.text = @"在线";
        } else {
            self.typeLabel.text = @"离线";
        }
        if (model.permission == WMDevicePermissionTypeView) {
            self.authorityLabel.hidden = YES;
            self.applyAuthorityLable.hidden = NO;
            self.applyAuthorityLable.text = @"申请控制权限";
        } else {
            self.applyAuthorityLable.hidden = YES;
            self.authorityLabel.hidden = NO;
            self.authorityLabel.text = @"已有权限";
        }
    }
}

#pragma mark - Getters & setters
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(IconGap, IconGap, IconWidth, IconHeight)];
        _iconView.image = [UIImage imageNamed:@"device_cell_icon"];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) { 
        _nameLabel = [self labelWithFrame:WM_CGRectMake(NameX, NameY, Screen_Width, NameHeight)
                                     font:[UIFont boldSystemFontOfSize:15]
                                textColor:[WMUIUtility color:@"0x444444"]];
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [self labelWithFrame:WM_CGRectMake(TypeX, TypeY, Screen_Width, TypeHeight)
                                     font:[UIFont systemFontOfSize:13]
                                textColor:[WMUIUtility color:@"0x666666"]];
    }
    return _typeLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self labelWithFrame:WM_CGRectMake(TimeX, TimeY, Screen_Width, TimeHeight)
                                     font:[UIFont systemFontOfSize:14]
                                textColor:[WMUIUtility color:@"0xff315d"]];
    }
    return _timeLabel;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [self labelWithFrame:WM_CGRectMake(ResultX, ResultY, Screen_Width, ResultHeight)
                                       font:[UIFont systemFontOfSize:14]
                                  textColor:[WMUIUtility color:@"0xc8c8c8"]];
    }
    return _resultLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [self labelWithFrame:WM_CGRectMake(0, PriceY, Cell_width - PriceRightGap, PriceHeight)
                                      font:[UIFont systemFontOfSize:14]
                                 textColor:[WMUIUtility color:@"0x24938c"]];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)authorityLabel {
    if (!_authorityLabel) {
        _authorityLabel = [self labelWithFrame:WM_CGRectMake(0, AuthorityY, Cell_width - AuthorityRightGap, AuthorityHeight)
                                          font:[UIFont systemFontOfSize:14]
                                     textColor:[WMUIUtility color:@"0xc8c8c8"]];
        _authorityLabel.textAlignment = NSTextAlignmentRight;
    }
    return _authorityLabel;
}

- (UILabel *)applyAuthorityLable {
    if (!_applyAuthorityLable) {
        _applyAuthorityLable = [self labelWithFrame:WM_CGRectMake(ApplyAuthorityX, ApplyAuthorityY, ApplyAuthorityWidth, ApplyAuthorityHeight)
                                         font:[UIFont systemFontOfSize:14]
                                    textColor:[WMUIUtility color:@"0xffffff"]];
        _applyAuthorityLable.backgroundColor = [WMUIUtility color:@"0x32aea5"];
        _applyAuthorityLable.layer.cornerRadius = 11;
        _applyAuthorityLable.layer.masksToBounds = YES;
        _applyAuthorityLable.textAlignment = NSTextAlignmentCenter;
    }
    return _applyAuthorityLable;
}

#pragma mark - private
- (UILabel *)labelWithFrame:(CGRect)frame
                       font:(UIFont *)font
                  textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    return label;
}

@end
