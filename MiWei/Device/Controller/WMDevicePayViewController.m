//
//  WMDevicePayViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePayViewController.h"
#import "WMDevicePayBGView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMDeviceRentInfoForPay.h"

#define Header_Height   360
#define Footer_Height   50
#define Footer_Gap      46
#define Button_X        10
#define Cell_Height     59

@interface WMDevicePayViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WMDevicePayBGView *bgView;
@property (nonatomic, strong) WMDeviceRentInfoForPay *rentInfoForPay;
@end

@implementation WMDevicePayViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"支付";
}

#pragma mark - Target action
- (void)buy {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rentInfoForPay.rentPrices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    //TODO
//    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"IMEI/MAC";
//            cell.detailTextLabel.text = self.device.deviceId;
//            break;
//
//        case 1:
//            cell.textLabel.text = @"设备名称";
//            cell.detailTextLabel.text = self.device.name;
//            break;
//
//        case 2:
//            cell.textLabel.text = @"设备类型";
//            cell.detailTextLabel.text = self.device.prod.name;
//            break;
//
//        case 3:
//            cell.textLabel.text = @"设备型号";
//            cell.detailTextLabel.text = self.device.model.name;
//            break;
//
//        default:
//            break;
//    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:Cell_Height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:Header_Height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WMDevicePayBGView *bgView = [[WMDevicePayBGView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Header_Height)];
    self.bgView = bgView;
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:(Footer_Height + Footer_Gap)];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Footer_Height + Footer_Gap)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(Button_X, Footer_Gap, Screen_Width - Button_X * 2, Footer_Height)];
    btn.backgroundColor = [WMUIUtility color:@"0x2b938b"];
    [btn setTitle:@"购买" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    view.userInteractionEnabled = YES;
    
    return view;
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
@end
