//
//  WMPollutionIndex.m
//  MiWei
//
//  Created by LiFei on 2018/8/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMPollutionIndex.h"

@implementation WMPollutionIndex
+ (instancetype)indexWithDic:(NSDictionary *)dic {
    WMPollutionIndex *pIndex = [[WMPollutionIndex alloc] init];
    pIndex.timestamp = dic[@"time"];
    pIndex.value = dic[@"value"];
    return pIndex;
}
@end
