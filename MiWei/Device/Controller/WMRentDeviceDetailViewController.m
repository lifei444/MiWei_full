//
//  WMRentDeviceDetailViewController.m
//  MiWei
//
//  Created by LiFei on 2018/7/30.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMRentDeviceDetailViewController.h"
#import "WMDeviceDetail.h"
#import "WMDevicePMView.h"
#import "WMDeviceAddressView.h"
#import "WMDeviceRankView.h"
#import "WMDeviceSwitchContainerView.h"
#import "WMDeviceDataView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMHTTPUtility.h"

#define PM_Y                            25
#define PM_Height                       201

#define GapBetweenPMAndAddress          16

#define Address_Y                       (PM_Y + PM_Height + GapBetweenPMAndAddress)
#define Address_Height                  18

#define GapBetweenAddressAndPrice       8

#define Price_Y                         (Address_Y + Address_Height + GapBetweenAddressAndPrice)
#define Price_Height                    13

#define GapBetweenPriceAndStore         20

#define Store_Y                         (Price_Y + Price_Height + GapBetweenPriceAndStore)
#define Store_Height                    28

#define GapBetweenStoreAndRank          9

#define Table_X                         15
#define Table_Width                     345
#define GapBetweenTables                11

#define Rank_Y                          (Store_Y + Store_Height + GapBetweenStoreAndRank)
#define Rank_Height                     70

#define Switch_Y                        (Rank_Y + Rank_Height + GapBetweenTables)
#define Switch_Height                   205

#define Data_Y                          (Switch_Y + Switch_Height + GapBetweenTables)
#define Data_Height                     100

#define Scroll_Height                   (Data_Y + Data_Height + 30)

@interface WMRentDeviceDetailViewController ()

@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WMDevicePMView *pmView;
@property (nonatomic, strong) WMDeviceAddressView *addressView;
//date and price view
//time and store view
@property (nonatomic, strong) WMDeviceRankView *rankView;
@property (nonatomic, strong) WMDeviceSwitchContainerView *switchContainerView;
@property (nonatomic, strong) WMDeviceDataView *dataView;

@end

@implementation WMRentDeviceDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pmView];
    [self.scrollView addSubview:self.addressView];
    //date and price view
    //time and store view
    [self.scrollView addSubview:self.rankView];
    [self.scrollView addSubview:self.switchContainerView];
    [self.scrollView addSubview:self.dataView];
    
    [self loadDeviceDetail];
    
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, Scroll_Height);
}

#pragma mark - Private
- (void)loadDeviceDetail {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.device.deviceId forKey:@"deviceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryDetails"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSDictionary *content = result.content;
                                        WMDeviceDetail *detail = [WMDeviceDetail deviceDetailFromHTTPData:content];
                                        [self refreshData:detail];
                                    } else {
                                        NSLog(@"loadDeviceDetail error");
                                    }
                                }];
}

- (void)refreshData:(WMDeviceDetail *)detail {
    self.deviceDetail = detail;
    dispatch_async(dispatch_get_main_queue(), ^{
        //pmView
        //        detail.pm25 = [NSNumber numberWithInt:100];
        self.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%@", detail.pm25];
        self.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%@", detail.outdoorPM25];
        
        //addressView
        if (detail.addrDetail.length == 0) {
            detail.addrDetail = @"回龙观东大街521号ttfasdfasdfasdf";
        }
        self.addressView.label.text = detail.addrDetail;
        CGRect addressViewFrame = self.addressView.frame;
        CGRect labelFrame = self.addressView.label.frame;
        
        UIFont *font = self.addressView.label.font;
        CGSize labelSize = [self.addressView.label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
        if (labelSize.width < labelFrame.size.width) {
            labelFrame.size.width = labelSize.width;
        }
        addressViewFrame.size.width = self.addressView.imageView.frame.size.width + 10 + labelFrame.size.width;
        self.addressView.label.frame = labelFrame;
        self.addressView.frame = addressViewFrame;
        
        CGPoint viewCenter = self.view.center;
        CGPoint addressViewCenter = self.addressView.center;
        addressViewCenter.x = viewCenter.x;
        self.addressView.center = addressViewCenter;
        
        NSString *str;
        //rankView
        str = detail.pm25RankText;
        if (str.length == 0) {
            str = @"太幸福了，您的室内空气优于全国80%的空气，比其他人少吸了80%雾霾。";
        }
        self.rankView.textView.text = str;
        
        //switchContainerView
        if (detail.powerOn) {
            self.switchContainerView.powerOnView.isOn = YES;
            [self.switchContainerView.powerOnView setNeedsDisplay];
            self.switchContainerView.ventilationView.isOn = YES;
            [self.switchContainerView.powerOnView setNeedsDisplay];
            self.switchContainerView.auxiliaryHeatView.isOn = YES;
            [self.switchContainerView.auxiliaryHeatView setNeedsDisplay];
            self.switchContainerView.airSpeedView.isOn = YES;
            [self.switchContainerView.airSpeedView setNeedsDisplay];
            self.switchContainerView.settingView.isOn = YES;
            [self.switchContainerView.settingView setNeedsDisplay];
        }
        
        //dataView
        str = self.dataView.PMLabel.text;
        str = [str stringByAppendingFormat:@"%@", detail.pm25];
        self.dataView.PMLabel.text = str;
        str = self.dataView.co2Label.text;
        str = [str stringByAppendingFormat:@"%@", detail.co2];
        self.dataView.co2Label.text = str;
        str = self.dataView.ch2oLabel.text;
        str = [str stringByAppendingFormat:@"%@", detail.ch2o];
        self.dataView.ch2oLabel.text = str;
        str = self.dataView.tvocLabel.text;
        str = [str stringByAppendingFormat:@"%@", detail.tvoc];
        self.dataView.tvocLabel.text = str;
        str = self.dataView.tempLabel.text;
        str = [str stringByAppendingFormat:@"%@", detail.temp];
        self.dataView.tempLabel.text = str;
        str = self.dataView.humidityLabel.text;
        str = [str stringByAppendingFormat:@"%@", detail.humidity];
        self.dataView.humidityLabel.text = str;
    });
}

#pragma mark - Getters & setters
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [WMUIUtility color:@"0x1d8489"];
    }
    return _scrollView;
}

- (WMDevicePMView *)pmView {
    if (!_pmView) {
        _pmView = [[WMDevicePMView alloc] initWithFrame:WM_CGRectMake(0, PM_Y, Screen_Width, PM_Height)];
    }
    return _pmView;
}

- (WMDeviceAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[WMDeviceAddressView alloc] initWithFrame:WM_CGRectMake(0, Address_Y, 14, Address_Height)];
        CGPoint center = self.view.center;
        center.y = [WMUIUtility WMCGFloatForY:(Address_Y + Address_Height/2)];
        _addressView.center = center;
    }
    return _addressView;
}

- (WMDeviceRankView *)rankView {
    if (!_rankView) {
        _rankView = [[WMDeviceRankView alloc] initWithFrame:WM_CGRectMake(Table_X, Rank_Y, Table_Width, Rank_Height)];
    }
    return _rankView;
}

- (WMDeviceSwitchContainerView *)switchContainerView {
    if (!_switchContainerView) {
        _switchContainerView = [[WMDeviceSwitchContainerView alloc] initWithFrame:WM_CGRectMake(Table_X, Switch_Y, Table_Width, Switch_Height)];
    }
    return _switchContainerView;
}

- (WMDeviceDataView *)dataView {
    if (!_dataView) {
        _dataView = [[WMDeviceDataView alloc] initWithFrame:WM_CGRectMake(Table_X, Data_Y, Table_Width, Data_Height)];
    }
    return _dataView;
}

@end
