//
//  WMMeAddressViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeAddressViewController.h"
#import "WMHTTPUtility.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMRegion.h"
#import "MBProgressHUD.h"
#import <ActionSheetPicker_3_0/ActionSheetCustomPicker.h>

@interface WMMeAddressViewController () <ActionSheetCustomPickerDelegate>
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *addressValueLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *detailField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) ActionSheetCustomPicker *picker;
@property (nonatomic, strong) WMRegion *region;
@property (nonatomic, assign) NSInteger index1; // 省下标
@property (nonatomic, assign) NSInteger index2; // 市下标
@property (nonatomic, assign) NSInteger index3; // 区下标
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMMeAddressViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressValueLabel];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.detailField];
    [self.view addSubview:self.confirmButton];
}

#pragma mark - Target action
- (void)onSelect {
    self.index1 = 0;
    self.index2 = 0;
    self.index3 = 0;
    [self.picker showActionSheetPicker];
}

- (void)save {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    WMRegion *region = self.region.districts[self.index1].districts[self.index2].districts[self.index3];
    [dic setObject:region.addrCode forKey:@"addrCode"];
    [dic setObject:self.detailField.text forKey:@"addrDetail"];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/user/editUserInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            WMProfile *myProfile = [WMHTTPUtility currentProfile];
                                            myProfile.addrDetail = self.detailField.text;
                                            myProfile.region.lev1 = region.lev1;
                                            myProfile.region.lev2 = region.lev2;
                                            myProfile.region.lev3 = region.lev3;
                                            myProfile.region.addrCode = region.addrCode;
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"WMProfileUpdate" object:nil];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } else {
                                            NSLog(@"WMMeAddressViewController save failed");
                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                        }
                                    });
                                }];
}

#pragma mark - ActionSheetCustomPickerDelegate
- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin {
    WMRegion *region = self.region.districts[self.index1].districts[self.index2].districts[self.index3];
    self.addressValueLabel.text = [NSString stringWithFormat:@"%@%@%@", region.lev1, region.lev2, region.lev3];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger result = 0;
    if (component == 0) {
        result = self.region.districts.count;
    } else if (component == 1) {
        result = self.region.districts[self.index1].districts.count;
    } else if (component == 2) {
        result = self.region.districts[self.index1].districts[self.index2].districts.count;
    }
    return result;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 3;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *result = @"";
    if (component == 0) {
        result = self.region.districts[row].lev1;
    } else if (component == 1) {
        result = self.region.districts[self.index1].districts[row].lev2;
    } else if (component == 2) {
        result = self.region.districts[self.index1].districts[self.index2].districts[row].lev3;
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.index1 = row;
        self.index2 = 0;
        self.index3 = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        self.index2 = row;
        self.index3 = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 2) {
        self.index3 = row;
    }
}

#pragma mark - Private method
- (NSDictionary *)loadJson {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return result;
}

#pragma mark - Getters & setters
- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 10, 100, 50)];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        _addressLabel.text = @"省市区";
        _addressLabel.font = [UIFont systemFontOfSize:16];
        _addressLabel.textColor = [WMUIUtility color:@"0x424345"];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UILabel *)addressValueLabel {
    if(!_addressValueLabel) {
        _addressValueLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(100, Navi_Height + 10, Screen_Width - 100, 50)];
        _addressValueLabel.backgroundColor = [UIColor whiteColor];
        WMProfile *profile = [WMHTTPUtility currentProfile];
        _addressValueLabel.text = [NSString stringWithFormat:@"%@%@%@", profile.region.lev1, profile.region.lev2, profile.region.lev3];
        _addressValueLabel.font = [UIFont systemFontOfSize:16];
        _addressValueLabel.textColor = [WMUIUtility color:@"0x737474"];
        _addressValueLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelect)];
        [_addressValueLabel addGestureRecognizer:singleTap];
    }
    return _addressValueLabel;
}

- (UILabel *)detailLabel {
    if(!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 10 + 50 + 10, 100, 50)];
        _detailLabel.backgroundColor = [UIColor whiteColor];
        _detailLabel.text = @"详细地址";
        _detailLabel.font = [UIFont systemFontOfSize:16];
        _detailLabel.textColor = [WMUIUtility color:@"0x424345"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UITextField *)detailField {
    if(!_detailField) {
        _detailField = [[UITextField alloc] initWithFrame:WM_CGRectMake(100, Navi_Height + 10 + 50 + 10, Screen_Width - 100, 50)];
        _detailField.backgroundColor = [UIColor whiteColor];
        _detailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _detailField.text = [WMHTTPUtility currentProfile].addrDetail;
        _detailField.font = [UIFont systemFontOfSize:16];
        _detailField.textColor = [WMUIUtility color:@"0x737474"];
    }
    return _detailField;
}

- (UIButton *)confirmButton {
    if(!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(10, Navi_Height + 90 + 50 + 10, Screen_Width - 20, 40)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (ActionSheetCustomPicker *)picker {
    if (!_picker) {
        _picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"省市区选择" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
        _picker.tapDismissAction = TapActionCancel;
    }
    return _picker;
}

- (WMRegion *)region {
    if (!_region) {
        NSDictionary *districts = [self loadJson];
        _region = [WMRegion regionWithDic:districts];
    }
    return _region;
}
@end
