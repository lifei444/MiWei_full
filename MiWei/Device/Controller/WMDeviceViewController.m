//
//  WMDeviceViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceViewController.h"
#import "WMDeviceCell.h"
#import "WMScanViewController.h"
#import "WMSellDeviceDetailViewController.h"
#import "WMRentDeviceDetailViewController.h"
#import "WMDevice.h"
#import "WMDeviceCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMHTTPUtility.h"
#import "WMDeviceUtility.h"
#import "WMDeviceSearchViewController.h"
#import "WMSearchBar.h"
#import "WMNavigationViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"

static NSString *deviceCellIdentifier = @"WMDeviceCell";
static NSString *headerIdentifier = @"headerIdentifier";
NSString *const WMDeviceListCountDownNotification = @"WMDeviceListCountDownNotification";

#define SearchBarX                  8
#define SearchBarY                  (Navi_Height + 7)
#define SearchBarWidth              359
#define SearchBarHeight             40

#define GapYBetweenSearchAndContent 7
#define CollectionX                 SearchBarX
#define CollectionY                 (SearchBarY + SearchBarHeight + GapYBetweenSearchAndContent)
#define CollectionWidth             SearchBarWidth
#define CollectionHeight            (IsiPhoneX ? 580 : 500)//500//TODO

#define EdgeGap                     8
#define CellWidth                   176
#define CellHeight                  239

#define GapXBetweenCell             7

@interface WMDeviceViewController ()<WMSearchBarDelegate>
@property (nonatomic, strong) NSArray <WMDevice *> *modelArray;
@property (nonatomic, strong) WMSearchBar *searchBar;
@property (nonatomic, strong) NSTimer *countDownTimer;
@end

@implementation WMDeviceViewController

#pragma mark - Life cycle
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[WMUIUtility color:@"0x444444"], NSForegroundColorAttributeName, [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:17]], NSFontAttributeName, nil];
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
        self.navigationItem.title = @"设备列表";
        self.view.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavBar];
    [self.view addSubview:self.searchBar];
    self.collectionView.frame = WM_CGRectMake(CollectionX, CollectionY, CollectionWidth, CollectionHeight);
    self.collectionView.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    [self.collectionView registerClass:[WMDeviceCell class] forCellWithReuseIdentifier:deviceCellIdentifier];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDeviceList];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDevices];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.collectionView.mj_footer = footer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDeviceList];
    [self startCountDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopCountDown];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return WM_CGSizeMake(CellWidth, CellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GapXBetweenCell;
}

////设置每一个Cell的垂直和水平间距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if (section % 2 == 0) {
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    } else {
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceCellIdentifier forIndexPath:indexPath];
    cell.vc = self;
    [cell setDataModel:self.modelArray[indexPath.item]];
    return (UICollectionViewCell *)cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDevice *device;
    device = self.modelArray[indexPath.item];
    if ([device isRentDevice]) {
        WMRentDeviceDetailViewController *vc = [[WMRentDeviceDetailViewController alloc] init];
        vc.device = device;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WMSellDeviceDetailViewController *vc = [[WMSellDeviceDetailViewController alloc] init];
        vc.device = device;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)onClick {
    [self.searchBar resignFirstResponder];
    WMDeviceSearchViewController *vc = [[WMDeviceSearchViewController alloc] init];
    vc.modelArray = self.modelArray;
    WMNavigationViewController *nav = [[WMNavigationViewController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

#pragma mark - Target action
- (void)scan:(UIButton *)btn {
    WMScanViewController *vc = [[WMScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onCountDownTimer {
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceListCountDownNotification object:nil];
}

#pragma mark - Private
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 32, 32)];
    [btn setImage:[UIImage imageNamed:@"device_scan"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)loadDeviceList {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"mobile/device/list"
                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:@(30), @"limit", nil]
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *tempArray = [WMDeviceUtility deviceListFromJson:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = tempArray;
                                            [self.collectionView.mj_header endRefreshing];
                                            [self.collectionView reloadData];
                                        });
                                    } else {
                                        NSLog(@"loadDeviceList error, result is %@", result);
                                    }
                                }];
}

- (void)loadMoreDevices {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"mobile/device/list"
                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:@(30), @"limit", @(self.modelArray.count), @"offset", nil]
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                        [tempArray addObjectsFromArray:self.modelArray];
                                        [tempArray addObjectsFromArray:[WMDeviceUtility deviceListFromJson:result.content]];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = tempArray;
                                            [self.collectionView.mj_footer endRefreshing];
                                            [self.collectionView reloadData];
                                        });
                                    } else {
                                        NSLog(@"loadDeviceList error, result is %@", result);
                                    }
                                }];
}

- (void)startCountDown {
    [self stopCountDown];
    self.countDownTimer = [NSTimer timerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(onCountDownTimer)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)stopCountDown {
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

#pragma mark - Getters & setters
- (NSArray<WMDevice *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc] init];
    }
    return _modelArray;
}

- (WMSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[WMSearchBar alloc] initWithFrame:WM_CGRectMake(SearchBarX, SearchBarY, SearchBarWidth, SearchBarHeight)];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

@end
