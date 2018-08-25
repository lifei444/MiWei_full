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
#import "WMOrderListCell.h"
#import "WMHTTPUtility.h"
#import "WMPayment.h"
#import "UITableView+EmptyData.h"

@interface WMOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation WMOrderListViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单中心";
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[WMOrderListCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(-35,0,0,0);
}

#pragma mark - Private method
- (void)loadData {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/user/queryPaymentHistory"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSDictionary *content = result.content;
                                        NSArray *payments = content[@"payments"];
                                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                                        for (NSDictionary *dic in payments) {
                                            WMPayment *payment = [[WMPayment alloc] init];
                                            payment.deviceId = dic[@"deviceID"];
                                            payment.deviceName = dic[@"deviceName"];
                                            payment.payTime = dic[@"payTime"];
                                            payment.price = dic[@"price"];
                                            payment.rentTime = dic[@"rentTime"];
                                            [arr addObject:payment];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = arr;
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"订单中心 loadData error, result is %@", result);
                                    }
                                }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.modelArray.count];
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setDataModel:self.modelArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMOrderListCell cellHeight];
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
