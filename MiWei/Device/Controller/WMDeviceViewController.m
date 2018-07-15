//
//  WMDeviceViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceViewController.h"
#import "WMDeviceCell.h"
#import "WMPayRecordViewController.h"
#import "WMDeviceConfigViewController.h"
#import "WMScanViewController.h"
#import "WMDeviceInfoViewController.h"
#import "WMDeviceModel.h"
#import "WMDeviceCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

static NSString *deviceCellIdentifier = @"WMDeviceCell";

#define SearchBarX                  8
#define SearchBarY                  (Navi_Height + 7)
#define SearchBarWidth              359
#define SearchBarHeight             40

#define GapYBetweenSearchAndContent 7
#define CollectionX                 SearchBarX
#define CollectionY                 (SearchBarY + SearchBarHeight + GapYBetweenSearchAndContent)
#define CollectionWidth             SearchBarWidth
#define CollectionHeight            600//TODO

#define EdgeGap                     8
#define CellWidth                   176
#define CellHeight                  239

#define GapXBetweenCell             7

@interface WMDeviceViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray <WMDeviceModel *> *modelArray;
@end

@implementation WMDeviceViewController

#pragma mark - Life cycle
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"设备";
        self.navigationItem.title = @"设备列表";
        self.view.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavBar];
    //TODO
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.frame = WM_CGRectMake(SearchBarX, SearchBarY, SearchBarWidth, SearchBarHeight);
    
    
    [self.view addSubview:self.searchController.searchBar];
    
    self.collectionView.frame = WM_CGRectMake(CollectionX, CollectionY, CollectionWidth, CollectionHeight);
    [self.collectionView registerClass:[WMDeviceCell class] forCellWithReuseIdentifier:deviceCellIdentifier];
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
    if (!cell) {
        cell = [[WMDeviceCell alloc] init];
    }
    [cell setDataModel:self.modelArray[indexPath.item]];
    return (UICollectionViewCell *)cell;
}

#pragma mark - Target action
- (void)scan:(UIButton *)btn {
    WMScanViewController *vc = [[WMScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 32, 32)];
    [btn setImage:[UIImage imageNamed:@"device_scan"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Getters & setters
- (NSMutableArray<WMDeviceModel *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
        
        //TODO delete
        for (int i=0; i<10; i++) {
            WMDeviceModel *model = [[WMDeviceModel alloc] init];
            [_modelArray addObject:model];
        }
    }
    return _modelArray;
}

@end
