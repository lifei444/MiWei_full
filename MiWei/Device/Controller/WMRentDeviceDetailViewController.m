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
#import "WMDeviceStoreView.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"
#import "WMHTTPUtility.h"
#import "WMDeviceUtility.h"
#import "WMDevicePayViewController.h"

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
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) WMDeviceStoreView *storeView;
@property (nonatomic, strong) WMDeviceRankView *rankView;
@property (nonatomic, strong) WMDeviceSwitchContainerView *switchContainerView;
@property (nonatomic, strong) WMDeviceDataView *dataView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WMRentDeviceDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pmView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.priceLabel];
    [self.scrollView addSubview:self.storeView];
    [self.scrollView addSubview:self.rankView];
    [self.scrollView addSubview:self.switchContainerView];
    [self.scrollView addSubview:self.dataView];
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, Scroll_Height);
    [self loadDeviceDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData:self.deviceDetail];
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(onTimer)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Target action
- (void)tapPay {
    WMDevicePayViewController *vc = [[WMDevicePayViewController alloc] init];
    vc.deviceId = self.device.deviceId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTimer {
    NSLog(@"WMRentDeviceDetailViewController onTimer");
    [self loadDeviceDetail];
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
        //background color
        if ([detail.aqLevel longValue] == WMAqLevelGreen) {
            self.scrollView.backgroundColor = [WMUIUtility color:@"0x1d8489"];
        } else if ([detail.aqLevel longValue] == WMAqLevelBlue) {
            self.scrollView.backgroundColor = [WMUIUtility color:@"0x5b81d0"];
        } else if ([detail.aqLevel longValue] == WMAqLevelYellow) {
            self.scrollView.backgroundColor = [WMUIUtility color:@"0xf4d53f"];
        } else if ([detail.aqLevel longValue] == WMAqLevelRed) {
            self.scrollView.backgroundColor = [WMUIUtility color:@"0xda3232"];
        }
        
        //pmView
        //        detail.pm25 = [NSNumber numberWithInt:100];
        self.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%d", [detail.pm25 intValue]];
        self.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%d", [detail.outdoorPM25 intValue]];
        
        //addressView
        self.addressView.label.text = [NSString stringWithFormat:@"%@%@%@%@", detail.addrLev1?:@"", detail.addrLev2?:@"", detail.addrLev3?:@"", detail.addrDetail?:@""];

        CGRect addressViewFrame = self.addressView.frame;
        CGRect labelFrame = self.addressView.label.frame;
        
        UIFont *font = self.addressView.label.font;
        CGSize labelSize = [self.addressView.label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
        if (labelSize.width < [WMUIUtility WMCGFloatForX:200]) {
            labelFrame.size.width = labelSize.width;
        } else {
            labelFrame.size.width = [WMUIUtility WMCGFloatForX:200];
        }
        addressViewFrame.size.width = self.addressView.imageView.frame.size.width + 10 + labelFrame.size.width;
        self.addressView.label.frame = labelFrame;
        self.addressView.frame = addressViewFrame;
        
        CGPoint viewCenter = self.view.center;
        CGPoint addressViewCenter = self.addressView.center;
        addressViewCenter.x = viewCenter.x;
        self.addressView.center = addressViewCenter;
        
        NSString *str;
        //price
        if (detail.rentInfo) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detail.rentInfo.startTime longLongValue] / 1000];
            str = [self.formatter stringFromDate:date];
            str = [NSString stringWithFormat:@"%@   %@", str, [WMDeviceUtility generatePriceStringFromPrice:detail.rentInfo.price andRentTime:detail.rentInfo.rentTime]];
            self.priceLabel.text = str;
        }
        
        //store
        self.storeView.remainingTimeLabel.text = [WMDeviceUtility timeStringFromSecond:detail.rentInfo.remainingTime];
        
        //rankView
        str = detail.pm25RankText;
        if (str.length == 0) {
            str = @"太幸福了，您的室内空气优于全国80%的空气，比其他人少吸了80%雾霾。";
        }
        self.rankView.textView.text = str;
        
        //switchContainerView
        [self.switchContainerView setModel:detail];
        
        //dataView
        str = @"PM2.5：";
        str = [str stringByAppendingFormat:@"%d", [detail.pm25 intValue]];
        self.dataView.PMLabel.text = str;
        str = @"CO2：";
        str = [str stringByAppendingFormat:@"%0.2f", [detail.co2 floatValue]];
        self.dataView.co2Label.text = str;
        str = @"甲醛：";
        str = [str stringByAppendingFormat:@"%0.2f", [detail.ch2o floatValue]];
        self.dataView.ch2oLabel.text = str;
        str = @"TVOC：";
        str = [str stringByAppendingFormat:@"%0.2f", [detail.tvoc floatValue]];
        self.dataView.tvocLabel.text = str;
        str = @"温度：";
        str = [str stringByAppendingFormat:@"%0.2f", [detail.temp floatValue]];
        self.dataView.tempLabel.text = str;
        str = @"湿度：";
        str = [str stringByAppendingFormat:@"%0.2f", [detail.humidity floatValue]];
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

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Price_Y, Screen_Width, Price_Height)];
        _priceLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:Price_Height]];
        _priceLabel.textColor = [WMUIUtility color:@"0x0ee0dc"];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (WMDeviceStoreView *)storeView {
    if (!_storeView) {
        _storeView = [[WMDeviceStoreView alloc] initWithFrame:WM_CGRectMake(0, Store_Y, Screen_Width, Store_Height)];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPay)];
        [_storeView.payItem addGestureRecognizer:tapRecognizer];
    }
    return _storeView;
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
        _switchContainerView.vc = self;
    }
    return _switchContainerView;
}

- (WMDeviceDataView *)dataView {
    if (!_dataView) {
        _dataView = [[WMDeviceDataView alloc] initWithFrame:WM_CGRectMake(Table_X, Data_Y, Table_Width, Data_Height)];
    }
    return _dataView;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _formatter;
}

@end
