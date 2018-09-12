//
//  WMStoreWebViewController.m
//  MiWei
//
//  Created by LiFei on 2018/9/13.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMStoreWebViewController.h"
#import <WebKit/WebKit.h>
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMStoreWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation WMStoreWebViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self setRightNavBar];
    self.navigationItem.title = @"商城";
}

#pragma mark - Target action
- (void)leftBarButtonItemPressed:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClose {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private method
- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[WMUIUtility color:@"0x6a6a6a"] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - Getters & setters
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:WM_CGRectMake(0, Navi_Height, Screen_Width, Screen_Height - Navi_Height - 100)];
        NSString *url = @"http://mall.mivei.com/m/?tid=97539";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
    return _webView;
}

@end
