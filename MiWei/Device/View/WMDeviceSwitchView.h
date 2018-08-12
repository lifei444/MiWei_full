//
//  WMDeviceSwitchView.h
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceDefine.h"

@protocol WMDeviceSwitchViewDelegate <NSObject>
- (void)viewDidTap:(WMDeviceSwitchViewTag)tag;
@end

@interface WMDeviceSwitchView : UIView

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) WMDeviceSwitchViewTag viewTag;
//不同的 view 有不同的 status
@property (nonatomic, assign) int status;
@property (nonatomic, weak)   id<WMDeviceSwitchViewDelegate> delegate;
@end
