//
//  WMDeviceUtility.m
//  MiWei
//
//  Created by LiFei on 2018/8/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceUtility.h"
#import "WMHTTPUtility.h"

@implementation WMDeviceUtility

+ (void)addDevice:(WMDevice *)device
         location:(CLLocationCoordinate2D)coord
             ssid:(NSString *)ssid
         complete:(void (^)(BOOL))completeBlock {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:device.deviceId forKey:@"deviceID"];
    [dic setObject:@(coord.latitude) forKey:@"latitude"];
    [dic setObject:@(coord.longitude) forKey:@"longitude"];
    [dic setObject:ssid forKey:@"wifiSSID"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/addDevice"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if (result.success) {
                                            if (completeBlock) {
                                                completeBlock(YES);
                                            }
                                        } else {
                                            NSLog(@"addDevice error, result is %@", result);
                                            if (completeBlock) {
                                                completeBlock(NO);
                                            }
                                        }
                                    });
                                }];
}

@end
