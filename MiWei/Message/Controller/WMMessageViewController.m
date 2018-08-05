//
//  WMWeatherViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageViewController.h"
#import "WMMessageCell.h"
#import "WMCityViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMMessage.h"
#import "WMMessageFactory.h"

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
    
    [self.view addSubview:self.tableView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMessageCell *cell = [WMMessageCell cellWithTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMMessageCell cellHeight];
}

#pragma mark - Target action

#pragma mark - Getters & setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
