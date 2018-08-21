//
//  WMFeedBackChooseQuestionViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/21.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMFeedBackChooseQuestionViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

@interface WMFeedBackChooseQuestionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <WMFeedBackQuestion *> *questionArray;
@end

@implementation WMFeedBackChooseQuestionViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择问题";
    [self.view addSubview:self.tableView];
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.questionArray[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMUIUtility WMCGFloatForY:50];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(onQuestionSelect:)]) {
        [self.delegate onQuestionSelect:self.questionArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private method
- (void)loadData {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/user/queryIssueCategory"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *arr = result.content;
                                        NSMutableArray *questionArray = [[NSMutableArray alloc] init];
                                        for (NSDictionary *dic in arr) {
                                            WMFeedBackQuestion *question = [WMFeedBackQuestion questionWithDic:dic];
                                            [questionArray addObject:question];
                                        }
                                        self.questionArray = questionArray;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.tableView reloadData];
                                        });
                                    } else {
                                        NSLog(@"/mobile/user/queryIssueCategory error, result is %@", result);
                                    }
                                }];
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
