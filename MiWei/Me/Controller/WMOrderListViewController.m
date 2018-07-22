//
//  WMOrderListViewController.m
//  MiWei
//
//  Created by LiFei on 2018/7/15.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMOrderListViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WMOrderListViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单中心";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(-35,0,0,0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if(indexPath.section == 0) {
        cell.textLabel.text = @"Amy的设备报警";
        //        cell.imageView.image = [UIImage imageNamed:@"person_portrait"];
    }else if(indexPath.section == 1) {
        cell.textLabel.text = @"momo的设备报警";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.sectionHeaderHeight = 0;
//        _tableView.sectionFooterHeight = 5;
    }
    return _tableView;
}
@end
