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
#import "WMHTTPUtility.h"
#import "WMDeviceRentPriceCell.h"
#import "WMDevicePayResponse.h"
#import <WXApi.h>

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
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPayResp:)
                                                 name:WMWechatPayNotification
                                               object:nil];
}

#pragma mark - Target action
- (void)onPayResp:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL result = [notification.object boolValue];
        if (result) {
            [WMUIUtility showAlertWithMessage:@"支付成功" viewController:self];
//            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [WMUIUtility showAlertWithMessage:@"支付失败" viewController:self];
        }
    });
}

- (void)buy {
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.deviceId forKey:@"deviceID"];
    [dic setObject:self.rentInfoForPay.rentPrices[index.row].priceId forKey:@"rentPriceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/wetchat/requestPay"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSDictionary *content = result.content;
                                        WMDevicePayResponse *resp = [WMDevicePayResponse payResponseWithDic:content];
                                        PayReq *request = [[PayReq alloc] init];
                                        request.partnerId = resp.partnerId;
                                        request.prepayId = resp.prepayId;
                                        request.package = @"Sign=WXPay";
                                        request.nonceStr = resp.nonceStr;
                                        request.timeStamp = [resp.timeStamp intValue];
                                        request.sign = resp.sign;
                                        [WXApi sendReq:request];
                                    } else {
                                        NSLog(@"/mobile/wetchat/requestPay error, result is %@", result);
                                    }
                                }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rentInfoForPay.rentPrices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceRentPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentPriceCell"];
    [cell setDataModel:self.rentInfoForPay.rentPrices[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0 && [tableView indexPathForSelectedRow] == nil) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [cell refreshSelectState:YES];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMDeviceRentPriceCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:Header_Height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    long long lastRentStartTime = [self.rentInfoForPay.rentStartTime longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:lastRentStartTime/1000];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    long year = [dateComponent year];
    long month = [dateComponent month];
    long day = [dateComponent day];
    self.bgView.lastUseLabel.text = [NSString stringWithFormat:@"上次使用时间%ld年%02ld月%02ld日", year, month, day];
    self.bgView.totalLabel.text = [NSString stringWithFormat:@"机器开启前PM2.5数值为%d毫克每立方，使用时间%d分钟，累计去除%d毫克PM2.5。", [self.rentInfoForPay.rentStartPM25 intValue], [self.rentInfoForPay.rentTime intValue], [self.rentInfoForPay.deconAmount intValue]];
    self.bgView.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%d", [self.rentInfoForPay.pm25 intValue]];
    self.bgView.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%d", [self.rentInfoForPay.outdoorPM25 intValue]];
    return self.bgView;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    WMDeviceRentPriceCell *oldCell = [tableView cellForRowAtIndexPath:oldIndex];
    [oldCell refreshSelectState:NO];
    WMDeviceRentPriceCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    [newCell refreshSelectState:YES];
    
    return indexPath;
}

#pragma mark - Private method
- (void)loadData {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", nil];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryRentDeviceInfo"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        self.rentInfoForPay = [WMDeviceRentInfoForPay rentInfoForPayWithDic:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"queryRentDeviceInfo error, result is %@", result);
                                    }
                                }];
}

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WMDeviceRentPriceCell class] forCellReuseIdentifier:@"rentPriceCell"];
//        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (WMDevicePayBGView *)bgView {
    if (!_bgView) {
        _bgView = [[WMDevicePayBGView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Header_Height)];
    }
    return _bgView;
}
@end
