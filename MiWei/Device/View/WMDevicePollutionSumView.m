//
//  WMDevicePollutionSumView.m
//  MiWei
//
//  Created by LiFei on 2018/7/29.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDevicePollutionSumView.h"
#import "WMUIUtility.h"

@implementation WMDevicePollutionSumView

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
        _headView.titleLabel.text = @"累计去除污染";
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
            series.typeEqual(PYSeriesTypeBar)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(@[@(4.9),@(6.5),@(7.1),@(3.8),@(1.9),@(5.1),@(1.7)]);
            ((PYCartesianSeries *)series).barWidth = @15;
        }]);
    }];
}

@end
