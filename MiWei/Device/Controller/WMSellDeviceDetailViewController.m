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

#define Address_Y                       19
#define Address_Height                  18

#define GapBetweenAddressAndName        11

#define Name_Y                          Address_Y + Address_Height + GapBetweenAddressAndName
#define Name_Height                     13

#define GapBetweenNameAndPM             23

#define PM_Y                            Name_Y + Name_Height + GapBetweenNameAndPM
#define PM_Height                       201


@interface WMSellDeviceDetailViewController ()

@property (nonatomic, strong) WMDeviceDetail *deviceDetail;
@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WMDeviceAddressView *addressView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) WMDevicePMView *pmView;



@property (nonatomic,strong) WKEchartsView *chartView;
@property (nonatomic,strong) UIButton *upgradeButton;
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
    
    [self loadDeviceDetail];
    
    
//    
//    
//    [self.scrollView addSubview:self.headView];
//    [self.scrollView addSubview:self.pmView];
//    [self.scrollView addSubview:self.controlView];
//    [self.scrollView addSubview:self.chartView];
//    [self.scrollView addSubview:self.upgradeButton];
    
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, CGRectGetMaxY(self.upgradeButton.frame)+20);
    
//    [self loadChart];
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
        detail.pm25 = [NSNumber numberWithInt:100];
        self.pmView.innerPMValueLabel.text = [NSString stringWithFormat:@"%@", detail.pm25];
        self.pmView.outPMVauleLabel.text = [NSString stringWithFormat:@"%@", detail.outdoorPM25];
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


#pragma mark -

- (void)loadChart {
    [self.chartView setOption:[self getOption]];
    [self.chartView loadEcharts];
    self.chartView.userInteractionEnabled = NO;
}

- (PYOption *)getOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.titleEqual([PYTitle initPYTitleWithBlock:^(PYTitle *title) {
            title.textEqual(@"历史记录");
        }])
        .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.xEqual(@40).x2Equal(@50);
        }])
        .tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerAxis);
        }])
        .calculableEqual(YES)
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).boundaryGapEqual(@NO).addDataArr(@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"预购")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(30),@(182),@(434),@(791),@(390),@(30),@(10),@(30),@(182),@(434),@(791),@(390),@(30),@(10)]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .nameEqual(@"意向")
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(1320),@(1132),@(601),@(234),@(120),@(90),@(20),@(1320),@(1132),@(601),@(234),@(120),@(90),@(20)]);
        }]);
    }];
}

- (void)upgradeEvent {
    NSLog(@"%s",__func__);
}

- (UIButton *)upgradeButton {
    if(!_upgradeButton) {
        _upgradeButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(20, CGRectGetMaxY(self.chartView.frame)+20, self.view.bounds.size.width - 40, 44)];
        [_upgradeButton setTitle:@"升级" forState:UIControlStateNormal];
        [_upgradeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_upgradeButton addTarget:self action:@selector(upgradeEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upgradeButton;
}

//- (WKEchartsView *)chartView {
//    if(!_chartView) {
//        _chartView = [[WKEchartsView alloc] initWithFrame:WM_CGRectMake(0, CGRectGetMaxY(self.controlView.frame)+20, self.view.frame.size.width, 300)];
//    }
//    return _chartView;
//}
//
//- (WMDeviceInfoHeadView *)headView {
//    if(!_headView) {
//        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoHeadView" owner:self options:nil];
//        _headView  = [xibs firstObject];
//        _headView.frame = WM_CGRectMake(0, 0,Screen_Width , [WMDeviceInfoHeadView viewHeight]);
//    }
//    return _headView;
//}
//
//- (WMDeviceInfoPMView *)pmView {
//    if(!_pmView) {
//        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoPMView" owner:self options:nil];
//        _pmView  = [xibs firstObject];
//        _pmView.frame = WM_CGRectMake(20, CGRectGetMaxY(self.headView.frame), Screen_Width-20*2, 100);
//    }
//    return _pmView;
//}
//
//- (WMDeviceInfoControlView *)controlView {
//    if(!_controlView) {
//        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoControlView" owner:self options:nil];
//        _controlView  = [xibs firstObject];
//        _controlView.frame = WM_CGRectMake(20, CGRectGetMaxY(self.pmView.frame)+20, Screen_Width-20*2, 280);
//    }
//    return _controlView;
//}





@end
