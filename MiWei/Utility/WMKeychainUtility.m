//
//  WMKeychainUtility.m
//  MiWei
//
//  Created by LiFei on 2018/7/23.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMKeychainUtility.h"

static NSString *serviceName = @"cn.weimi.wm";

@implementation WMKeychainUtility

+ (void)setWMData:(id)data forKey:(NSString *)key {
    [WMKeychainUtility setWMData:data forKey:key isPerpetual:NO];
}

+ (id)WMDataForKey:(NSString *)key {
    return [WMKeychainUtility WMDataForKey:key isPerpetual:NO];
}

+ (void)removeWMDataForKey:(NSString *)key {
    [WMKeychainUtility removeWMDataForKey:key isPerpetual:NO];
}

+ (void)updateWMData:(id)data forKey:(NSString *)key {
    [WMKeychainUtility updateWMData:data forKey:key isPerpetual:NO];
}

//  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

+ (void)setWMData:(id)data forKey:(NSString *)key isPerpetual:(BOOL)isPerpetual{
    if (key.length == 0 || !data) {
        NSLog(@"setWMData failed, key: %@, data: %@", key, data);
        return;
    }
    
    NSMutableDictionary *keychainQuery = [self getWMKeychainQuery:key isPerpetual:isPerpetual];
    SecItemDelete((CFDictionaryRef)keychainQuery);  //  删除
    NSData *archiverData = [NSKeyedArchiver archivedDataWithRootObject:data];
    //  kSecValueData可以保存任意的数据
    [keychainQuery setObject:archiverData forKey:(id)kSecValueData];
    OSStatus result = SecItemAdd((CFDictionaryRef)keychainQuery, NULL); //  添加
    
    if (result != errSecSuccess) {
        NSLog(@"setWMData failed, key: %@, data: %@", key, data);
    }
}

+ (id)WMDataForKey:(NSString *)key isPerpetual:(BOOL)isPerpetual{
    if (key.length == 0) {
        NSLog(@"WMDataForKey failed, key: %@", key);
        return nil;
    }
    
    NSMutableDictionary *keychainQuery = [self getWMKeychainQuery:key isPerpetual:isPerpetual];
    //  添加搜索属性
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    //  添加搜索返回类型
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    id ret = nil;
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == errSecSuccess) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"WMDataForKey unarchiveObjectWithData failed, key: %@, exception: %@", key, exception);
        } @finally {
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return ret;
}

+ (void)removeWMDataForKey:(NSString *)key isPerpetual:(BOOL)isPerpetual{
    if (key.length == 0) {
        NSLog(@"removeWMDataForKey failed, key: %@", key);
        return;
    }
    
    NSMutableDictionary *keychainQuery = [self getWMKeychainQuery:key isPerpetual:isPerpetual];
    OSStatus result = SecItemDelete((CFDictionaryRef)keychainQuery);
    
    if (result != errSecSuccess) {
        NSLog(@"removeWMDataForKey failed, key: %@", key);
    }
}

+ (void)updateWMData:(id)data forKey:(NSString *)key isPerpetual:(BOOL)isPerpetual{
    if (key.length == 0 || !data) {
        NSLog(@"updateWMData failed, key: %@, data: %@", key, data);
        return;
    }
    
    NSMutableDictionary *oldQuery = [self getWMKeychainQuery:key isPerpetual:isPerpetual];
    NSMutableDictionary *newQuery = [self getWMKeychainQuery:key isPerpetual:isPerpetual];
    [newQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus result = SecItemUpdate((CFDictionaryRef)newQuery, (CFDictionaryRef)oldQuery);
    
    if (result != errSecSuccess) {
        NSLog(@"updateWMData failed, key: %@, data: %@", key, data);
    }
}

//  获取字典(所有的调用钥匙链服务使用一个字典定义密钥链项的属性)，字典内存储key值，和相关数据，此key值通过kSecAttrAccount和kSecAttrGeneric存储，并存储唯一标示；（注：一共用五个密钥类型作为key值）
+ (NSMutableDictionary *)getWMKeychainQuery:(NSString *)key isPerpetual:(BOOL)isPerpetual{
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    //   kSecClass指定了我们要保存的某类信息，在这里是一个通用的密码
    [query setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    //  服务类型预定义key，存储应用唯一标示
    if (isPerpetual) {
        //唯一标示会在卸载重装后不会重置
        [query setObject:serviceName forKey:(id)kSecAttrService];
    } else {
        //唯一标示会在卸载重装后重置
        [query setObject:[self getWMAppSecKey] forKey:(id)kSecAttrService];
    }
    //  kSecAttrGeneric（用户自定义内容类型key），kSecAttrAccount（账号类型key），这两个值用于存储对应的内容；
    [query setObject:key forKey:(id)kSecAttrGeneric];
    [query setObject:key forKey:(id)kSecAttrAccount];
    //  kSecAttrAccessible（可访问性 类型透明），kSecAttrAccessibleAfterFirstUnlock（第一次解锁后可访问）
    [query setObject:(id)kSecAttrAccessibleAfterFirstUnlock forKey:(id)kSecAttrAccessible];
    return query;
}

//  应用的唯一表示，由bundleid和首次安装时间拼接而成
+ (NSString *)getWMAppSecKey {
    long long firstTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WMKeychainTime"] longLongValue];
    if (firstTime <= 0) {
        firstTime = (long long)[NSDate date].timeIntervalSince1970;
        [[NSUserDefaults standardUserDefaults] setObject:@(firstTime) forKey:@"WMKeychainTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [NSString stringWithFormat:@"%@-%lld", [NSBundle mainBundle].bundleIdentifier, firstTime];
}

@end
