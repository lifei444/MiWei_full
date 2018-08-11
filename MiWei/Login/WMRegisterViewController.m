//
//  WMRegisterViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMRegisterViewController.h"
#import "WMUnderLineView.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"

#define WaitSeconds     3

#define ViewX           0
#define ViewWidth       Screen_Width

#define PhoneY          (40 + Navi_Height)
#define ViewHeight      30
#define Gap             30
#define VerifyY         (PhoneY + ViewHeight + Gap)
#define PassY           (VerifyY + ViewHeight + Gap)
#define ConfirmY        (PassY + ViewHeight + Gap)
#define Gap2            87
#define RegisterY       (ConfirmY + ViewHeight + Gap2)
#define RegisterHeight  44

#define RegisterX       37
#define RegisterW       300

@interface WMRegisterViewController ()
@property (nonatomic,strong) WMUnderLineView *phoneView;
@property (nonatomic,strong) WMUnderLineView *verifyView;
@property (nonatomic,strong) WMUnderLineView *passView;
@property (nonatomic,strong) WMUnderLineView *confirmView;
@property (nonatomic,strong) UIButton *registerButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int count;
@end

@implementation WMRegisterViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.count = WaitSeconds;
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.verifyView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.confirmView];
    [self.view addSubview:self.registerButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

#pragma mark - Target action
- (void)registerAction {
    if ([self.passView.textField.text isEqualToString:self.confirmView.textField.text]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.phoneView.textField.text forKey:@"phone"];
        [dic setObject:self.passView.textField.text forKey:@"userPwd"];
        [dic setObject:self.verifyView.textField.text forKey:@"verifiedCode"];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"/mobile/user/register"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (result.success) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                NSLog(@"registerAction error");
                                                [WMUIUtility showAlertWithMessage:@"注册失败" viewController:self];
                                            }
                                        });
                                    }];
    }
}

- (void)startTimer {
    if (!self.timer) {
        [self sendVerifyCode:self.phoneView.textField.text];
        [self.phoneView.rightButton setTitle:[NSString stringWithFormat:@"重新发送(%d)", self.count--] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
}

#pragma mark - Private methods
- (void)countDown {
    if (self.count > 0) {
        [self.phoneView.rightButton setTitle:[NSString stringWithFormat:@"重新发送(%d)", self.count--] forState:UIControlStateNormal];
    } else {
        if([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self.phoneView.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.count = WaitSeconds;
    }
}

- (void)sendVerifyCode:(NSString *)phone {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:phone forKey:@"phone"];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/common/verifiedCode/send"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    if (result.success) {
                                        
                                    } else {
                                        NSLog(@"sendVerifyCode error");
                                    }
                                }];
}

#pragma mark - Getters and setters
- (WMUnderLineView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, PhoneY, ViewWidth, ViewHeight) withType:WMUnderLineViewTypeWithRightButton];
        _phoneView.imageView.image = [UIImage imageNamed:@"register_phone"];
        _phoneView.textField.placeholder = @"输入手机号";
        [_phoneView.rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_phoneView.rightButton setTitleColor:[WMUIUtility color:@"0x999999"] forState:UIControlStateNormal];
        _phoneView.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_phoneView.rightButton addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneView;
}

- (WMUnderLineView *)verifyView {
    if (!_verifyView) {
        _verifyView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, VerifyY, ViewWidth, ViewHeight)];
        _verifyView.imageView.image = [UIImage imageNamed:@"register_verify"];
        _verifyView.textField.placeholder = @"输入验证码";
    }
    return _verifyView;
}

- (WMUnderLineView *)passView {
    if (!_passView) {
        _passView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, PassY, ViewWidth, ViewHeight)];
        _passView.imageView.image = [UIImage imageNamed:@"register_password"];
        _passView.textField.placeholder = @"输入密码";
        _passView.textField.secureTextEntry = YES;
    }
    return _passView;
}

- (WMUnderLineView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, ConfirmY, ViewWidth, ViewHeight)];
        _confirmView.imageView.image = [UIImage imageNamed:@"register_password"];
        _confirmView.textField.placeholder = @"确认密码";
        _confirmView.textField.secureTextEntry = YES;
    }
    return _confirmView;
}

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(RegisterX, RegisterY, RegisterW, RegisterHeight)];
        _registerButton.backgroundColor = [WMUIUtility color:@"0x23938b"];
        _registerButton.titleLabel.textColor = [WMUIUtility color:@"0xffffff"];
        [_registerButton.layer setCornerRadius:4];
        _registerButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        [_registerButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    }
    return _registerButton;
}

@end
