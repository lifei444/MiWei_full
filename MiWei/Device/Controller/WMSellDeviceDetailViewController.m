//
//  WMSellDeviceDetailViewController.m
//  MiWei
//
//  Created by LiFei on 2018/7/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMSellDeviceDetailViewController.h"
#import "WMDeviceInfoHeadView.h"
#import "WMDeviceInfoPMView.h"
#import "WMDeviceInfoControlView.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMDeviceAddressView.h"

#define Address_Y                       19
#define Address_Height                  18

#define GapBetweenAddressAndName        11

#define Name_Y                          Address_Y + Address_Height + GapBetweenAddressAndName
#define Name_Height                     13

#define GapBetweenNameAndPM             23

#define PM_Y                            Name_Y + Name_Height + GapBetweenNameAndPM
#define PM_Height                       201

@interface WMSellDeviceDetailViewController ()

@property (nonatomic, strong) WMDeviceAddressView *addressView;



@property (nonatomic,strong) WMDeviceInfoHeadView *headView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) WKEchartsView *chartView;
@property (nonatomic,strong) WMDeviceInfoPMView *pmView;
@property (nonatomic,strong) WMDeviceInfoControlView *controlView;
@property (nonatomic,strong) UIButton *upgradeButton;
@end

@implementation WMSellDeviceDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.addressView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.pmView];
    [self.scrollView addSubview:self.controlView];
    [self.scrollView addSubview:self.chartView];
    [self.scrollView addSubview:self.upgradeButton];
    
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, CGRectGetMaxY(self.upgradeButton.frame)+20);
    
    [self loadChart];
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


#pragma mark - Getters & setters

- (WMDeviceAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[[NSBundle mainBundle] loadNibNamed:@"WMDeviceAddressView" owner:nil options:nil] lastObject];
    }
    return _addressView;
}




#pragma mark -

- (WKEchartsView *)chartView {
    if(!_chartView) {
        _chartView = [[WKEchartsView alloc] initWithFrame:WM_CGRectMake(0, CGRectGetMaxY(self.controlView.frame)+20, self.view.frame.size.width, 300)];
    }
    return _chartView;
}

- (WMDeviceInfoHeadView *)headView {
    if(!_headView) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoHeadView" owner:self options:nil];
        _headView  = [xibs firstObject];
        _headView.frame = WM_CGRectMake(0, 0,Screen_Width , [WMDeviceInfoHeadView viewHeight]);
    }
    return _headView;
}

- (WMDeviceInfoPMView *)pmView {
    if(!_pmView) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoPMView" owner:self options:nil];
        _pmView  = [xibs firstObject];
        _pmView.frame = WM_CGRectMake(20, CGRectGetMaxY(self.headView.frame), Screen_Width-20*2, 100);
    }
    return _pmView;
}

- (WMDeviceInfoControlView *)controlView {
    if(!_controlView) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"WMDeviceInfoControlView" owner:self options:nil];
        _controlView  = [xibs firstObject];
        _controlView.frame = WM_CGRectMake(20, CGRectGetMaxY(self.pmView.frame)+20, Screen_Width-20*2, 280);
    }
    return _controlView;
}

- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:1 blue:1 alpha:1];
    }
    return _scrollView;
}



@end
