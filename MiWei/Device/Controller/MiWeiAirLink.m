//
//  MiWeiAirLink.m
//  MiWei
//
//  Created by weiqinxiao on 2018/12/20.
//  Copyright © 2018 Sin. All rights reserved.
//

#import "MiWeiAirLink.h"


#import <Foundation/Foundation.h>

#define AIRLINK_VERSION  @"1.0.0"

@implementation MiWeiAirLink

@synthesize isRunning = _isRunning;
@synthesize version = _version;

-(id)init{
    self = [super init];
    if (self) {
        _isRunning = false;
        _version = [[NSString alloc] initWithFormat:@"v%@ on Easylink %@", AIRLINK_VERSION, [EASYLINK version]];
        _callback = nil;
    }
    return self;
}


- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout andCallback:(onMiWeiEvent)callback
{
    if( _isRunning == true )
        return;
    
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    _easylink_config = [[EASYLINK alloc]initForDebug:false WithDelegate:self];
    _callback = callback;
    
    [wlanConfig setObject: [ssid dataUsingEncoding:NSUTF8StringEncoding] forKey:KEY_SSID];
    [wlanConfig setObject: key forKey:KEY_PASSWORD];
    [wlanConfig setObject: @YES forKey:KEY_DHCP];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(stop) withObject:nil afterDelay:timeout];
    
    [_easylink_config prepareEasyLink:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    [_easylink_config transmitSettings];
    _isRunning = true;
}

- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout{
    [self start:ssid key:key timeout:timeout andCallback:nil];
}

/**
 * 停止配网
 */
- (void)stop
{
    if( _isRunning == true ){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        _isRunning = false;
        [_easylink_config stopTransmitting];
        [_easylink_config unInit];
        if( _callback != nil ){
            _callback(MiWeiMXCHIPAirlinkEventStop);
        }
        _callback = nil;
    }
}

/**
 @brief A new FTC client is found by bonjour in EasyLink
 @note  Available only on MiCO version after 2.3.0
 @param client:         Client identifier.
 @param name:           Client name.
 @param mataDataDict:   Txt record provided by device
 @return none.
 */
- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict{
    if( _callback != nil ){
        _callback(MiWeiMXCHIPAirlinkEventFound);
    }
}

@end
