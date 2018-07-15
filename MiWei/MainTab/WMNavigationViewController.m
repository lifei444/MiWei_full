//
//  WMNavigationViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMNavigationViewController.h"

@interface WMNavigationViewController ()

@end

@implementation WMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:NSClassFromString(@"WMDeviceViewController")]||
       [viewController isKindOfClass:NSClassFromString(@"WMMessageViewController")]||
       [viewController isKindOfClass:NSClassFromString(@"WMMeViewController")]) {
    }else {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
