//
//  WMDevicePayBGView.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDevicePMView.h"

@interface WMDevicePayBGView : UIView
@property (nonatomic, strong) UILabel *lastUseLabel;
@property (nonatomic, strong) WMDevicePMView *pmView;
@property (nonatomic, strong) UILabel *totalLabel;
@end
