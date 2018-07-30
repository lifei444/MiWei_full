//
//  WMMeAddressViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeAddressViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

@interface WMMeAddressViewController ()
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UITextField *addressField;
@property(nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMMeAddressViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.addressField];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - Target action
- (void)save {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.addressField.text forKey:@"addrDetail"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/user/editUserInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [WMHTTPUtility currentProfile].addrDetail = self.addressField.text;
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    } else {
                                        NSLog(@"WMMeAddressViewController save failed");
                                    }
                                }];
}

#pragma mark - Getters & setters
- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:WM_CGRectMake(0, Navi_Height + 10, 64, 50)];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        _addressLabel.text = @"地址";
        _addressLabel.font = [UIFont systemFontOfSize:16];
        _addressLabel.textColor = [WMUIUtility color:@"0x424345"];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UITextField *)addressField {
    if(!_addressField) {
        _addressField = [[UITextField alloc] initWithFrame:WM_CGRectMake(64, Navi_Height + 10, Screen_Width - 64, 50)];
        _addressField.backgroundColor = [UIColor whiteColor];
        _addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressField.text = [WMHTTPUtility currentProfile].addrDetail;
        _addressField.font = [UIFont systemFontOfSize:16];
        _addressField.textColor = [WMUIUtility color:@"0x737474"];
    }
    return _addressField;
}

- (UIButton *)confirmButton {
    if(!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(10, Navi_Height + 90, Screen_Width - 20, 40)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
