//
//  WMSellDeviceDetailViewController.m
//  MiWei
//
//  Created by LiFei on 2018/7/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMSellDeviceDetailViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMDeviceAddressView.h"
#import "WMHTTPUtility.h"
#import "WMDeviceDetail.h"
#import "WMDevicePMView.h"
#import "WMDeviceSwitchContainerView.h"
#import "WMDeviceDataView.h"
#import "WMDeviceRankView.h"
#import "WMDevicePollutionChangeView.h"
#import "WMDevicePollutionSumView.h"

#define Address_Y                       19
#define Address_Height                  18

#define GapBetweenAddressAndName        11

#define Name_Y                          (Address_Y + Address_Height + GapBetweenAddressAndName)
#define Name_Height                     13

#define GapBetweenNameAndPM             23

#define PM_Y                            (Name_Y + Name_Height + GapBetweenNameAndPM)
#define PM_Height                       201

#define GapBetweenPMAndAir              44

#define Air_Y                           (PM_Y + PM_Height + GapBetweenPMAndAir)
#define Air_Height                      15

#define GapBetweenAirAndSwitch          30

#define GapBetweenTables                12
#define Table_X                         15
#define Table_Width                     345

#define Switch_X                        Table_X
#define Switch_Y                        (Air_Y + Air_Height + GapBetweenAirAndSwitch)
#define Switch_Width                    Table_Width
#define Switch_Height                   205

#define Data_X                          Table_X
#define Data_Y                          (Switch_Y + Switch_Height + GapBetweenTables)
#define Data_Width                      Table_Width
#define Data_Height                     100

#define Rank_X                          Table_X
#define Rank_Y                          (Data_Y + Data_Height + GapBetweenTables)
#define Rank_Width                      Table_Width
#define Rank_Height                     70

#define Pollution_Change_X              Table_X
#define Pollution_Change_Y              (Rank_Y + Rank_Height + GapBetweenTables)
#define Pollution_Change_Width          Table_Width
#define Pollution_Change_Height         280

#define Pollution_Sum_X                 Table_X
#define Pollution_Sum_Y                 (Pollution_Change_Y + Pollution_Change_Height + GapBetweenTables)
#define Pollution_Sum_Width             Table_Width
#define Pollution_Sum_Height            280

#define Scroll_Height                   (Pollution_Sum_Y + Pollution_Sum_Height + 10)

@interface WMSellDeviceDetailViewController ()

@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WMDeviceAddressView *addressView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) WMDevicePMView *pmView;
@property (nonatomic, strong) UILabel *airLabel;
@property (nonatomic, strong) WMDeviceSwitchContainerView *switchContainerView;
@property (nonatomic, strong) WMDeviceDataView *dataView;
@property (nonatomic, strong) WMDeviceRankView *rankView;
@property (nonatomic, strong) WMDevicePollutionChangeView *pollutionChangeView;
@property (nonatomic, strong) WMDevicePollutionSumView *pollutionSumView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WMSellDeviceDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.pmView];
    [self.scrollView addSubview:self.airLabel];
    [self.scrollView addSubview:self.switchContainerView];
    [self.scrollView addSubview:self.dataView];
    [self.scrollView addSubview:self.rankView];
    [self.scrollView addSubview:self.pollutionChangeView];
    [self.scrollView addSubview:self.pollutionSumView];
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, Scroll_Height);
    [self loadDeviceDetailWithSwitchContainer:YES];
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
//    [self.switchContainerView stopTimerIfNeeded];
}

#pragma mark - Target action
- (void)onTimer {
    NSLog(@"WMSellDeviceDetailViewController onTimer");
    [self loadDeviceDetailWithSwitchContainer:NO];
}

#pragma mark - Private
- (void)loadDeviceDetailWithSwitchContainer:(BOOL)with {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.device.deviceId forKey:@"deviceID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryDetails"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSDictionary *content = result.content;
                                        WMDeviceDetail *detail = [WMDeviceDetail deviceDetailFromHTTPData:content];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self refreshData:detail];
                                            if (with) {
                                                [self.switchContainerView setModel:detail];
                                            }
                                        });
                                    } else {
                                        NSLog(@"loadDeviceDetail error");
                                    }
                                }];
}

- (void)refreshData:(WMDeviceDetail *)detail {
    self.deviceDetail = detail;
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
    
    //addressView
    self.addressView.label.text = [NSString stringWithFormat:@"%@%@%@%@", detail.addrLev1?:@"", detail.addrLev2?:@"", detail.addrLev3?:@"", detail.addrDetail?:@""];
    NSString *shortString = [NSString stringWithFormat:@"%@%@%@", detail.addrLev1?:@"", detail.addrLev2?:@"", detail.addrLev3?:@""];
    [self.addressView adjustLabelSize:shortString];
    CGPoint viewCenter = self.view.center;
    CGPoint addressViewCenter = self.addressView.center;
    addressViewCenter.x = viewCenter.x;
    self.addressView.center = addressViewCenter;
    
    //nameLabel
    NSString *dateString = @"";
    if (detail.lastUpdateTime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detail.lastUpdateTime longLongValue]];
        dateString = [self.formatter stringFromDate:date];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", detail.name, dateString];
    
    //pmView
//        detail.pm25 = [NSNumber numberWithInt:100];
    self.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%d", [detail.pm25 intValue]];
    self.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%d", [detail.outdoorPM25 intValue]];
    
    //airLabel
    if (detail.pm25AirText.length == 0) {
        detail.pm25AirText = @"哇！幸福哭了！室内空气堪比马尔代夫！";
    }
    self.airLabel.text = detail.pm25AirText;
    
    //dataView
    NSString *str = @"PM2.5：";
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
    
    //rankView
    str = detail.pm25RankText;
    if (str.length == 0) {
        str = @"太幸福了，您的室内空气优于全国80%的空气，比其他人少吸了80%雾霾。";
    }
    self.rankView.textView.text = str;
}

- (void)layoutViewWithoutSwitchView:(UIView *)view {
    CGRect frame = view.frame;
    frame.origin.y -= [WMUIUtility WMCGFloatForY:(Switch_Height + GapBetweenTables)];
    view.frame = frame;
}

#pragma mark - Getters & setters
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterShortStyle];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _formatter;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [WMUIUtility color:@"0x1d8489"];
    }
    return _scrollView;
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Name_Y, Screen_Width, Name_Height)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _nameLabel.alpha = 0.7;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        if (self.device.name.length) {
            _nameLabel.text = self.device.name;
        }
    }
    return _nameLabel;
}

- (WMDevicePMView *)pmView {
    if (!_pmView) {
        _pmView = [[WMDevicePMView alloc] initWithFrame:WM_CGRectMake(0, PM_Y, Screen_Width, PM_Height)];
    }
    return _pmView;
}

- (UILabel *)airLabel {
    if (!_airLabel) {
        _airLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Air_Y, Screen_Width, Air_Height)];
        _airLabel.font = [UIFont systemFontOfSize:15];
        _airLabel.textColor = [WMUIUtility color:@"0xffffff"];
        _airLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _airLabel;
}

- (WMDeviceSwitchContainerView *)switchContainerView {
    if (!_switchContainerView) {
        _switchContainerView = [[WMDeviceSwitchContainerView alloc] initWithFrame:WM_CGRectMake(Switch_X, Switch_Y, Switch_Width, Switch_Height)];
        _switchContainerView.vc = self;
        _switchContainerView.prodId = self.device.prod.prodId;
    }
    return _switchContainerView;
}

- (WMDeviceDataView *)dataView {
    if (!_dataView) {
        _dataView = [[WMDeviceDataView alloc] initWithFrame:WM_CGRectMake(Data_X, Data_Y, Data_Width, Data_Height)];
    }
    return _dataView;
}

- (WMDeviceRankView *)rankView {
    if (!_rankView) {
        _rankView = [[WMDeviceRankView alloc] initWithFrame:WM_CGRectMake(Rank_X, Rank_Y, Rank_Width, Rank_Height)];
    }
    return _rankView;
}

- (WMDevicePollutionChangeView *)pollutionChangeView {
    if (!_pollutionChangeView) {
        _pollutionChangeView = [[WMDevicePollutionChangeView alloc] initWithFrame:WM_CGRectMake(Pollution_Change_X, Pollution_Change_Y, Pollution_Change_Width, Pollution_Change_Height)];
        _pollutionChangeView.device = self.device;
    }
    return _pollutionChangeView;
}

- (WMDevicePollutionSumView *)pollutionSumView {
    if (!_pollutionSumView) {
        _pollutionSumView = [[WMDevicePollutionSumView alloc] initWithFrame:WM_CGRectMake(Pollution_Sum_X, Pollution_Sum_Y, Pollution_Sum_Width, Pollution_Sum_Height)];
        _pollutionSumView.device = self.device;
    }
    return _pollutionSumView;
}

@end
