//
//  WMDeviceTimerEditViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceTimerEditViewController.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMDeviceUtility.h"
#import "WMDeviceRepetitionViewController.h"
#import "WMDeviceAirSpeedSettingViewController.h"
#import "WMDeviceVentilationSettingViewController.h"
#import "MBProgressHUD.h"

#define Picker_Height   220

@interface WMDeviceTimerEditViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, WMDeviceRepetitionDelegate, WMDeviceAirSpeedSettingDelegate, WMDeviceVentilationSettingDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceTimerEditViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setNaviItems];
}

#pragma mark - Target action
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(self.timer.airSpeed) forKey:@"airSpeed"];
    [dic setObject:@(self.timer.auxiliaryHeat) forKey:@"auxiliaryHeat"];
    [dic setObject:@(YES) forKey:@"enable"];
    [dic setObject:@(self.timer.powerOn) forKey:@"powerOn"];
    [dic setObject:self.timer.repetition forKey:@"repetition"];
    NSInteger hour = [self.picker selectedRowInComponent:0];
    NSInteger minute = [self.picker selectedRowInComponent:1];
    NSInteger startTime = hour * 60 + minute;
    [dic setObject:@(startTime) forKey:@"startTime"];
    [dic setObject:@(self.timer.ventilationMode) forKey:@"ventilationMode"];
    if (self.mode == WMDeviceTimerEditVCModeAdd) {
        [dic setObject:self.deviceId forKey:@"deviceID"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"mobile/timing/create"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                [WMUIUtility showAlertWithMessage:@"创建失败" viewController:self];
                                            }
                                        });
                                    }];
    } else if (self.mode == WMDeviceTimerEditVCModeEdit) {
        [dic setObject:self.timer.timerId forKey:@"id"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"mobile/timing/edit"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.hud hideAnimated:YES];
                                            if (result.success) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                [WMUIUtility showAlertWithMessage:@"编辑失败" viewController:self];
                                            }
                                        });
                                    }];
    }
}

- (void)onAuxiliaryHeatSwitch:(id)sender {
    UISwitch *switchView = sender;
    self.timer.auxiliaryHeat = switchView.isOn;
}

- (void)onPowerOnSwitch:(id)sender {
    UISwitch *switchView = sender;
    self.timer.powerOn = switchView.isOn;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else {
        return 60;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return [WMUIUtility WMCGFloatForY:44];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = [NSString stringWithFormat:@"%02ld", (long)row];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:[WMUIUtility WMCGFloatForY:20]], NSForegroundColorAttributeName:[WMUIUtility color:@"0xffffff"]} range:NSMakeRange(0, [attributedString  length])];
    return attributedString;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.picker;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"timerEditCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"重复";
            cell.detailTextLabel.text = [WMDeviceUtility generateWeekDayString:self.timer.repetition];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.textLabel.text = @"档位";
            cell.detailTextLabel.text = [WMDeviceUtility descriptionOfAirSpeed:self.timer.airSpeed];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2: {
            cell.textLabel.text = @"辅热";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView setOn:self.timer.auxiliaryHeat];
            switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
            [switchView addTarget:self action:@selector(onAuxiliaryHeatSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            break;
        }
        case 3:
            cell.textLabel.text = @"新风";
            cell.detailTextLabel.text = [WMDeviceUtility descriptionOfVentilation:self.timer.ventilationMode];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4: {
            cell.textLabel.text = @"开关机";
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchView setOn:self.timer.powerOn];
            switchView.onTintColor = [WMUIUtility color:@"0x2b928a"];
            [switchView addTarget:self action:@selector(onPowerOnSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:Picker_Height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WMDeviceRepetitionViewController *vc = [[WMDeviceRepetitionViewController alloc] init];
        vc.repetition = self.timer.repetition;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        WMDeviceAirSpeedSettingViewController *vc = [[WMDeviceAirSpeedSettingViewController alloc] init];
        vc.speed = self.timer.airSpeed;
        vc.delegage = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        WMDeviceVentilationSettingViewController *vc = [[WMDeviceVentilationSettingViewController alloc] init];
        vc.mode = self.timer.ventilationMode;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - WMDeviceVentilationSettingDelegate
- (void)onVentilationConfirm:(WMVentilationMode)mode {
    self.timer.ventilationMode = mode;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.detailTextLabel.text = [WMDeviceUtility descriptionOfVentilation:self.timer.ventilationMode];
    });
}

#pragma mark - WMDeviceAirSpeedSettingDelegate
- (void)onAirSpeedConfirm:(WMAirSpeed)speed {
    self.timer.airSpeed = speed;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = [WMDeviceUtility descriptionOfAirSpeed:self.timer.airSpeed];
    });
}

#pragma mark - WMDeviceRepetitionDelegate
- (void)onRepetitionConfirm:(NSNumber *)repetition {
    self.timer.repetition = repetition;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = [WMDeviceUtility generateWeekDayString:self.timer.repetition];
    });
}

#pragma mark - Private method
- (void)setNaviItems {
    if (self.mode == WMDeviceTimerEditVCModeAdd) {
        self.navigationItem.title = @"添加定时";
    } else {
        self.navigationItem.title = @"编辑定时";
    }
    UIButton *left = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:[WMUIUtility color:@"0x767676"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    UIButton *right = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [right setTitle:@"保存" forState:UIControlStateNormal];
    [right setTitleColor:[WMUIUtility color:@"0x767676"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIPickerView *)picker {
    if (!_picker) {
         _picker = [[UIPickerView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Picker_Height)];
        _picker.backgroundColor = [WMUIUtility color:@"0x12948a"];
        _picker.delegate = self;
        _picker.dataSource = self;
        int hour = [self.timer.startTime intValue] / 60;
        int minute = [self.timer.startTime intValue] % 60;
        [_picker selectRow:hour inComponent:0 animated:NO];
        [_picker selectRow:minute inComponent:1 animated:NO];
    }
    return _picker;
}

- (WMDeviceTimer *)timer {
    if (!_timer) {
        _timer = [[WMDeviceTimer alloc] init];
        _timer.airSpeed = WMAirSpeedAuto;
        _timer.auxiliaryHeat = NO;
        _timer.enable = YES;
        _timer.powerOn = YES;
        _timer.repetition = @(0x7f);
        _timer.startTime = @(0);
        _timer.ventilationMode = WMVentilationModeLow;
    }
    return _timer;
}
@end
