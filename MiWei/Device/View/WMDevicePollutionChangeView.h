//
//  WMDevicePollutionChangeView.h
//  MiWei
//
//  Created by LiFei on 2018/7/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKEchartsView.h"
#import "WMDeviceEchartHeadView.h"
#import "WMDevice.h"

@interface WMDevicePollutionChangeView : UIView

@property (nonatomic, strong) WMDeviceEchartHeadView *headView;
@property (nonatomic, strong) WKEchartsView *chartView;
@property (nonatomic, strong) WMDevice *device;

@end
