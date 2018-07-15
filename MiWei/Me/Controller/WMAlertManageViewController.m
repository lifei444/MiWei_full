//
//  WMAlertManageViewController.m
//  MiWei
//
//  Created by LiFei on 2018/6/17.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMAlertManageViewController.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMAlertManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WMAlertManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警管理";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(-35,0,0,0);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    UISwitch *sw = [[UISwitch alloc] init];
    sw.onTintColor = [WMUIUtility color:@"0x2b928a"];
    [sw addTarget:self action:@selector(onClickSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    
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
    return 50;
}

#pragma mark - Target action
- (void)onClickSwitch:(UISwitch *)switchButton {
    
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 5;
    }
    return _tableView;
}

@end
