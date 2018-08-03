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
#import "UIImageView+WebCache.h"
#import "WMHTTPUtility.h"

#define Header_Height   227
#define Footer_Height   44
#define Footer_Gap      46
#define Button_X        10
#define Cell_Height     59

@interface WMDeviceAddViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@end

@implementation WMDeviceAddViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableview];
}

#pragma mark - Target action
- (void)addEvent {
    NSLog(@"%s",__func__);
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"IMEI/MAC";
            cell.detailTextLabel.text = self.device.deviceId;
            break;
            
        case 1:
            cell.textLabel.text = @"设备名称";
            cell.detailTextLabel.text = self.device.name;
            break;
            
        case 2:
            cell.textLabel.text = @"设备类型";
            cell.detailTextLabel.text = self.device.prod.name;
            break;
            
        case 3:
            cell.textLabel.text = @"设备型号";
            cell.detailTextLabel.text = self.device.model.name;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Header_Height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, self.view.bounds.size.width, Header_Height)];
    NSURL *imageUrl = [WMHTTPUtility urlWithPortraitId:self.device.model.image];
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"device_add_placehold"]];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return Footer_Height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Footer_Height + Footer_Gap)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(Button_X, Footer_Gap, Screen_Width - Button_X * 2, Footer_Height)];
    btn.backgroundColor = [WMUIUtility color:@"0x2b938b"];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    
    return view;
 }

#pragma mark - Getters & setters
- (UITableView *)tableview {
    if(!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
