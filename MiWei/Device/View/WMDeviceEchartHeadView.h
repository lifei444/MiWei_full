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
    WMDeviceEchartHeadSelectMonth,
    WMDeviceEchartHeadSelectYear,
    WMDeviceEchartHeadSelectWeek
};

typedef NS_ENUM(NSUInteger, WMDeviceEchartHeadViewFrom) {
    WMDeviceEchartHeadViewFromPollutionChange,
    WMDeviceEchartHeadViewFromPollutionSum
};

@interface WMDeviceEchartHeadView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) WMDeviceEchartHeadViewFrom from;
@end
