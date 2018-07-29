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
#define Rank_Height                     68

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
                                        WMDeviceDetail *detail = [self getDetailFromHTTPData:content];
                                        [self refreshData:detail];
                                    } else {
                                        NSLog(@"loadDeviceDetail error");
                                    }
                                }];
}

- (void)refreshData:(WMDeviceDetail *)detail {
    self.deviceDetail = detail;
    dispatch_async(dispatch_get_main_queue(), ^{
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
        
        //nameLabel
        NSString *dateString = @"";
        if (detail.lastUpdateTime) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detail.lastUpdateTime doubleValue] / 1000];
            dateString = [self.formatter stringFromDate:date];
        }
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", detail.name, dateString];
        
        //pmView
//        detail.pm25 = [NSNumber numberWithInt:100];
        self.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%@", detail.pm25];
        self.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%@", detail.outdoorPM25];
        
        //airLabel
        if (detail.pm25AirText.length == 0) {
            detail.pm25AirText = @"哇！幸福哭了！室内空气堪比马尔代夫！";
        }
        self.airLabel.text = detail.pm25AirText;
        
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
        NSString *str = self.dataView.PMLabel.text;
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
        
        //rankView
        str = detail.pm25RankText;
        if (str.length == 0) {
            str = @"太幸福了，您的室内空气优于全国80%的空气，比其他人少吸了80%雾霾。";
        }
        self.rankView.textView.text = str;
    });
}

- (WMDeviceDetail *)getDetailFromHTTPData:(NSDictionary *)content {
    WMDeviceDetail *detail = [[WMDeviceDetail alloc] init];
    
    NSDictionary *deviceData = content[@"deviceData"];
    detail.aqLevel = deviceData[@"aqLevel"];
    detail.ch2o = deviceData[@"ch2o"];
    detail.co2 = deviceData[@"co2"];
    detail.humidity = deviceData[@"humidity"];
    detail.lastUpdateTime = deviceData[@"lastUpdateTime"];
    detail.outdoorPM25 = deviceData[@"outdoorPM25"];
    detail.pm25 = deviceData[@"pm25"];
    detail.temp = deviceData[@"temp"];
    detail.tvoc = deviceData[@"tvoc"];
    
    detail.deviceId = content[@"deviceID"];
    detail.name = content[@"deviceName"];
    
    NSDictionary *devicePos = content[@"devicePos"];
    detail.addrDetail = devicePos[@"addrDetail"];
    NSDictionary *district = devicePos[@"district"];
    detail.addrCode = district[@"addrCode"];
    detail.country = district[@"country"];
    detail.addrDepth = district[@"depth"];
    detail.addrLev1 = district[@"lev1"];
    detail.addrLev2 = district[@"lev2"];
    detail.addrLev3 = district[@"lev3"];
    NSDictionary *position = devicePos[@"position"];
    detail.latitude = position[@"latitude"];
    detail.longitude = position[@"longitude"];
    
    NSDictionary *deviceStatus = content[@"deviceStatus"];
    detail.airSpeed = deviceStatus[@"airSpeed"];
    detail.auxiliaryHeat = [deviceStatus[@"auxiliaryHeat"] boolValue];
    detail.babyLock = [deviceStatus[@"babyLock"] boolValue];
    detail.fanTiming = deviceStatus[@"fanTiming"];
    detail.powerOn = [deviceStatus[@"powerOn"] boolValue];
    detail.screenSwitch = [deviceStatus[@"screenSwitch"] boolValue];
    detail.ventilationMode = deviceStatus[@"ventilationMode"];
    
    detail.modelName = content[@"modelName"];
    detail.newestVerFw = content[@"newestVerFw"];
    detail.newestVerFwDescr = content[@"newestVerFwDescr"];
    detail.permission = [content[@"permission"] longValue];
    detail.pm25AirText = content[@"pm25AirText"];
    detail.pm25RankText = content[@"pm25RankText"];
    detail.prodName = content[@"prodName"];
    
    NSDictionary *rentInfoDic = content[@"rentInfo"];
    WMDeviceRentInfo *rentInfo = [[WMDeviceRentInfo alloc] init];
    rentInfo.price = rentInfoDic[@"price"];
    rentInfo.rentOwner = rentInfoDic[@"rentOwner"];
    rentInfo.remainingTime = rentInfoDic[@"rentRemainingTime"];
    rentInfo.startTime = rentInfoDic[@"rentStartTime"];
    rentInfo.rentTime = rentInfoDic[@"rentTime"];
    detail.rentInfo = rentInfo;
    
    detail.verFW = content[@"verFW"];
    return detail;
}


#pragma mark - Getters & setters
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterShortStyle];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
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
        center.y = Address_Y + Address_Height/2;
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
    }
    return _pollutionChangeView;
}

- (WMDevicePollutionSumView *)pollutionSumView {
    if (!_pollutionSumView) {
        _pollutionSumView = [[WMDevicePollutionSumView alloc] initWithFrame:WM_CGRectMake(Pollution_Sum_X, Pollution_Sum_Y, Pollution_Sum_Width, Pollution_Sum_Height)];
    }
    return _pollutionSumView;
}

@end
