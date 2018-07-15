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

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WMUIUtility registerAutoSizeScale];
    
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

@end
