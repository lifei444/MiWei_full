//
//  WMLoginViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMLoginViewController.h"
#import "WMCommonDefine.h"
#import "WMRegisterViewController.h"
#import "WMForgetPassViewController.h"
#import "WMUnderLineView.h"
#import "WMMainTabbarViewController.h"
#import "AppDelegate.h"
#import "WMUIUtility.h"

#define TitleViewHeight 64
#define GapBetweenTitleAndLogo 38
#define LogoImageHeight 62
#define GapBetweenLogoAndPhone 100
#define PhoneViewHeight 30
#define PasswordViewHeight 30
#define GapBetweenPasswordAndLoginButton 49
#define LoginButtonHeight 44
#define GapBetweenLoginButtonAndRegister 22
#define RegisterLabelHeight 13
#define GapBetweenRegisterAndForget 140
#define ForgetLabelHeight 15
#define GapBelowForget 30

#define LogoImageY TitleViewHeight + GapBetweenTitleAndLogo
#define PhoneViewY LogoImageY + LogoImageHeight + GapBetweenLogoAndPhone
#define PasswordViewY PhoneViewY + PhoneViewHeight + 30
#define LoginButtonY PasswordViewY + PasswordViewHeight + GapBetweenPasswordAndLoginButton
#define RegisterLabelY LoginButtonY + LoginButtonHeight + GapBetweenLoginButtonAndRegister
#define ForgetLabelY Screen_Height - GapBelowForget - ForgetLabelHeight

#define LogoImageWidth 151
#define LogoImageX (Screen_Width - LogoImageWidth)/2
#define LoginButtonX 37
#define LoginButtonW 300
#define RegisterLabelWidth 50
#define RegisterLabelX (Screen_Width - RegisterLabelWidth)/2
#define ForgetLabelWidth 100
#define ForgetLabelX (Screen_Width - ForgetLabelWidth)/2

@interface WMLoginViewController ()
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) WMUnderLineView *phoneView;
@property (nonatomic,strong) WMUnderLineView *passwordView;
@property (nonatomic,strong) UIView *wechatView;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UILabel *registerLabel;
@property (nonatomic,strong) UILabel *forgetLabel;
@end

@implementation WMLoginViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.wechatView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerLabel];
    [self.view addSubview:self.forgetLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - Target action
- (void)wechat {
    NSLog(@"%s",__func__);
}

- (void)doLogin {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    WMMainTabbarViewController *tabVC = [[WMMainTabbarViewController alloc] init];
    app.window.rootViewController = tabVC;
}

- (void)doRegister {
    WMRegisterViewController *vc = [[WMRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doForgetPassword {
    WMForgetPassViewController *vc = [[WMForgetPassViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters and setters
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 40, Screen_Width, 17)];
        _titleLable.text = @"登录";
        _titleLable.textColor = [WMUIUtility color:@"0x444444"];
        _titleLable.font = [UIFont systemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(LogoImageX, LogoImageY, LogoImageWidth, LogoImageHeight)];
        _logoImageView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _logoImageView;
}

- (WMUnderLineView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(0, PhoneViewY, Screen_Width, PhoneViewHeight) withType:WMUnderLineViewTypeNormal];
        _phoneView.imageView.image = [UIImage imageNamed:@"login_phone"];
//        _phoneView.rightImageView.image = [UIImage imageNamed:@"login_cancel"];
        _phoneView.textField.placeholder = @"输入手机号";
        _phoneView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneView.textField.adjustsFontSizeToFitWidth = YES;
    }
    return _phoneView;
}

- (WMUnderLineView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(0, PasswordViewY, Screen_Width, PasswordViewHeight) withType:WMUnderLineViewTypeNormal];
        _passwordView.imageView.image = [UIImage imageNamed:@"login_password"];
//        _passwordView.rightImageView.image = [UIImage imageNamed:@"login_eye"];
        _passwordView.textField.placeholder = @"输入密码";
//        _passwordView.textField.leftViewMode = UITextFieldViewModeAlways;
        _passwordView.textField.secureTextEntry = YES;
        _passwordView.textField.clearButtonMode = UITextFieldViewModeNever;
        _passwordView.textField.adjustsFontSizeToFitWidth = YES;
    }
    return _passwordView;
}

- (UIView *)wechatView {
    if (!_wechatView) {
        CGFloat wechatButtonX = 250;
        CGFloat wechatButtonY = PasswordViewY + PasswordViewHeight + 13;
        CGFloat wechatButtonW = 87;
        CGFloat wechatButtonH = 14;
        _wechatView = [[UIView alloc] initWithFrame:WM_CGRectMake(wechatButtonX, wechatButtonY, wechatButtonW, wechatButtonH)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, 21, 17)];
        imageView.image = [UIImage imageNamed:@"login_weixin"];
        [_wechatView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:WM_CGRectMake(21+5, 0, 99, 17)];
        label.text = @"微信登录";
        label.textColor = [WMUIUtility color:@"0x23938b"];
        label.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        [_wechatView addSubview:label];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechat)];
        [_wechatView addGestureRecognizer:recognizer];
    }
    return _wechatView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(LoginButtonX, LoginButtonY, LoginButtonW, LoginButtonHeight)];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.backgroundColor = [WMUIUtility color:@"0x23938b"];
        _loginButton.titleLabel.textColor = [WMUIUtility color:@"0xffffff"];
        [_loginButton.layer setCornerRadius:4];
        _loginButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        [_loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UILabel *)registerLabel {
    if (!_registerLabel) {
        _registerLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(RegisterLabelX, RegisterLabelY, RegisterLabelWidth, RegisterLabelHeight)];
        _registerLabel.text = @"注册";
        _registerLabel.textAlignment = NSTextAlignmentCenter;
        _registerLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        _registerLabel.textColor = [WMUIUtility color:@"0x23938b"];
        _registerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doRegister)];
        [_registerLabel addGestureRecognizer:recognizer];
    }
    return _registerLabel;
}

- (UILabel *)forgetLabel {
    if (!_forgetLabel) {
        _forgetLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(ForgetLabelX, ForgetLabelY, ForgetLabelWidth, ForgetLabelHeight)];
        _forgetLabel.text = @"忘记密码？";
        _forgetLabel.textAlignment = NSTextAlignmentCenter;
        
        _forgetLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        _forgetLabel.textColor = [WMUIUtility color:@"0x23938b"];
        _forgetLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doForgetPassword)];
        [_forgetLabel addGestureRecognizer:recognizer];
    }
    return _forgetLabel;
}

@end
