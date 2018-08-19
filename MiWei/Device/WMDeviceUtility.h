//
//  WMDeviceUtility.h
//  MiWei
//
//  Created by LiFei on 2018/8/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDevice.h"
#import <CoreLocation/CoreLocation.h>
#import "WMHTTPUtility.h"


@interface WMDeviceUtility : NSObject

+ (void)addDevice:(WMDevice *)device
         location:(CLLocationCoordinate2D)coord
             ssid:(NSString *)ssid
         complete:(void (^)(BOOL result))completeBlock;

+ (NSArray <WMDevice *> *)deviceListFromJson:(NSDictionary *)json;

+ (void)setDevice:(NSDictionary *)dic
         response:(void (^)(WMHTTPResult *result))responseBlock;

+ (NSString *)descriptionOfAirSpeed:(WMAirSpeed)airSpeed;

+ (NSString *)descriptionOfVentilation:(WMVentilationMode)mode;

+ (NSString *)generateWeekDayString:(NSNumber *)value;

+ (NSArray <NSNumber *> *)generateWeekDayArray:(NSNumber *)value;
@end
