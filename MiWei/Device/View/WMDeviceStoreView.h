//
//  WMDeviceStoreView.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDeviceStoreItem.h"

@interface WMDeviceStoreView : UIView
@property (nonatomic, strong) UILabel *remainingTimeLabel;
@property (nonatomic, strong) WMDeviceStoreItem *storeItem;
@property (nonatomic, strong) WMDeviceStoreItem *payItem;
@end
