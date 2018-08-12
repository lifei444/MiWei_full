//
//  WMDeviceSwitchView.h
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"

@interface WMDeviceSwitchView : UIView

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) WMDeviceSwitchViewTag viewTag;

@end
