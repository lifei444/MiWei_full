//
//  WMDeviceTimerCell.h
//  MiWei
//
//  Created by LiFei on 2018/8/18.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBaseTableCell.h"

@interface WMDeviceTimerCell : WMBaseTableCell
@property (nonatomic, weak) UIViewController *vc;
//总开关
@property (nonatomic, assign) BOOL totalOff;
@end
