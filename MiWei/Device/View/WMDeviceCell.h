//
//  WMDeviceCell.h
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMDevice.h"

@interface WMDeviceCell : UICollectionViewCell
@property (nonatomic, weak) UIViewController *vc;

- (void)setDataModel:(WMDevice *)model;
@end
