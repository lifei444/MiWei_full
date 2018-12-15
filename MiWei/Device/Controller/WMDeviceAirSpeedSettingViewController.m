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
    [self setRightNavBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = [WMDeviceUtility descriptionOfAirSpeed:indexPath.row];
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
    if (selectIndex.row == self.speed) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegage respondsToSelector:@selector(onAirSpeedConfirm:)]) {
            [self.delegage onAirSpeedConfirm:selectIndex.row];
        }
    }
}

#pragma mark - Private method
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[WMUIUtility color:@"0x6a6a6a"] forState:UIControlStateNormal];
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
