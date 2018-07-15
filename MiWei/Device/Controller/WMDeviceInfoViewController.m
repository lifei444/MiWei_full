//
//  WMDeviceInfoViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/15.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceInfoViewController.h"
#import "WMDeviceInfoHeadView.h"
#import "WMCommonDefine.h"
#import "WMDeviceInfoPMView.h"
#import "WMDeviceInfoControlView.h"
#import "WMUIUtility.h"

@interface WMDeviceInfoViewController ()
@property (nonatomic,strong) WMDeviceInfoHeadView *headView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) WKEchartsView *chartView;
@property (nonatomic,strong) WMDeviceInfoPMView *pmView;
@property (nonatomic,strong) WMDeviceInfoControlView *controlView;
@property (nonatomic,strong) UIButton *upgradeButton;
@end

@implementation WMDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"销售设备详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.pmView];
    [self.scrollView addSubview:self.controlView];
    [self.scrollView addSubview:self.chartView];
    [self.scrollView addSubview:self.upgradeButton];
    
    self.scrollView.contentSize = WM_CGSizeMake(Screen_Width, CGRectGetMaxY(self.upgradeButton.frame)+20);
    
    [self loadChart];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
