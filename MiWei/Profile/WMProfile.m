//
//  WMProfile.m
//  MiWei
//
//  Created by LiFei on 2018/7/16.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMProfile.h"

@implementation WMProfile

+ (instancetype)profileWithDic:(NSDictionary *)dic {
    WMProfile *profile = [[WMProfile alloc] init];
    profile.profileId = dic[@"id"];
    profile.phone = dic[@"phone"];
    profile.name = dic[@"name"];
    profile.nickname = dic[@"nickName"];
    profile.portrait = dic[@"portraitID"];
    profile.addrDetail = dic[@"addrDetail"];
    WMRegion *region = [WMRegion regionWithDic:dic[@"district"]];
    profile.region = region;
    return profile;
}

@end
