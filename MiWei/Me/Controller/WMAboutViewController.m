//
//  WMAboutViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/21.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMAboutViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

#define Logo_Width                  151
#define Logo_Height                 62
#define Logo_X                      (Screen_Width - Logo_Width) / 2
#define Logo_Y                      (Navi_Height + 62)

#define GapBetweenLogoAndVersion    19

#define Version_Y                   (Logo_Y + Logo_Height + GapBetweenLogoAndVersion)
#define Version_Height              16

#define GapBetweenVersionAndDetail  43

#define Detail_X                    30
#define Detail_Y                    (Version_Y + Version_Height + GapBetweenVersionAndDetail)
#define Detail_Width                (Screen_Width - Detail_X * 2)
#define Detail_Height               100

@interface WMAboutViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@end

@implementation WMAboutViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于米微";
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.detailLabel];
    [self loadData];
}

#pragma mark - Private method
- (void)loadData {
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/about/queryAppInfo"
                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:@(2), @"appID", nil]
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            self.versionLabel.text = result.content[@"version"];
                                            self.detailLabel.text = result.content[@"descr"];
                                      });
                                    } else {
                                        NSLog(@"/mobile/about/queryAppInfo error, result is %@", result);
                                    }
                                }];
}

#pragma mark - Getters & setters
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Logo_X, Logo_Y, Logo_Width, Logo_Height)];
        _logoView.image = [UIImage imageNamed:@"about_logo"];
    }
    return _logoView;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Version_Y, Screen_Width, Version_Height)];
        _versionLabel.font = [UIFont boldSystemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
        _versionLabel.textColor = [WMUIUtility color:@"0x444444"];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(Detail_X, Detail_Y, Detail_Width, Detail_Height)];
        _detailLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
        _detailLabel.textColor = [WMUIUtility color:@"0x444444"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
@end
