//
//  WMMeHeaderView.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeHeaderView.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

#define kheight 269

@interface WMMeHeaderView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UILabel *titleLable;
@end

@implementation WMMeHeaderView
+ (instancetype)headerView {
    WMMeHeaderView *v = [[self alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, kheight)];
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.bgView];
        [self addSubview:self.titleLable];
        [self addSubview:self.portraitImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.addressLabel];
    }
    return self;
}

#pragma mark - Getters and setters
- (UIImageView *)bgView {
    if (!_bgView) {
        CGRect rect = WM_CGRectMake(0, 0, Screen_Width, kheight);
        _bgView = [[UIImageView alloc] initWithFrame:rect];
        _bgView.image = [UIImage imageNamed:@"me_bg"];
    }
    return _bgView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        CGRect rect = WM_CGRectMake(0, 40, Screen_Width, 17);
        _titleLable = [[UILabel alloc] initWithFrame:rect];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [WMUIUtility color:@"0xffffff"];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.text = @"个人设置";
    }
    return _titleLable;
}

- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGRect rect = WM_CGRectMake((Screen_Width-110)/2, 80, 110, 110);
        _portraitImageView = [[UIImageView alloc] initWithFrame:rect];
        _portraitImageView.layer.cornerRadius = 50;
        _portraitImageView.layer.masksToBounds = YES;
        _portraitImageView.image = [UIImage imageNamed:@"me_portrait"];
    }
    return _portraitImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGRect rect = WM_CGRectMake(0, 80+110+12, Screen_Width, 16);
        _nameLabel = [[UILabel alloc] initWithFrame:rect];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.text = [WMHTTPUtility currentProfile].name;
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGRect rect = WM_CGRectMake(0, 80+110+12+16+12, Screen_Width, 15);
        _addressLabel = [[UILabel alloc] initWithFrame:rect];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.text = [WMHTTPUtility currentProfile].addrDetail;
    }
    return _addressLabel;
}

@end
