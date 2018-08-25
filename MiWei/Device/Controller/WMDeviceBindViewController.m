//
//  WMDeviceBindViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/25.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceBindViewController.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMMatchDeviceInfo.h"
#import "WMHTTPUtility.h"
#import "MBProgressHUD.h"

@interface WMDeviceBindViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WMMatchDeviceInfo *matchInfo;
//进来时根据是否绑定显示 3 或者 1 个 section。如果没有绑定，开关为开，显示两个 section
@property (nonatomic, assign) BOOL bindSwitchOn;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceBindViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关联设备";
    [self.view addSubview:self.tableView];
    [self loadData];
}

#pragma mark - Targe action
- (void)onBind:(id)sender {
    UISwitch *switchView = sender;
    if (switchView.isOn) {
        //此时尚未选取，先不发 http 请求
        self.bindSwitchOn = YES;
        [self.tableView reloadData];
    } else {
        self.bindSwitchOn = NO;
        if (self.matchInfo.matchDeviceID.length > 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            __weak typeof(self) ws = self;
            [self setMatchDeviceInfoWithMatchDeviceId:@""
                                          linkControl:NO
                                             response:^(WMHTTPResult *result) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [ws.hud hideAnimated:YES];
                                                     if (result.success) {
                                                         [ws loadData];
                                                     } else {
                                                         [WMUIUtility showAlertWithMessage:@"设置失败" viewController:ws];
                                                         [switchView setOn:YES];
                                                     }
                                                 });
                                             }];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)onLinkControl:(id)sender {
    UISwitch *switchView = sender;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) ws = self;
    [self setMatchDeviceInfoWithMatchDeviceId:self.matchInfo.matchDeviceID
                                  linkControl:switchView.isOn
                                     response:^(WMHTTPResult *result) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [ws.hud hideAnimated:YES];
                                             if (result.success) {
                                             } else {
                                                 [WMUIUtility showAlertWithMessage:@"设置失败" viewController:ws];
                                                 [switchView setOn:!(switchView.isOn)];
                                             }
                                         });
                                     }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [WMUIUtility WMCGFloatForY:50];
    } else if (section == 2) {
        return [WMUIUtility WMCGFloatForY:5];
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if (section == 1) {
        view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, Navi_Height + 50, Screen_Width, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:WM_CGRectMake(18, 0, 100, 50)];
        label.textColor = [WMUIUtility color:@"0x444444"];
        label.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
        label.text = @"选取设备";
        [view addSubview:label];
    } else {
        view = [UIView new];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) ws = self;
        [self setMatchDeviceInfoWithMatchDeviceId:self.matchInfo.matchDevices[indexPath.row].deviceId
                                      linkControl:NO
                                         response:^(WMHTTPResult *result) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [ws.hud hideAnimated:YES];
                                                 if (result.success) {
                                                     [ws loadData];
                                                 } else {
                                                     [WMUIUtility showAlertWithMessage:@"设置失败" viewController:ws];
                                                 }
                                             });
                                         }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.matchInfo.matchDeviceID.length > 0) {
        return 3;
    } else if (self.bindSwitchOn) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.matchInfo.matchDeviceID.length > 0) {
            return 2;
        } else {
            return 1;
        }
    } else if (section == 1) {
        //已经有绑定成功的设备，则显示数量减 1
        if (self.matchInfo.matchDeviceID.length > 0) {
            return self.matchInfo.matchDevices.count - 1;
        } else {
            return self.matchInfo.matchDevices.count;
        }
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"绑定设备";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            BOOL isOn = NO;
            if (self.matchInfo.matchDeviceID.length > 0 || self.bindSwitchOn) {
                isOn = YES;
            }
            [switchView setOn:isOn];
            switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
            [switchView addTarget:self action:@selector(onBind:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = self.matchInfo.matchDeviceName;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else if (indexPath.section == 1) {
        //去除已绑定设备
        NSMutableArray <WMDevice *>*arr = [self.matchInfo.matchDevices mutableCopy];
        if (self.matchInfo.matchDeviceID.length > 0) {
            for (WMDevice *device in arr) {
                if ([self.matchInfo.matchDeviceID isEqualToString:device.deviceId]) {
                    [arr removeObject:device];
                    break;
                }
            }
        }
        cell.textLabel.text = arr[indexPath.row].name;
        cell.detailTextLabel.text = @"点击选取";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"联动控制";
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView setOn:(self.matchInfo.linkControl)];
        switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
        [switchView addTarget:self action:@selector(onLinkControl:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - Private method
- (void)loadData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", nil];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryMatchDeviceInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.matchInfo = [WMMatchDeviceInfo matchDeviceInfoWithDic:result.content];
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"/mobile/device/queryMatchDeviceInfo error, result is %@", result);
                                    }
                                }];
}

- (void)setMatchDeviceInfoWithMatchDeviceId:(NSString *)matchDeviceId
                                linkControl:(BOOL)linkControl
                                   response:(void (^)(WMHTTPResult *))response {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", matchDeviceId, @"matchDeviceID", @(linkControl), @"linkControl", nil];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/setMatchDeviceInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    response(result);
                                }];
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

@end
