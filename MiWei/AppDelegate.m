//
//  AppDelegate.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "AppDelegate.h"
#import "WMLoginViewController.h"
#import "WMMainTabbarViewController.h"
#import "WMNavigationViewController.h"
#import "WMUIUtility.h"
#import <WXApi.h>
#import <Bugly/Bugly.h>
#import <UMPush/UMessage.h>

NSString *const WMWechatAuthNotification = @"WMWechatAuthNotification";
NSString *const WMWechatPayNotification = @"WMWechatPayNotification";

@interface AppDelegate () <WXApiDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WMUIUtility registerAutoSizeScale];
    [WXApi registerApp:@"wx5048e61f6e905119"];
    [self startRecordWithAppId:@"4596fe651b"];
    
    BOOL isLogined = NO;
    if(isLogined) {
        WMMainTabbarViewController *tabVC = [[WMMainTabbarViewController alloc] init];
        self.window.rootViewController = tabVC;
    }else {
        WMLoginViewController *loginVC = [[WMLoginViewController alloc] init];
        WMNavigationViewController *nav = [[WMNavigationViewController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
    
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    return YES;
}

- (void)startRecordWithAppId:(NSString *__nullable)appId {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    [Bugly startWithAppId:appId config:config];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq *)req {
    NSLog(@"onReq");
}

- (void)onResp:(BaseResp *)resp {
    NSLog(@"onResp");
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response= (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:WMWechatPayNotification object:@(YES)];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:WMWechatPayNotification object:@(NO)];
                break;
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMWechatAuthNotification object:resp];
    }
}

@end
