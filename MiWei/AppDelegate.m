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

NSString *const WMWechatAuthNotification = @"WMWechatAuthNotification";

@interface AppDelegate () <WXApiDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WMUIUtility registerAutoSizeScale];
    [WXApi registerApp:@"wx5048e61f6e905119"];
    
    BOOL isLogined = NO;
    if(isLogined) {
        WMMainTabbarViewController *tabVC = [[WMMainTabbarViewController alloc] init];
        self.window.rootViewController = tabVC;
    }else {
        WMLoginViewController *loginVC = [[WMLoginViewController alloc] init];
        WMNavigationViewController *nav = [[WMNavigationViewController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }
    return YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:WMWechatAuthNotification object:resp];
}

@end
