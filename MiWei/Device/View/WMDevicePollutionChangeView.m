//
//  WMDevicePollutionChangeView.m
//  MiWei
//
//  Created by LiFei on 2018/7/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePollutionChangeView.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "WMCommonDefine.h"
#import "WMDeviceUtility.h"
#import "WMPollutionIndex.h"

#define Table_Width     345
#define Table_Height    280

#define Header_Height   36

#define Chart_X         30
#define Chart_Y         10
#define Chart_Width     305
#define Chart_Height    (Table_Height - Header_Height)

@interface WMDevicePollutionChangeView ()
@property (nonatomic, strong) NSArray <WMPollutionIndex *> *dataArray;
@property (nonatomic, assign) WMDeviceEchartHeadSelectLabel selectLabelType;
@end

@implementation WMDevicePollutionChangeView
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headView];
        [self addSubview:self.chartView];
        self.selectLabelType = WMDeviceEchartHeadSelectDay;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onLabelChange:)
                                                     name:WMDeviceEchartHeadViewSelectNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Target action
- (void)onLabelChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([dic[@"from"] longValue] == WMDeviceEchartHeadViewFromPollutionChange) {
        self.selectLabelType = [dic[@"select"] longValue];
        [self loadData];
    }
}

#pragma mark - Private method
- (void)loadData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.device.deviceId forKey:@"deviceID"];
    [dic setObject:@(self.selectLabelType) forKey:@"type"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryPM25HistoryData"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                        NSArray *contentArray = result.content;
                                        for (NSDictionary *contentDic in contentArray) {
                                            WMPollutionIndex *pIndex = [WMPollutionIndex indexWithDic:contentDic];
                                            [tempArray addObject:pIndex];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.dataArray = tempArray;
                                            [self.chartView setOption:[self getOption]];
                                            [self.chartView loadEcharts];
                                        });
                                    } else {
                                        NSLog(@"/mobile/device/queryPM25HistoryData result is %@", result);
                                    }
                                }];
}

- (PYOption *)getOption {
    NSArray *xAxisArray;
    NSArray *dataArray;
    if (self.selectLabelType == WMDeviceEchartHeadSelectDay) {
        xAxisArray = [WMDeviceUtility getDayAxisFromArray:self.dataArray];
        dataArray = [WMDeviceUtility getDayDataFromArray:self.dataArray];
    } else if (self.selectLabelType == WMDeviceEchartHeadSelectWeek) {
        xAxisArray = [WMDeviceUtility getWeekAxisFromArray:self.dataArray];
        dataArray = [WMDeviceUtility getWeekDataFromArray:self.dataArray];
    } else if (self.selectLabelType == WMDeviceEchartHeadSelectMonth) {
        xAxisArray = [WMDeviceUtility getMonthAxisFromArray:self.dataArray];
        dataArray = [WMDeviceUtility getMonthDataFromArray:self.dataArray];
    } else if (self.selectLabelType == WMDeviceEchartHeadSelectYear) {
        xAxisArray = [WMDeviceUtility getYearAxisFromArray:self.dataArray];
        dataArray = [WMDeviceUtility getYearDataFromArray:self.dataArray];
    }
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.widthEqual(@([WMUIUtility WMCGFloatForX:Chart_Width]))
            .heightEqual(@([WMUIUtility WMCGFloatForY:Chart_Height - 40]))
            .xEqual(@([WMUIUtility WMCGFloatForY:Chart_X]))
            .yEqual(@([WMUIUtility WMCGFloatForY:Chart_Y]))
            .borderWidthEqual(@(0));
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).addDataArr(xAxisArray).splitNumberEqual(@(dataArray.count))
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO).intervalEqual(0);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.marginEqual(@([WMUIUtility WMCGFloatForY:5]))
                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual(@"#0e837b");
                }]);
            }])
            .axisLineEqual([PYAxisLine initPYAxisLineWithBlock:^(PYAxisLine *axisLine) {
                axisLine.lineStyleEqual([PYLineStyle initPYLineStyleWithBlock:^(PYLineStyle *lineStyle) {
                    lineStyle.colorEqual(@"#0e837b");
                }]);
            }]);
        }])
        .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeValue)
            .splitLineEqual([PYAxisSplitLine initPYAxisSplitLineWithBlock:^(PYAxisSplitLine *splitLine) {
                splitLine.showEqual(NO);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.marginEqual(@([WMUIUtility WMCGFloatForY:5]))
                .textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
                    textStyle.colorEqual(@"#0e837b");
                }]);
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]).borderWidthEqual(@(0));
                }]);
            }])
            .dataEqual(dataArray);
        }]);
    }];
}

#pragma mark - Getters & setters
- (WMDeviceEchartHeadView *)headView {
    if (!_headView) {
        _headView = [[WMDeviceEchartHeadView alloc] initWithFrame:WM_CGRectMake(0, 0, Table_Width, Header_Height)];
        _headView.titleLabel.text = @"污染指数变化";
        _headView.from = WMDeviceEchartHeadViewFromPollutionChange;
    }
    return _headView;
}

- (WKEchartsView *)chartView {
    if (!_chartView) {
        _chartView = [[WKEchartsView alloc] initWithFrame:WM_CGRectMake(0, Header_Height, Table_Width, Chart_Height)];
        _chartView.userInteractionEnabled = NO;
    }
    return _chartView;
}

- (void)setDevice:(WMDevice *)device {
    _device = device;
    [self loadData];
}

@end
