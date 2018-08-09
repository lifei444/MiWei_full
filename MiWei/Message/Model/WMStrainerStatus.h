//
//  WMStrainerStatus.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMStrainerStatus : NSObject

//是否报警
@property (nonatomic, assign) BOOL isAlarm;
//滤网索引
@property (nonatomic, strong) NSNumber *index;
//滤网名
@property (nonatomic, copy)   NSString *name;
//剩余使用时间（秒）
@property (nonatomic, strong) NSNumber *reaminingTime;

@end
