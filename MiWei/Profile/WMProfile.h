//
//  WMProfile.h
//  MiWei
//
//  Created by LiFei on 2018/7/16.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMProfile : NSObject

@property(nonatomic, strong) NSNumber *profileId;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *portrait;
@property(nonatomic, strong) NSString *addrDetail;

@end
