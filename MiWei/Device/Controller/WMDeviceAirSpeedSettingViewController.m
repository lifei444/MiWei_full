//
//  WMDeviceAirSpeedSettingViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceAirSpeedSettingViewController.h"
#import "WMUIUtility.h"
#import "WMDeviceUtility.h"
#import "MBProgressHUD.h"

@interface WMDeviceAirSpeedSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMDeviceAirSpeedSettingViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择风速档位";
    self.navigationItem.rightBarButtonItem.title = @"确定";
//    [self setRightNavBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"自动";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"静音";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"舒适";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"标准";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"强力";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"飓风";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.speed == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

#pragma mark - Target action
- (void)onConfirm {
    NSIndexPath *selectIndex = [self.tableView indexPathForSelectedRow];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (selectIndex.row == self.speed) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [dic setObject:self.deviceId forKey:@"deviceID"];
        [dic setObject:@(selectIndex.row) forKey:@"airSpeed"];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WMDeviceUtility setDevice:dic response:^(WMHTTPResult *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                if (result.success) {
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"设置失败, result is %@", result);
                    [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                }
            });
        }];
    }
}

#pragma mark - Private method
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
