//
//  WMDeviceSettingViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceSettingViewController.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMDeviceNameViewController.h"
#import "WMDeviceAddressViewController.h"
#import "WMHTTPUtility.h"
#import "MBProgressHUD.h"
#import "WMDeviceConfigViewController.h"
#import "WMDeviceBindViewController.h"
#import <FogV3/FogV3.h>

#define Cell_Height         50
#define Footer_Gap          18
#define Footer_Height       44
#define Footer_Gap2         10

@interface WMDeviceSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *viewArray;
@property (nonatomic, strong) NSArray *controlOnlineArray;
@property (nonatomic, strong) NSArray *controlOfflineArray;
@property (nonatomic, strong) NSArray *ownerOnlineArray;
@property (nonatomic, strong) NSArray *ownerOfflineArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceSettingViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Target action
- (void)onBabyLock:(id)sender {
    UISwitch *switchView = sender;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.detail.deviceId forKey:@"deviceID"];
    [dic setObject:@(switchView.isOn) forKey:@"babyLock"];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/control"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self];
                                        } else {
                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                            [switchView setOn:!(switchView.isOn)];
                                        }
                                    });
                                }];
}

- (void)onScreenSwitch:(id)sender {
    UISwitch *switchView = sender;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.detail.deviceId forKey:@"deviceID"];
    [dic setObject:@(switchView.isOn) forKey:@"screenSwitch"];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/control"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self];
                                        } else {
                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                            [switchView setOn:!(switchView.isOn)];
                                        }
                                    });
                                }];
}

- (void)reset {
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return [WMUIUtility WMCGFloatForY:(Footer_Gap + Footer_Height + Footer_Gap2)];
    } else {
        return [WMUIUtility WMCGFloatForY:5];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        UIView *footer = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Footer_Gap + Footer_Height)];
        UIButton *button = [[UIButton alloc] initWithFrame:WM_CGRectMake(10, Footer_Gap, Screen_Width - 20, Footer_Height)];
        button.backgroundColor = [WMUIUtility color:@"0x2b938b"];
        [button setTitle:@"滤网复位" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        [footer addSubview:button];
        return footer;
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:0];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 0)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"设备名称"]) {
        WMDeviceNameViewController *vc = [[WMDeviceNameViewController alloc] init];
        vc.detail = self.detail;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.textLabel.text isEqualToString:@"地理位置"]) {
        WMDeviceAddressViewController *vc = [[WMDeviceAddressViewController alloc] init];
        vc.detail = self.detail;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.textLabel.text isEqualToString:@"固件升级"]) {
        if (self.detail.newestVerFw > self.detail.verFW) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.detail.deviceId, @"deviceID", nil];
            [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                       URLString:@"/mobile/device/requestOTA"
                                      parameters:dic
                                        response:^(WMHTTPResult *result) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.hud hideAnimated:YES];
                                                if (result.success) {
                                                    [WMUIUtility showAlertWithMessage:@"操作成功" viewController:self];
                                                } else {
                                                    NSLog(@"/mobile/device/requestOTA error, result is %@", result);
                                                    [WMUIUtility showAlertWithMessage:@"操作失败" viewController:self];
                                                }
                                            });
                                        }];
        }
    } else if ([cell.textLabel.text isEqualToString:@"配置网络"]) {
        NSString *ssid = [[FogEasyLinkManager sharedInstance] getSSID];
        WMDeviceConfigViewController *vc = [[WMDeviceConfigViewController alloc] init];
        vc.ssid = ssid;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.textLabel.text isEqualToString:@"关联设备"]) {
        WMDeviceBindViewController *vc = [[WMDeviceBindViewController alloc] init];
        vc.deviceId = self.detail.deviceId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.textLabel.text isEqualToString:@"分享设备"]) {
        
    } else if ([cell.textLabel.text isEqualToString:@"删除设备"]) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"/mobile/device/removeDevice"
                                  parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.detail.deviceId, @"deviceID", nil]
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            } else {
                                                [WMUIUtility showAlertWithMessage:@"删除失败" viewController:self];
                                            }
                                        });
                                    }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //debug
//    self.detail.online = YES;
//    self.detail.permission = WMDevicePermissionTypeOwner;

    if (self.detail.permission == WMDevicePermissionTypeView) {
        NSArray *arr = self.viewArray[section];
        return arr.count;
    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
        if (self.detail.online) {
            NSArray *arr = self.controlOnlineArray[section];
            return arr.count;
        } else {
            NSArray *arr = self.controlOfflineArray[section];
            return arr.count;
        }
    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
        if (self.detail.online) {
            NSArray *arr = self.ownerOnlineArray[section];
            return arr.count;
        } else {
            NSArray *arr = self.ownerOfflineArray[section];
            return arr.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (self.detail.permission == WMDevicePermissionTypeView) {
        cell.textLabel.text = self.viewArray[indexPath.section][indexPath.row];
    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
        if (self.detail.online) {
            cell.textLabel.text = self.controlOnlineArray[indexPath.section][indexPath.row];
        } else {
            cell.textLabel.text = self.controlOfflineArray[indexPath.section][indexPath.row];
        }
    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
        if (self.detail.online) {
            cell.textLabel.text = self.ownerOnlineArray[indexPath.section][indexPath.row];
        } else {
            cell.textLabel.text = self.ownerOfflineArray[indexPath.section][indexPath.row];
        }
    }
    if ([cell.textLabel.text isEqualToString:@"设备名称"]) {
        cell.detailTextLabel.text = self.detail.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"地理位置"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@", self.detail.addrLev1, self.detail.addrLev2, self.detail.addrLev3];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"MAC/IMEI"]) {
        cell.detailTextLabel.text = self.detail.deviceId;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"固件版本"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.detail.verFW];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"固件升级"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.detail.newestVerFw];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"设备类型及型号"]) {
        cell.detailTextLabel.text = self.detail.modelName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"配置网络"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"关联设备"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"分享设备"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"删除设备"]) {
        
    } else if ([cell.textLabel.text isEqualToString:@"婴儿锁"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView setOn:self.detail.babyLock];
        switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [switchView addTarget:self action:@selector(onBabyLock:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    } else if ([cell.textLabel.text isEqualToString:@"灯光面板"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView setOn:self.detail.screenSwitch];
        switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [switchView addTarget:self action:@selector(onScreenSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

#pragma mark - Private method
- (NSInteger)numberOfSections {
    if (self.detail.permission == WMDevicePermissionTypeView) {
        return self.viewArray.count;
    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
        if (self.detail.online) {
            return self.controlOnlineArray.count;
        } else {
            return self.controlOfflineArray.count;
        }
    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
        if (self.detail.online) {
            return self.ownerOnlineArray.count;
        } else {
            return self.ownerOfflineArray.count;
        }
    }
    return 0;
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型及型号"], @[@"分享设备", @"删除设备"], nil];
    }
    return _viewArray;
}

- (NSArray *)controlOnlineArray {
    if (!_controlOnlineArray) {
        _controlOnlineArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型及型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], @[@"婴儿锁", @"灯光面板"], nil];
    }
    return _controlOnlineArray;
}

- (NSArray *)controlOfflineArray {
    if (!_controlOfflineArray) {
        _controlOfflineArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型及型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], nil];
    }
    return _controlOfflineArray;
}

- (NSArray *)ownerOnlineArray {
    if (!_ownerOnlineArray) {
        _ownerOnlineArray = [NSArray arrayWithObjects:@[@"设备名称", @"地理位置"], @[@"MAC/IMEI", @"固件版本", @"固件升级", @"设备类型及型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], @[@"婴儿锁", @"灯光面板"], nil];
    }
    return _ownerOnlineArray;
}

- (NSArray *)ownerOfflineArray {
    if (!_ownerOfflineArray) {
        _ownerOfflineArray = [NSArray arrayWithObjects:@[@"设备名称", @"地理位置"], @[@"MAC/IMEI", @"固件版本", @"设备类型及型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], nil];
    }
    return _ownerOfflineArray;
}
@end
