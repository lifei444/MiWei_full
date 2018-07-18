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

#define PriceX

@interface WMDeviceCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;//租赁设备/在线/离线

//timeLable 和 resultLabel 在同一个地方出现，它们互斥，用同一个接口控制
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *resultLabel;//已结束

//TODO 右对齐，还要加一个“申请控制权限按钮”
//priceLabel 和 authorityLabel 在同一个地方出现，它们互斥，用同一个接口控制
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *authorityLabel;//权限
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
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataModel:(WMDevice *)model {
    self.nameLabel.text = model.name;
    
    if (model.rentInfo) {
        self.typeLabel.text = @"租赁设备";
        self.authorityLabel.hidden = YES;
//        if (model.rentInfo)
    } else {
        self.timeLabel.hidden = YES;
        self.resultLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.authorityLabel.hidden = NO;
        if (model.online) {
            self.typeLabel.text = @"在线";
        } else {
            self.typeLabel.text = @"离线";
        }
        if (model.permission == WMDevicePermissionTypeView) {
            self.authorityLabel.text = @"申请控制权限";
        } else {
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
