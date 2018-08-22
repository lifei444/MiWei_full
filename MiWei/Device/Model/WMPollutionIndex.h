//
//  WMPollutionIndex.h
//  MiWei
//
//  Created by LiFei on 2018/8/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMPollutionIndex : NSObject
@property (nonatomic, strong) NSNumber *timestamp;
@property (nonatomic, strong) NSNumber *value;

+ (instancetype)indexWithDic:(NSDictionary *)dic;
@end
