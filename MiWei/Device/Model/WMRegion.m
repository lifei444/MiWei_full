//
//  WMRegion.m
//  MiWei
//
//  Created by LiFei on 2018/8/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMRegion.h"

@implementation WMRegion

+ (instancetype)regionWithDic:(NSDictionary *)dic {
    WMRegion *region = [[WMRegion alloc] init];
    region.addrCode = dic[@"addrCode"];
    region.country = dic[@"country"];
    region.depth = dic[@"depth"];
    region.lev1 = dic[@"lev1"];
    region.lev2 = dic[@"lev2"];
    region.lev3 = dic[@"lev3"];
    NSArray *districtsArray = dic[@"districts"];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic1 in districtsArray) {
        WMRegion *region1 = [WMRegion regionWithDic:dic1];
        [tempArray addObject:region1];
    }
    region.districts = tempArray;
    return region;
}

@end
