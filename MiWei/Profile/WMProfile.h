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
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *portrait;
@property(nonatomic, copy) NSString *addrDetail;

@end
