//
//  WMDeviceSearchViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/12.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceSearchViewController.h"
#import "WMUIUtility.h"
#import "WMDevice.h"
#import "WMDeviceCell.h"
#import "WMCommonDefine.h"
#import "WMRentDeviceDetailViewController.h"
#import "WMSellDeviceDetailViewController.h"
#import "WMHTTPUtility.h"
#import "WMDeviceUtility.h"
#import "WMSearchBar.h"

#define SearchBarX                  8
#define SearchBarY                  (IsiPhoneX ? 44 : 20)//20//(Navi_Height + 7)
#define SearchBarWidth              359
#define SearchBarHeight             40

#define GapYBetweenSearchAndContent 7
#define CollectionX                 SearchBarX
#define CollectionY                 (SearchBarY + SearchBarHeight + GapYBetweenSearchAndContent)
#define CollectionWidth             SearchBarWidth
#define CollectionHeight            (IsiPhoneX ? 670 : 590)//590//TODO

#define EdgeGap                     8
#define CellWidth                   176
#define CellHeight                  239

#define GapXBetweenCell             7

static NSString *deviceCellIdentifier = @"WMDeviceCell";

@interface WMDeviceSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WMSearchBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WMSearchBar *searchBar;
@property (nonatomic, strong) NSTimer *countDownTimer;
@end

@implementation WMDeviceSearchViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self startCountDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    WMDevice *device = self.modelArray[indexPath.item];
    
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

#pragma mark - WMSearchBarDelegate
- (void)onCancel {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)onSearch:(NSString *)value {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:value forKey:@"deviceName"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"mobile/device/list"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *tempArray = [WMDeviceUtility deviceListFromJson:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = tempArray;
                                            [self.collectionView reloadData];
                                        });
                                    } else {
                                        NSLog(@"onSearch error, result is %@", result);
                                    }
                                }];
}

#pragma mark - Target action
- (void)onCountDownTimer {
    [[NSNotificationCenter defaultCenter] postNotificationName:WMDeviceListCountDownNotification object:nil];
}

#pragma mark - Private
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
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:WM_CGRectMake(CollectionX, CollectionY, CollectionWidth, CollectionHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
        [_collectionView registerClass:[WMDeviceCell class] forCellWithReuseIdentifier:deviceCellIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (WMSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[WMSearchBar alloc] initWithFrame:WM_CGRectMake(SearchBarX, SearchBarY, SearchBarWidth, SearchBarHeight)];
        [_searchBar showCancel];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

@end
