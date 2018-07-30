//
//  WMDevicePollutionChangeView.m
//  MiWei
//
//  Created by LiFei on 2018/7/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePollutionChangeView.h"
#import "WMUIUtility.h"

@implementation WMDevicePollutionChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.headView];
        [self addSubview:self.chartView];
    }
    return self;
}

- (WMDeviceEchartHeadView *)headView {
    if (!_headView) {
        _headView = [[WMDeviceEchartHeadView alloc] initWithFrame:WM_CGRectMake(0, 0, self.bounds.size.width, 36)];
        _headView.titleLabel.text = @"污染指数变化";
    }
    return _headView;
}

- (WKEchartsView *)chartView {
    if (!_chartView) {
        _chartView = [[WKEchartsView alloc] initWithFrame:WM_CGRectMake(0, 36, self.bounds.size.width, self.bounds.size.height - 36)];
        [_chartView setOption:[self getOption]];
        [_chartView loadEcharts];
        _chartView.userInteractionEnabled = NO;
    }
    return _chartView;
}

- (PYOption *)getOption {
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
            grid.widthEqual(@(self.bounds.size.width))
            .heightEqual(@(200))
            .xEqual(@(0))
            .yEqual(@(30))
            .borderWidthEqual(@(0));
        }])
        .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
            axis.typeEqual(PYAxisTypeCategory).addDataArr(@[@"SUN", @"MON", @"TUES", @"WED", @"THURS", @"FRI", @"SAT"])
            .axisTickEqual([PYAxisTick initPYAxisTickWithBlock:^(PYAxisTick *axisTick) {
                axisTick.showEqual(NO);
            }])
            .axisLabelEqual([PYAxisLabel initPYAxisLabelWithBlock:^(PYAxisLabel *axisLabel) {
                axisLabel.textStyleEqual([PYTextStyle initPYTextStyleWithBlock:^(PYTextStyle *textStyle) {
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
                axisLabel.marginEqual(@(-20));
            }]);
        }])
        .addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.smoothEqual(YES)
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(4),@(2.2),@(3.7),@(3.2),@(1.9),@(1.7),@(2)]);
        }]);
    }];
}

@end