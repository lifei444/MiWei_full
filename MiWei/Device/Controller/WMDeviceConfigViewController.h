//
//  WMDeviceConfigViewController.h
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMViewController.h"
#import "WMDevice.h"
#import <CoreLocation/CoreLocation.h>

@interface WMDeviceConfigViewController : WMViewController

@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, strong) WMDevice *device;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

@end
