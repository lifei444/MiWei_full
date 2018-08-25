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
#import "WMHTTPUtility.h"
#import "WMAlarmSetting.h"
#import "MBProgressHUD.h"
#import "UITableView+EmptyData.h"

@interface WMAlertManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMAlertManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警管理";
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(-35,0,0,0);
}

#pragma mark - Private method
- (void)loadData {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/user/queryAlarmSettings"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *content = result.content;
                                        NSMutableArray *arr = [[NSMutableArray alloc] init];
                                        for (NSDictionary *dic in content) {
                                            WMAlarmSetting *setting = [[WMAlarmSetting alloc] init];
                                            setting.deviceId = dic[@"deviceID"];
                                            setting.name = dic[@"deviceName"];
                                            setting.enable = [dic[@"alarmEnable"] boolValue];
                                            [arr addObject:setting];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = arr;
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"报警管理 loadData error, result is %@", result);
                                    }
                                }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.modelArray.count];
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
    cell.textLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
    WMAlarmSetting *setting = self.modelArray[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@报警", setting.name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *sw = [[UISwitch alloc] init];
    sw.onTintColor = [WMUIUtility color:@"0x2b928a"];
    sw.tag = indexPath.section;
    [sw addTarget:self action:@selector(onClickSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}


#pragma mark - Target action
- (void)onClickSwitch:(UISwitch *)switchButton {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    WMAlarmSetting *setting = self.modelArray[switchButton.tag];
    [dic setObject:setting.deviceId forKey:@"deviceID"];
    [dic setObject:@(switchButton.on) forKey:@"alarmEnable"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:dic];
    [WMHTTPUtility jsonRequestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/user/setAlarmSettings"
                              parameters:array
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            [WMUIUtility showAlertWithMessage:@"设置成功" viewController:self];
                                        } else {
                                            NSLog(@"/mobile/user/setAlarmSettings error, result is %@", result);
                                            [WMUIUtility showAlertWithMessage:@"设置失败" viewController:self];
                                        }
                                    });
                                }];
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

- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc] init];
    }
    return _modelArray;
}

@end
