//
//  WMDeviceRepetitionViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceRepetitionViewController.h"
#import "WMUIUtility.h"
#import "WMDeviceUtility.h"

@interface WMDeviceRepetitionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WMDeviceRepetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重复";
    [self setRightNavBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"每周一";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"每周二";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"每周三";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"每周四";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"每周五";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"每周六";
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"每周日";
    }
    for (NSNumber *value in [WMDeviceUtility generateWeekDayArray:self.repetition]) {
        if ([value intValue] == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    cell.tintColor = [WMUIUtility color:@"0x2b928a"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return indexPath;
}

#pragma mark - Target action
- (void)onConfirm {
    NSArray *arr = [self.tableView indexPathsForSelectedRows];
    int result = 0;
    for (NSIndexPath *ip in arr) {
        int bit = 0x01 << ip.row;
        result = result | bit;
    }
    if ([self.delegate respondsToSelector:@selector(onRepetitionConfirm:)]) {
        [self.delegate onRepetitionConfirm:@(result)];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
        _tableView.allowsMultipleSelection = YES;
        //加了 footer 后下面就没有空白横线了
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
