//
//  WMDevicePollutionSumView.h
//  MiWei
//
//  Created by LiFei on 2018/7/29.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceEchartHeadView.h"
#import "WMDevice.h"

@interface WMDevicePollutionSumView : UIView

@property (nonatomic, strong) WMDeviceEchartHeadView *headView;
@property (nonatomic, strong) WKEchartsView *chartView;
@property (nonatomic, strong) WMDevice *device;

@end
