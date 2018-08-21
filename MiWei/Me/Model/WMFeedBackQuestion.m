//
//  WMFeedBackQuestion.m
//  MiWei
//
//  Created by LiFei on 2018/8/21.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMFeedBackQuestion.h"

@implementation WMFeedBackQuestion

+ (instancetype)questionWithDic:(NSDictionary *)dic {
    WMFeedBackQuestion *question = [[WMFeedBackQuestion alloc] init];
    question.questionId = dic[@"id"];
    question.name = dic [@"name"];
    return question;
}

@end
