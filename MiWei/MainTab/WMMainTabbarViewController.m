//
//  WMMainTabbarViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMainTabbarViewController.h"
#import "WMNavigationViewController.h"
#import "WMDeviceViewController.h"
#import "WMMessageViewController.h"
#import "WMMeViewController.h"
#import "WMUIUtility.h"

@interface WMMainTabbarViewController ()

@end

@implementation WMMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [WMUIUtility color:@"0x23938b"];
    [self setViewControllers];
}

- (void)setViewControllers {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    WMDeviceViewController *deviceVC = [[WMDeviceViewController alloc] initWithCollectionViewLayout:layout];
    WMNavigationViewController *deviceNav = [self getNaviBy:deviceVC title:@"设备" image:[UIImage imageNamed:@"maintab_device"] selectImage:[UIImage imageNamed:@"maintab_device_select"]];
    
    WMMessageViewController *weaVC = [[WMMessageViewController alloc] init];
    WMNavigationViewController *weaNav = [self getNaviBy:weaVC title:@"消息" image:[UIImage imageNamed:@"maintab_message"] selectImage:[UIImage imageNamed:@"maintab_message_select"]];
    
    WMMeViewController *meVC = [[WMMeViewController alloc] init];
    WMNavigationViewController *meNav = [self getNaviBy:meVC title:@"个人" image:[UIImage imageNamed:@"maintab_profile"] selectImage:[UIImage imageNamed:@"maintab_profile_select"]];
    
    self.viewControllers = @[deviceNav, weaNav, meNav];
}

- (WMNavigationViewController *)getNaviBy:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectImage:(UIImage *)selectImage{
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectImage;
    vc.tabBarItem.title = title;
    WMNavigationViewController *nav = [[WMNavigationViewController alloc] initWithRootViewController:vc];
    return nav;
}

@end
