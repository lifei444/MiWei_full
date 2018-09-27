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
#import "WMPollutionIndex.h"

@interface WMDeviceUtility : NSObject

+ (void)addDevice:(NSString *)deviceId
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

+ (NSString *)generatePriceStringFromPrice:(NSNumber *)fenNumber
                               andRentTime:(NSNumber *)minuteNumber;

+ (NSString *)timeStringFromSecond:(NSNumber *)time;

//获取日视图 x 坐标
+ (NSArray <WMPollutionIndex *> *)getDayAxisFromArray:(NSArray *)array;

//获取日视图数据
+ (NSArray <WMPollutionIndex *> *)getDayDataFromArray:(NSArray *)array;

//获取周视图 x 坐标
+ (NSArray <WMPollutionIndex *> *)getWeekAxisFromArray:(NSArray *)array;

//获取周视图数据
+ (NSArray <WMPollutionIndex *> *)getWeekDataFromArray:(NSArray *)array;

//获取月视图 x 坐标
+ (NSArray <WMPollutionIndex *> *)getMonthAxisFromArray:(NSArray *)array;

//获取月视图数据
+ (NSArray <WMPollutionIndex *> *)getMonthDataFromArray:(NSArray *)array;

//获取年 x 坐标
+ (NSArray <WMPollutionIndex *> *)getYearAxisFromArray:(NSArray *)array;

//获取年视图数据
+ (NSArray <WMPollutionIndex *> *)getYearDataFromArray:(NSArray *)array;
@end
