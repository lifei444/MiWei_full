//
//  WMFeedBackQuestion.h
//  MiWei
//
//  Created by LiFei on 2018/8/21.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMFeedBackQuestion : NSObject
@property (nonatomic, strong) NSNumber *questionId;
@property (nonatomic, copy)   NSString *name;

+ (instancetype)questionWithDic:(NSDictionary *)dic;
@end
