//
//  WMMeViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeViewController.h"
#import "WMMeCell.h"
#import "WMMeHeaderView.h"
#import "WMPersonViewController.h"
#import "WMMeAddressViewController.h"
#import "WMFeedBackViewController.h"
#import "WMCommonDefine.h"
#import "WMAlertManageViewController.h"
#import "WMUIUtility.h"
#import "WMOrderListViewController.h"
#import "WMHTTPUtility.h"
#import "WMKeychainUtility.h"
#import "WMLoginViewController.h"
#import "WMNavigationViewController.h"
#import <UMPush/UMessage.h>
#import "WMModifyPasswordViewController.h"
#import "WMAboutViewController.h"

#define kheight 269

@interface WMMeViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *imageNames;
@property (nonatomic,strong) WMMeHeaderView *headerView;
@property (nonatomic, strong) UIImageView *settingImageView;
@end

@implementation WMMeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"个人";
        self.navigationItem.title = @"个人设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.settingImageView];
    [self.view addSubview:self.tableView];
    self.titles = @[@"修改密码", @"订单中心", @"报警管理", @"意见反馈"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(portraitDidUpdate:)
                                                 name:@"WMPortraitUpdate"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(-35,0,0,0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 4;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMMeCell *cell = [WMMeCell cellWithTableView:tableView];
    if(indexPath.section == 0) {
        cell.label.text = self.titles[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.iconImageView.image = [UIImage imageNamed:@"me_password"];
                break;
            case 1:
                cell.iconImageView.image = [UIImage imageNamed:@"me_order"];
                break;
            case 2:
                cell.iconImageView.image = [UIImage imageNamed:@"me_alert"];
                break;
            case 3:
                cell.iconImageView.image = [UIImage imageNamed:@"me_response"];
                break;
            default:
                break;
        }
    } else if(indexPath.section == 1) {
        cell.label.text = @"关于米微";
        cell.iconImageView.image = [UIImage imageNamed:@"me_about"];
    } else {
        cell.label.text = @"退出";
        cell.iconImageView.image = [UIImage imageNamed:@"me_exit"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            NSLog(@"修改密码");
            WMModifyPasswordViewController *vc = [[WMModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 1) {
            WMOrderListViewController *vc =[[WMOrderListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 2) {
            WMAlertManageViewController *vc = [[WMAlertManageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 3) {
            WMFeedBackViewController *vc = [[WMFeedBackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if(indexPath.section == 1) {
        WMAboutViewController *vc = [[WMAboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确认退出登录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WMMeCell cellHeight];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self logout];
    }
}

#pragma mark - Target action
- (void)setting {
    WMPersonViewController *vc = [[WMPersonViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)portraitDidUpdate:(NSNotification *)notification {
    [self.headerView updatePortrait];
}

#pragma mark - Private methods
- (void)logout {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/user/logout"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
//                                        [WMKeychainUtility removeWMDataForKey:@"WMPswKey"];
                                        [UMessage removeAlias:[[WMHTTPUtility currentProfile].profileId stringValue]
                                                         type:@"miiot_push"
                                                     response:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                                     }];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            WMLoginViewController *loginVC = [[WMLoginViewController alloc] init];
                                            WMNavigationViewController *nav = [[WMNavigationViewController alloc] initWithRootViewController:loginVC];
                                            self.view.window.rootViewController = nav;
                                        });
                                    } else {
                                        NSLog(@"logout error %@", result);
                                    }
                                }];
}

#pragma mark - Getters and setters
- (WMMeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WMMeHeaderView headerView];
    }
    return _headerView;
}

- (UIImageView *)settingImageView {
    if (!_settingImageView) {
        CGRect rect = WM_CGRectMake(Screen_Width-15-20, 37, 20, 19);
        _settingImageView = [[UIImageView alloc] initWithFrame:rect];
        _settingImageView.image = [UIImage imageNamed:@"me_setting"];
        _settingImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setting)];
        [_settingImageView addGestureRecognizer:recognizer];
    }
    return _settingImageView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:WM_CGRectMake(0, kheight, Screen_Width, Screen_Height - kheight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 8;
    }
    return _tableView;
}

@end
