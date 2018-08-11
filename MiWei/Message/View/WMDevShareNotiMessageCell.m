//
//  WMDevShareNotiMessageCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/6.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevShareNotiMessageCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMDevShareNotiMessage.h"
#import "WMHTTPUtility.h"

#define Name_Y              84
#define Name_Height         24

#define Separator_Width     325
#define Separator_X         ((MessageCell_Width - Separator_Width)/2)
#define Separator_Y         (244-45-44)

#define Button_Y            Separator_Y
#define Button_Height       44

#define Allow_X             15
#define Allow_Width         30
#define Reject_X            60
#define Reject_Width        30
#define Owner_X             100
#define Owner_Width         100

@interface WMDevShareNotiMessageCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *allowButton;
@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, strong) UIButton *ownerButton;
@property (nonatomic, strong) WMDevShareNotiMessage *message;
@end

@implementation WMDevShareNotiMessageCell
#pragma mark - Life cycle
- (void)loadSubViews {
    [super loadSubViews];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.separator];
    [self.contentView addSubview:self.allowButton];
    [self.contentView addSubview:self.rejectButton];
    [self.contentView addSubview:self.ownerButton];
}

- (void)setDataModel:(id)model {
    WMDevShareNotiMessage *message = model;
    self.titleLabel.text = @"设备共享通知";
    self.nameLabel.text = message.deviceName;
    self.footerView.label.text = [self timeStringWithTimestamp:message.time];
    self.message = message;
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:244];
}

#pragma mark - Target action
- (void)clickAllow:(UIButton *)btn {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.message.deviceId forKey:@"deviceID"];
    [dic setObject:@(0x03) forKey:@"permission"];
    [dic setObject:self.message.requestUserID forKey:@"userID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/setPermission"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                  if (result.success) {
                                      
                                  } else {
                                      NSLog(@"clickAllow, result is %@", result);
                                  }
                              }];
}

- (void)clickReject:(UIButton *)btn {
    
}

- (void)clickOwner:(UIButton *)btn {
    
}

#pragma mark - Private method

     
#pragma mark - Getters & setters
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Name_Y, MessageCell_Width, Name_Height)];
        _nameLabel.textColor = [WMUIUtility color:@"0x222222"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:24]];
    }
    return _nameLabel;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:WM_CGRectMake(Separator_X, Separator_Y, Separator_Width, 1)];
        _separator.backgroundColor = [WMUIUtility color:@"0xebebeb"];
    }
    return _separator;
}

- (UIButton *)allowButton {
    if (!_allowButton) {
        _allowButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Allow_X, Button_Y, Allow_Width, Button_Height)];
        [_allowButton setTitle:@"允许" forState:UIControlStateNormal];
        [_allowButton setTitleColor:[WMUIUtility color:@"0x108cfe"] forState:UIControlStateNormal];
        _allowButton.titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:14]];
        _allowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_allowButton addTarget:self action:@selector(clickAllow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allowButton;
}

- (UIButton *)rejectButton {
    if (!_rejectButton) {
        _rejectButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Reject_X, Button_Y, Reject_Width, Button_Height)];
        [_rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_rejectButton setTitleColor:[WMUIUtility color:@"0x108cfe"] forState:UIControlStateNormal];
        _rejectButton.titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:14]];
        [_rejectButton addTarget:self action:@selector(clickReject:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectButton;
}

- (UIButton *)ownerButton {
    if (!_ownerButton) {
        _ownerButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(Owner_X, Button_Y, Owner_Width, Button_Height)];
        [_ownerButton setTitle:@"分配主人权限" forState:UIControlStateNormal];
        [_ownerButton setTitleColor:[WMUIUtility color:@"0x108cfe"] forState:UIControlStateNormal];
        _ownerButton.titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:14]];
        [_rejectButton addTarget:self action:@selector(clickOwner:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ownerButton;
}
@end
