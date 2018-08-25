//
//  WMWeatherViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMCommonDefine.h"
#import "WMMessage.h"
#import "WMMessageFactory.h"
#import "WMStrainerAlarmMessageCell.h"
#import "WMDevShareNotiMessageCell.h"
#import "WMAirQualityNotiMessageCell.h"
#import "UITableView+EmptyData.h"

#define Section_Gap 22
NSString *const strainerAlarmIdentifier = @"strainerAlarm";
NSString *const devShareNotiIdentifier = @"devShareNoti";
NSString *const airQualityNotiIdentifier = @"airQualityNoti";

@interface WMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <WMMessage *> *modelArray;
@end

@implementation WMMessageViewController
#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"消息中心";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[WMUIUtility color:@"0x444444"], NSForegroundColorAttributeName, [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:17]], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[WMStrainerAlarmMessageCell class] forCellReuseIdentifier:strainerAlarmIdentifier];
    [self.tableView registerClass:[WMDevShareNotiMessageCell class] forCellReuseIdentifier:devShareNotiIdentifier];
    [self.tableView registerClass:[WMAirQualityNotiMessageCell class] forCellReuseIdentifier:airQualityNotiIdentifier];
    [self loadMessages];
}

#pragma mark - Private method
- (void)loadMessages {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/message/list"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                        NSDictionary *content = result.content;
                                        NSArray *messages = content[@"messages"];
                                        for (NSDictionary *dic in messages) {
                                            WMMessage *message = [WMMessageFactory getMessageFromJson:dic];
                                            if (message) {
                                                [tempArray addObject:message];
                                            }
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = tempArray;
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"loadMessages error %@", result);
                                    }
                                }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [tableView tableViewDisplayWitMsg:@"设备运行良好，暂无消息" ifNecessaryForRowCount:self.modelArray.count];
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMessage *message = self.modelArray[indexPath.section];
    UITableViewCell *cell;
    switch (message.type) {
        case WMMessageTypeStrainerAlarm: {
            cell = [tableView dequeueReusableCellWithIdentifier:strainerAlarmIdentifier];
            [(WMStrainerAlarmMessageCell *)cell setDataModel:message];
            break;
        }
            
        case WMMessageTypeDevShareNoti: {
            cell = [tableView dequeueReusableCellWithIdentifier:devShareNotiIdentifier];
            WMDevShareNotiMessageCell *shareCell = (WMDevShareNotiMessageCell *)cell;
            [shareCell setDataModel:message];
            shareCell.vc = self;
            break;
        }
            
        case WMMessageTypeAirQualityNoti: {
            cell = [tableView dequeueReusableCellWithIdentifier:airQualityNotiIdentifier];
            [(WMAirQualityNotiMessageCell *)cell setDataModel:message];
            break;
        }
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMessage *message = self.modelArray[indexPath.section];
    CGFloat cellHeight;
    switch (message.type) {
        case WMMessageTypeStrainerAlarm: {
            cellHeight = [WMStrainerAlarmMessageCell cellHeight];
            break;
        }
            
        case WMMessageTypeDevShareNoti: {
            cellHeight = [WMDevShareNotiMessageCell cellHeight];
            break;
        }
            
        case WMMessageTypeAirQualityNoti: {
            cellHeight = [WMAirQualityNotiMessageCell cellHeight];
            break;
        }
            
        default:
            break;
    }
    
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.modelArray.count - 1) {
        return [WMUIUtility WMCGFloatForY:Section_Gap];
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 0)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [WMUIUtility WMCGFloatForY:Section_Gap];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, Section_Gap)];
    return view;
}

#pragma mark - Target action

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray<WMMessage *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc] init];
    }
    return _modelArray;
}

@end
