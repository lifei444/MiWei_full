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
#import "WMStrainerResetViewController.h"
#import <FogV3/FogV3.h>
#import <WXApi.h>

#define Cell_Height         50
#define Footer_Gap          18
#define Footer_Height       44
#define Footer_Gap2         10

@interface WMDeviceSettingViewController () <UITableViewDelegate, UITableViewDataSource, WMStrainerResetViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *viewArray;
//@property (nonatomic, strong) NSArray *controlOnlineArray;
//@property (nonatomic, strong) NSArray *controlOfflineArray;
@property (nonatomic, strong) NSArray *ownerOnlineArray;
//@property (nonatomic, strong) NSArray *ownerOfflineArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *shadowView;
@end

@implementation WMDeviceSettingViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shadowView];
    self.navigationItem.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Target action
- (void)onBabyLock:(id)sender {
    UISwitch *switchView = sender;
    if (self.detail.babyLock == switchView.isOn) {
        return;
    }
    if (!self.detail.online) {
        [switchView setOn:!(switchView.isOn)];
        [WMUIUtility showAlertWithMessage:@"设备不在线" viewController:self];
    } else {
        if (self.detail.permission == WMDevicePermissionTypeViewAndControl
            || self.detail.permission == WMDevicePermissionTypeOwner) {
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
                                                    self.detail.babyLock = switchView.isOn;
                                                } else {
                                                    [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                                    [switchView setOn:!(switchView.isOn)];
                                                }
                                            });
                                        }];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
            [switchView setOn:!(switchView.isOn)];
        }
    }
}

- (void)onScreenSwitch:(id)sender {
    UISwitch *switchView = sender;
    if (self.detail.screenSwitch == switchView.isOn) {
        return;
    }
    if (!self.detail.online) {
        [WMUIUtility showAlertWithMessage:@"设备不在线" viewController:self];
        [switchView setOn:!(switchView.isOn)];
    } else {
        if (self.detail.permission == WMDevicePermissionTypeViewAndControl
            || self.detail.permission == WMDevicePermissionTypeOwner) {
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
                                                    self.detail.screenSwitch = switchView.isOn;
                                                } else {
                                                    [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                                    [switchView setOn:!(switchView.isOn)];
                                                }
                                            });
                                        }];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
            [switchView setOn:!(switchView.isOn)];
        }
    }
}

- (void)reset {
    if (!self.detail.online) {
        [WMUIUtility showAlertWithMessage:@"设备不在线" viewController:self];
    } else {
        if (self.detail.permission == WMDevicePermissionTypeOwner) {
            WMStrainerResetViewController *vc = [[WMStrainerResetViewController alloc] init];
            vc.deviceId = self.detail.deviceId;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.delegate = self;
            self.shadowView.alpha = 0.5;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
        }
    }
}

#pragma mark - WMStrainerResetViewControllerDelegate
- (void)onDismiss {
    self.shadowView.alpha = 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3 && [self.prodId intValue] == 0) {
        return [WMUIUtility WMCGFloatForY:(Footer_Gap + Footer_Height + Footer_Gap2)];
    } else {
        return [WMUIUtility WMCGFloatForY:5];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3 && [self.prodId intValue] == 0) {
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
        if (self.detail.permission == WMDevicePermissionTypeOwner) {
            WMDeviceNameViewController *vc = [[WMDeviceNameViewController alloc] init];
            vc.detail = self.detail;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
        }
    } else if ([cell.textLabel.text isEqualToString:@"地理位置"]) {
        if (self.detail.permission == WMDevicePermissionTypeOwner) {
            WMDeviceAddressViewController *vc = [[WMDeviceAddressViewController alloc] init];
            vc.detail = self.detail;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
        }
    } else if ([cell.textLabel.text isEqualToString:@"固件升级"]) {
        if (!self.detail.online) {
            [WMUIUtility showAlertWithMessage:@"设备不在线" viewController:self];
        } else {
            if (self.detail.permission == WMDevicePermissionTypeOwner) {
                if ([self.detail.newestVerFw intValue] > [self.detail.verFW intValue]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"是否升级？"
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确认", nil];
                    alertView.tag = 1001;
                    [alertView show];
                } else {
                    [WMUIUtility showAlertWithMessage:@"已是最新版本" viewController:self];
                }
            } else {
                [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
            }
        }
    } else if ([cell.textLabel.text isEqualToString:@"配置网络"]) {
        if (self.detail.permission == WMDevicePermissionTypeOwner
            || self.detail.permission == WMDevicePermissionTypeViewAndControl) {
            NSString *ssid = [[FogEasyLinkManager sharedInstance] getSSID];
            WMDeviceConfigViewController *vc = [[WMDeviceConfigViewController alloc] init];
            vc.ssid = ssid;
            vc.deviceId = self.detail.deviceId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
        }
    } else if ([cell.textLabel.text isEqualToString:@"关联设备"]) {
        if (self.detail.permission == WMDevicePermissionTypeOwner
            || self.detail.permission == WMDevicePermissionTypeViewAndControl) {
            WMDeviceBindViewController *vc = [[WMDeviceBindViewController alloc] init];
            vc.deviceId = self.detail.deviceId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [WMUIUtility showAlertWithMessage:@"没有权限" viewController:self];
        }
    } else if ([cell.textLabel.text isEqualToString:@"分享设备"]) {
        NSString *str = [NSString stringWithFormat:@"来自《%@》的米微净化器（检测仪）《%@》分享，请点击如下链接查看设备https://mweb.mivei.com/addDevice?deviceID=%@", [WMHTTPUtility currentProfile].name, self.detail.name, self.detail.deviceId];
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = str;
        req.bText = YES;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    } else if ([cell.textLabel.text isEqualToString:@"删除设备"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确认删除设备？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
        alertView.tag = 1002;
        [alertView show];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.ownerOnlineArray[section];
    return arr.count;

//    if (self.detail.permission == WMDevicePermissionTypeView) {
//        NSArray *arr = self.viewArray[section];
//        return arr.count;
//    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
//        if (self.detail.online) {
//            NSArray *arr = self.controlOnlineArray[section];
//            return arr.count;
//        } else {
//            NSArray *arr = self.controlOfflineArray[section];
//            return arr.count;
//        }
//    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
//        if (self.detail.online) {
//            NSArray *arr = self.ownerOnlineArray[section];
//            return arr.count;
//        } else {
//            NSArray *arr = self.ownerOfflineArray[section];
//            return arr.count;
//        }
//    }
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.ownerOnlineArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (self.detail.permission == WMDevicePermissionTypeView) {
//        cell.textLabel.text = self.viewArray[indexPath.section][indexPath.row];
//    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
//        if (self.detail.online) {
//            cell.textLabel.text = self.controlOnlineArray[indexPath.section][indexPath.row];
//        } else {
//            cell.textLabel.text = self.controlOfflineArray[indexPath.section][indexPath.row];
//        }
//    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
//        if (self.detail.online) {
//            cell.textLabel.text = self.ownerOnlineArray[indexPath.section][indexPath.row];
//        } else {
//            cell.textLabel.text = self.ownerOfflineArray[indexPath.section][indexPath.row];
//        }
//    }
    if ([cell.textLabel.text isEqualToString:@"设备名称"]) {
        cell.detailTextLabel.text = self.detail.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"地理位置"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.detail.addrLev1?:@"", self.detail.addrLev2?:@"", self.detail.addrLev3?:@"", self.detail.addrDetail?:@""];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"MAC/IMEI"]) {
        cell.detailTextLabel.text = self.detail.deviceId;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"固件版本"]) {
        int ver = [self.detail.verFW intValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", ver];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"固件升级"]) {
        int ver = [self.detail.newestVerFw intValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", ver];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"设备类型"]) {
        cell.detailTextLabel.text = self.detail.prodName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"设备型号"]) {
        cell.detailTextLabel.text = self.detail.modelName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"配置网络"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"关联设备"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"分享设备"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([cell.textLabel.text isEqualToString:@"删除设备"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([cell.textLabel.text isEqualToString:@"婴儿锁"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView setOn:self.detail.babyLock];
        switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [switchView addTarget:self action:@selector(onBabyLock:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    } else if ([cell.textLabel.text isEqualToString:@"灯光面板"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView setOn:self.detail.screenSwitch];
        switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [switchView addTarget:self action:@selector(onScreenSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    return cell;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
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
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
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
}

#pragma mark - Private method
- (NSInteger)numberOfSections {
    return 4;
//    if (self.detail.permission == WMDevicePermissionTypeView) {
//        return self.viewArray.count;
//    } else if (self.detail.permission == WMDevicePermissionTypeViewAndControl) {
//        if (self.detail.online) {
//            return self.controlOnlineArray.count;
//        } else {
//            return self.controlOfflineArray.count;
//        }
//    } else if (self.detail.permission == WMDevicePermissionTypeOwner) {
//        if (self.detail.online) {
//            return self.ownerOnlineArray.count;
//        } else {
//            return self.ownerOfflineArray.count;
//        }
//    }
//    return 0;
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

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
    }
    return _shadowView;
}

//- (NSArray *)viewArray {
//    if (!_viewArray) {
//        _viewArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型", @"设备型号"], @[@"分享设备", @"删除设备"], nil];
//    }
//    return _viewArray;
//}
//
//- (NSArray *)controlOnlineArray {
//    if (!_controlOnlineArray) {
//        _controlOnlineArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型", @"设备型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], @[@"婴儿锁", @"灯光面板"], nil];
//    }
//    return _controlOnlineArray;
//}
//
//- (NSArray *)controlOfflineArray {
//    if (!_controlOfflineArray) {
//        _controlOfflineArray = [NSArray arrayWithObjects:@[@"MAC/IMEI", @"固件版本", @"设备类型", @"设备型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], nil];
//    }
//    return _controlOfflineArray;
//}

- (NSArray *)ownerOnlineArray {
    if (!_ownerOnlineArray) {
        _ownerOnlineArray = [NSArray arrayWithObjects:@[@"设备名称", @"地理位置"], @[@"MAC/IMEI", @"固件版本", @"固件升级", @"设备类型", @"设备型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], @[@"婴儿锁", @"灯光面板"], nil];
    }
    return _ownerOnlineArray;
}

//- (NSArray *)ownerOfflineArray {
//    if (!_ownerOfflineArray) {
//        _ownerOfflineArray = [NSArray arrayWithObjects:@[@"设备名称", @"地理位置"], @[@"MAC/IMEI", @"固件版本", @"设备类型", @"设备型号"], @[@"配置网络", @"关联设备", @"分享设备", @"删除设备"], nil];
//    }
//    return _ownerOfflineArray;
//}
@end
