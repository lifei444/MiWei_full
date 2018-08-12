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

static NSString *deviceCellIdentifier = @"WMDeviceCell";

#define SearchBarX                  8
#define SearchBarY                  7//(Navi_Height + 7)
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

@interface WMDeviceViewController () <UISearchResultsUpdating, UISearchResultsUpdating, UISearchControllerDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) WMDeviceSearchViewController *deviceSearchViewController;
@property (nonatomic, strong) NSArray <WMDevice *> *modelArray;
@property (nonatomic, strong) NSArray <WMDevice *> *searchArray;
@end

@implementation WMDeviceViewController

#pragma mark - Life cycle
- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"设备列表";
        self.view.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightNavBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.deviceSearchViewController = [[WMDeviceSearchViewController alloc] init];
    self.deviceSearchViewController.view.frame = WM_CGRectMake(0, Navi_Height, Screen_Width, 550);
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.deviceSearchViewController];
    self.definesPresentationContext = YES;
    self.searchController.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
//    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    UIImage *img = [self getImageWithColor:[UIColor clearColor] andHeight:32];
    [self.searchController.searchBar setBackgroundImage:img];
    
    
    
//    self.searchController.searchBar.barTintColor = [WMUIUtility color:@"0xf6f6f6"];
//    self.searchController.searchBar.frame = WM_CGRectMake(SearchBarX, SearchBarY, SearchBarWidth, SearchBarHeight);//CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, 375, 44);
    
//    self.searchController.delegate = self;
    [self.view addSubview:self.searchController.searchBar];
    
    //更新代理
    self.searchController.searchResultsUpdater = self;
    //搜索结果不变灰
    
    self.collectionView.frame = WM_CGRectMake(CollectionX, CollectionY, CollectionWidth, CollectionHeight);
    self.collectionView.backgroundColor = [WMUIUtility color:@"0xf6f6f6"];
    [self.collectionView registerClass:[WMDeviceCell class] forCellWithReuseIdentifier:deviceCellIdentifier];
    
    [self loadDeviceList];
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
//    if (self.searchController.active) {
//        return self.searchArray.count;
//    } else {
//        return self.modelArray.count;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:deviceCellIdentifier forIndexPath:indexPath];
    [cell setDataModel:self.modelArray[indexPath.item]];
//    if (self.searchController.active) {
//        [cell setDataModel:self.searchArray[indexPath.item]];
//    } else {
//        [cell setDataModel:self.modelArray[indexPath.item]];
//    }
    return (UICollectionViewCell *)cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMDevice *device;
    device = self.modelArray[indexPath.item];
//    if (self.searchController.active) {
//        device = self.searchArray[indexPath.item];
//    } else {
//        device = self.modelArray[indexPath.item];
//    }
//    
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

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = self.searchController.searchBar.text;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:searchString forKey:@"deviceName"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"mobile/device/list"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *tempArray = [WMDeviceUtility deviceListFromJson:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.deviceSearchViewController.searchArray = tempArray;
//                                            self.searchArray = tempArray;
//                                            [self.collectionView reloadData];
                                        });
                                    } else {
                                        NSLog(@"updateSearchResultsForSearchController error, result is %@", result);
                                    }
                                }];
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

- (void)loadDeviceList {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"mobile/device/list"
                              parameters:nil
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSArray *tempArray = [WMDeviceUtility deviceListFromJson:result.content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.modelArray = tempArray;
                                            [self.collectionView reloadData];
                                        });
                                    } else {
                                        NSLog(@"loadDeviceList error, result is %@", result);
                                    }
                                }];
}

- (UIImage*)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Getters & setters
- (NSArray<WMDevice *> *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSArray alloc] init];
    }
    return _modelArray;
}

- (NSArray<WMDevice *> *)searchArray {
    if (!_searchArray) {
        _searchArray = [[NSArray alloc] init];
    }
    return _searchArray;
}

//- (UISearchController *)searchController {
//    if (!_searchController) {
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.deviceSearchViewController];
//        _searchController.searchResultsUpdater = self;
////        [_searchController.searchBar sizeToFit];
////        _searchController.dimsBackgroundDuringPresentation = NO;
////        _searchController.hidesNavigationBarDuringPresentation = NO;
//        _searchController.searchBar.frame = WM_CGRectMake(SearchBarX, SearchBarY, SearchBarWidth, SearchBarHeight);
////        _searchController.searchBar.barTintColor = [UIColor whiteColor];
////        _searchController.searchBar.tintColor = [UIColor whiteColor];
//    }
//    return _searchController;
//}
//
//- (WMDeviceSearchViewController *)deviceSearchViewController {
//    if (!_deviceSearchViewController) {
//        _deviceSearchViewController = [[WMDeviceSearchViewController alloc] init];
//        _deviceSearchViewController.view.frame = CGRectMake(0, 64, 375, 1.5*480);//WM_CGRectMake(0, Navi_Height, Screen_Width, 600);
//    }
//    return _deviceSearchViewController;
//}

@end
