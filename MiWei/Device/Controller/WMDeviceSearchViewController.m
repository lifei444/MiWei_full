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

#define SearchBarX                  8
#define SearchBarY                  (Navi_Height + 7)
#define SearchBarWidth              359
#define SearchBarHeight             40

#define GapYBetweenSearchAndContent 7
#define CollectionX                 SearchBarX
#define CollectionY                 (SearchBarY + SearchBarHeight + GapYBetweenSearchAndContent)
#define CollectionWidth             SearchBarWidth
#define CollectionHeight            550//TODO

#define EdgeGap                     8
#define CellWidth                   176
#define CellHeight                  239

#define GapXBetweenCell             7

static NSString *deviceCellIdentifier = @"WMDeviceCell";

@interface WMDeviceSearchViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation WMDeviceSearchViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    
    self.collectionView.frame = WM_CGRectMake(CollectionX, CollectionY-140, CollectionWidth, CollectionHeight);
    self.collectionView.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    [self.collectionView registerClass:[WMDeviceCell class] forCellWithReuseIdentifier:deviceCellIdentifier];
    [self.view addSubview:self.collectionView];
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
    return self.searchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceCellIdentifier forIndexPath:indexPath];
    [cell setDataModel:self.searchArray[indexPath.item]];
    return (UICollectionViewCell *)cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDevice *device = self.searchArray[indexPath.item];
    
    if (device.rentInfo) {
        WMRentDeviceDetailViewController *vc = [[WMRentDeviceDetailViewController alloc] init];
        vc.device = device;
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    } else {
        WMSellDeviceDetailViewController *vc = [[WMSellDeviceDetailViewController alloc] init];
        vc.device = device;
        [self.presentingViewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getters & setters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (void)setSearchArray:(NSArray *)searchArray {
    _searchArray = searchArray;
    [self.collectionView reloadData];
}

@end
