//
//  WMDeviceAddViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/20.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceAddViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMDeviceAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *keyArr;
@property (nonatomic,strong) NSArray *valueArr;
@end

@implementation WMDeviceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.keyArr = @[@"IMEI/MAC",@"设备名称",@"设备类型",@"设备型号"];
    self.valueArr = @[@"MAC",@"小明的设备",@"净化器",@"M229"];
    [self.view addSubview:self.tableview];
}

- (void)addEvent {
    NSLog(@"%s",__func__);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.keyArr[indexPath.row];
    cell.detailTextLabel.text = self.valueArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, self.view.bounds.size.width, 250)];
    imageView.backgroundColor = [UIColor greenColor];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 200)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(20, 150, Screen_Width-40, 44)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
 }

- (UITableView *)tableview {
    if(!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
