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
#import <FogV3/FogV3.h>
#import "WMDeviceConfigViewController.h"
#import "WMDeviceUtility.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "WMHTTPUtility.h"
#import "WMDeviceViewController.h"
#import "WMDevicePayViewController.h"

#define Header_Height   227
#define Footer_Height   44
#define Footer_Gap      46
#define Button_X        10
#define Cell_Height     59

@interface WMDeviceAddViewController ()<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coord;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation WMDeviceAddViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加设备";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mapView];
    [self requestLocationAuth];
}

#pragma mark - Target action
- (void)addEvent:(UIButton *)button {
    NSString *ssid = [[FogEasyLinkManager sharedInstance] getSSID];
    NSLog(@"WMDeviceAddViewController addEvent ssid is %@", ssid);
    if ([self.device isRentDevice]) {
        if (!self.device.online) {
            [WMUIUtility showAlertWithMessage:@"设备不在线，无法添加" viewController:self];
        } else {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [WMDeviceUtility addDevice:self.device.deviceId
                              location:self.coord
                                  ssid:ssid
                              complete:^(BOOL result) {
                                  [self.hud hideAnimated:YES];
                                  if (result) {
                                      WMDevicePayViewController *vc = [[WMDevicePayViewController alloc] init];
                                      vc.deviceId = self.device.deviceId;
                                      [self.navigationController pushViewController:vc animated:YES];
                                  } else {
                                      [WMUIUtility showAlertWithMessage:@"添加失败" viewController:self];
                                  }
                              }];
        }
    } else { //销售设备
        if (self.device.online) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [WMDeviceUtility addDevice:self.device.deviceId
                              location:self.coord
                                  ssid:ssid
                              complete:^(BOOL result) {
                                  [self.hud hideAnimated:YES];
                                  if (result) {
                                      for (UIViewController *controller in self.navigationController.viewControllers) {
                                          if ([controller isKindOfClass:[WMDeviceViewController class]]) {
                                              WMDeviceViewController *vc = (WMDeviceViewController *)controller;
                                              [self.navigationController popToViewController:vc animated:YES];
                                              break;
                                          }
                                      }
                                  } else {
                                      [WMUIUtility showAlertWithMessage:@"添加失败" viewController:self];
                                  }
                              }];
        } else {
            if (self.device.deviceOwnerExist) {
                [WMUIUtility showAlertWithMessage:@"设备不在线，无法添加" viewController:self];
            } else {
                WMDeviceConfigViewController *vc = [[WMDeviceConfigViewController alloc] init];
                vc.ssid = ssid;
                vc.deviceId = self.device.deviceId;
                vc.coord = self.coord;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.coord = [userLocation coordinate];
    [self.mapView setShowsUserLocation:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return [WMUIUtility WMCGFloatForY:Cell_Height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:Header_Height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Header_Height)];
    NSURL *imageUrl = [WMHTTPUtility urlWithPortraitId:self.device.model.image];
    [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"device_add_placehold"]];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:(Footer_Height + Footer_Gap)];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Footer_Height + Footer_Gap)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(Button_X, Footer_Gap, Screen_Width - Button_X * 2, Footer_Height)];
    btn.backgroundColor = [WMUIUtility color:@"0x2b938b"];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    [view addSubview:btn];
    view.userInteractionEnabled = YES;
    
    return view;
 }

#pragma mark - Private method
- (void)requestLocationAuth {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //判断当前设备定位服务是否打开
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"设备尚未打开定位服务");
        }
        
        //判断当前设备版本大于iOS8以后的话执行里面的方法
        if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
            //当用户使用的时候授权
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager requestWhenInUseAuthorization];
        }
//    });
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
        _mapView.hidden = YES;
    }
    return _mapView;
}

@end
