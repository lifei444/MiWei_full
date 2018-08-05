//
//  WMMessageFactory.h
//  MiWei
//
//  Created by LiFei on 2018/8/5.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMMessage.h"

@interface WMMessageFactory : NSObject

+ (WMMessage *)getMessageFromJson:(NSDictionary *)json;

@end
