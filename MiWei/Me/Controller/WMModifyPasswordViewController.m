//
//  WMModifyPasswordViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMModifyPasswordViewController.h"
#import "WMUnderLineView.h"
#import "WMHTTPUtility.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

#define WaitSeconds     60

#define ViewX           0
#define ViewWidth       Screen_Width

#define PhoneY          (40 + Navi_Height)
#define ViewHeight      30
#define Gap             30
#define VerifyY         (PhoneY + ViewHeight + Gap)
#define OldPassY        (VerifyY + ViewHeight + Gap)
#define PassY           (OldPassY + ViewHeight + Gap)
#define ConfirmY        (PassY + ViewHeight + Gap)
#define Gap2            50
#define RegisterY       (ConfirmY + ViewHeight + Gap2)
#define RegisterHeight  44

#define RegisterX       37
#define RegisterW       300

@interface WMModifyPasswordViewController () <UITextFieldDelegate>
@property (nonatomic,strong) WMUnderLineView *phoneView;
@property (nonatomic,strong) WMUnderLineView *verifyView;
@property (nonatomic,strong) WMUnderLineView *oldPassView;
@property (nonatomic,strong) WMUnderLineView *passView;
@property (nonatomic,strong) WMUnderLineView *confirmView;
@property (nonatomic,strong) UIButton *modifyButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int count;
@end

@implementation WMModifyPasswordViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.count = WaitSeconds;
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.verifyView];
    [self.view addSubview:self.oldPassView];
    [self.view addSubview:self.passView];
    [self.view addSubview:self.confirmView];
    [self.view addSubview:self.modifyButton];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

#pragma mark - Target action
- (void)modifyAction {
    if ([self.passView.textField.text isEqualToString:self.confirmView.textField.text]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self.phoneView.textField.text forKey:@"phone"];
        [dic setObject:self.oldPassView.textField.text forKey:@"oldPwd"];
        [dic setObject:self.passView.textField.text forKey:@"newPwd"];
        [dic setObject:self.verifyView.textField.text forKey:@"verifiedCode"];
        [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                   URLString:@"/mobile/user/changePassword"
                                  parameters:dic
                                    response:^(WMHTTPResult *result) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (result.success) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                NSLog(@"modifyAction error");
                                                [WMUIUtility showAlertWithMessage:@"修改失败" viewController:self];
                                            }
                                        });
                                    }];
    } else {
        [WMUIUtility showAlertWithMessage:@"密码不一致" viewController:self];
    }
}

- (void)startTimer {
    if (!self.timer) {
        [self sendVerifyCode:self.phoneView.textField.text];
        [self.phoneView.rightButton setTitle:[NSString stringWithFormat:@"重新发送(%d)", self.count--] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
        _phoneView.textField.delegate = self;
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
        _verifyView.textField.delegate = self;
    }
    return _verifyView;
}

- (WMUnderLineView *)oldPassView {
    if (!_oldPassView) {
        _oldPassView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, OldPassY, ViewWidth, ViewHeight)];
        _oldPassView.imageView.image = [UIImage imageNamed:@"register_password"];
        _oldPassView.textField.placeholder = @"输入旧密码";
        _oldPassView.textField.secureTextEntry = YES;
        _oldPassView.textField.delegate = self;
    }
    return _oldPassView;
}

- (WMUnderLineView *)passView {
    if (!_passView) {
        _passView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, PassY, ViewWidth, ViewHeight)];
        _passView.imageView.image = [UIImage imageNamed:@"register_password"];
        _passView.textField.placeholder = @"输入新密码";
        _passView.textField.secureTextEntry = YES;
        _passView.textField.delegate = self;
    }
    return _passView;
}

- (WMUnderLineView *)confirmView {
    if (!_confirmView) {
        _confirmView = [[WMUnderLineView alloc] initWithFrame:WM_CGRectMake(ViewX, ConfirmY, ViewWidth, ViewHeight)];
        _confirmView.imageView.image = [UIImage imageNamed:@"register_password"];
        _confirmView.textField.placeholder = @"确认新密码";
        _confirmView.textField.secureTextEntry = YES;
        _confirmView.textField.delegate = self;
    }
    return _confirmView;
}

- (UIButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(RegisterX, RegisterY, RegisterW, RegisterHeight)];
        _modifyButton.backgroundColor = [WMUIUtility color:@"0x23938b"];
        _modifyButton.titleLabel.textColor = [WMUIUtility color:@"0xffffff"];
        [_modifyButton.layer setCornerRadius:4];
        _modifyButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:[WMUIUtility WMCGFloatForY:15]];
        [_modifyButton addTarget:self action:@selector(modifyAction) forControlEvents:UIControlEventTouchUpInside];
        [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    return _modifyButton;
}

@end
