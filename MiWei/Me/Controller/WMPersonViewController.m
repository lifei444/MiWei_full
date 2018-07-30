//
//  WMPersonViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMPersonViewController.h"
#import "WMMeAddressViewController.h"
#import "WMMeNameViewController.h"
#import "WMMeIconViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

@interface WMPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WMPersonViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
//        cell.imageView.image = [UIImage imageNamed:@"person_portrait"];
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text= [WMHTTPUtility currentProfile].nickname;
    } else {
        cell.textLabel.text = @"地址";
        cell.detailTextLabel.text= [WMHTTPUtility currentProfile].addrDetail;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [WMUIUtility WMCGFloatForY:80];
    } else {
        return [WMUIUtility WMCGFloatForY:50];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        WMMeIconViewController *vc = [[WMMeIconViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1){
        WMMeNameViewController *vc = [[WMMeNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        WMMeAddressViewController *vc = [[WMMeAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
