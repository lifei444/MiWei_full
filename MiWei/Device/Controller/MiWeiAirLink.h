//
//  MiWeiAirLink.h
//  MiWei
//
//  Created by weiqinxiao on 2018/12/20.
//  Copyright © 2018 Sin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FogV3/EasyLink.h>

typedef NS_ENUM(NSInteger, MiWeiMXCHIPAirlinkEvent) {
    MiWeiMXCHIPAirlinkEventStart,
    MiWeiMXCHIPAirlinkEventStop,
    MiWeiMXCHIPAirlinkEventFound,
};

typedef void(^onMiWeiEvent)(MiWeiMXCHIPAirlinkEvent event);

@interface MiWeiAirLink : NSObject<EasyLinkFTCDelegate>{
@private
    EASYLINK *_easylink_config;
    onMiWeiEvent _callback;
}


/**
 * 开始Airlink配网，发配网包（ssid+密码）。
 *
 * @param ssid 家庭路由器ssid信息
 * @param key 家庭路由器密码
 * @param timeout 超时时间
 */
- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout;


/**
 * 开始Airlink配网，发配网包（ssid+密码），同时检测新设备加入，产生相应的事件
 *
 * @param ssid 家庭路由器ssid信息
 * @param key 家庭路由器密码
 * @param timeout 超时时间
 * @param callback 产生响应事件的回调
 */
- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout andCallback:(onMiWeiEvent)callback;

/**
 * 停止Airlink配置
 */
- (void)stop;

@property (nonatomic, readonly) BOOL isRunning;          //是否正在配网
@property (nonatomic, readonly) NSString* version;       //版本信息

@end
