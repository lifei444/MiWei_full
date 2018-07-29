//
//  WMDeviceEchartHeadView.h
//  MiWei
//
//  Created by LiFei on 2018/7/29.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WMDeviceEchartHeadSelectLabel) {
    WMDeviceEchartHeadSelectDay,
    WMDeviceEchartHeadSelectWeek,
    WMDeviceEchartHeadSelectMonth,
    WMDeviceEchartHeadSelectYear
};

@interface WMDeviceEchartHeadView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, assign) WMDeviceEchartHeadSelectLabel selectLabel;

@end
