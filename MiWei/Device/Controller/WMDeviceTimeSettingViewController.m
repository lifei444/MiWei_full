//
//  WMDeviceTimeSettingViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimeSettingViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMDeviceTimeSetting.h"
#import "WMDeviceTimerCell.h"
#import "MBProgressHUD.h"

NSString *const cellIdentifier = @"cell";

@interface WMDeviceTimeSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WMDeviceTimeSetting *setting;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceTimeSettingViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时设置";
    [self.view addSubview:self.tableView];
    [self setRightNavBar];
    [self loadData];
}

#pragma mark - Target action
- (void)edit {
    
}

- (void)add {
    
}

- (void)onSwitch:(id)sender {
    UISwitch *switchView = sender;
    
    if (self.setting) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.deviceId forKey:@"deviceID"];
        [dic setObject:@(switchView.isOn) forKey:@"enable"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"mobile/timing/switchAll"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                                [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self];
                                            } else {
                                                [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                            }
                                        });
                                    }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setting.timers.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 50)];
    view.backgroundColor = [WMUIUtility color:@"0xffffff"];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(10, 0, 100, 50)];
    titleLabel.text = @"总开关";
    titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
    titleLabel.textColor = [WMUIUtility color:@"0x444444"];
    [view addSubview:titleLabel];
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:WM_CGRectMake(305, 11, 45, 20)];
    [switchView addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
    switchView.on = self.setting.enable;
    [view addSubview:switchView];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.vc = self;
    [cell setDataModel:self.setting.timers[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMDeviceTimerCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:50];
}

#pragma mark - Private methods
- (void)setRightNavBar {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    UIButton *editButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 50, 30)];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[WMUIUtility color:@"0x6a6a6a"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editButton];
    UIButton *addButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(50, 0, 30, 30)];
    [addButton setImage:[UIImage imageNamed:@"device_time_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (void)loadData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", nil];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/timing/list"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        self.setting = [WMDeviceTimeSetting settingWithDic:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"/mobile/timing/list error, result is %@", result);
                                    }
                                }];
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WMDeviceTimerCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}
@end
