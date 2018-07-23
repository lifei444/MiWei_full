//
//  WMKeychainUtility.h
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMKeychainUtility : NSObject

/**
 将对应数据存入钥匙串中
 
 @param data 需要存入的数据
 @param key 存储信息的key值
 
 */
+ (void)setWMData:(id)data forKey:(NSString *)key;

/**
 从钥匙串中获取key值对应信息
 
 @param key 存储信息的key值
 @return 获取到的信息
 */
+ (id)WMDataForKey:(NSString *)key;

/**
 移除钥匙串中key值对应的信息
 
 @param key 需要移除信息对应的key值
 */
+ (void)removeWMDataForKey:(NSString *)key;

/**
 更新钥匙串中key值对应的信息
 
 @param data 需要跟新的信息
 @param key 需要更新信息对应的key值
 */
+ (void)updateWMData:(id)data forKey:(NSString *)key;

@end
