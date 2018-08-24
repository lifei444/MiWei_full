//
//  WMRegion.h
//  MiWei
//
//  Created by LiFei on 2018/8/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMRegion : NSObject
@property (nonatomic, strong) NSNumber *addrCode;
@property (nonatomic, copy)   NSString *country;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSArray <WMRegion *> *districts;
@property (nonatomic, copy)   NSString *lev1;
@property (nonatomic, copy)   NSString *lev2;
@property (nonatomic, copy)   NSString *lev3;

+ (instancetype)regionWithDic:(NSDictionary *)dic;
- (NSArray <NSString *> *)getDistricts;
@end
