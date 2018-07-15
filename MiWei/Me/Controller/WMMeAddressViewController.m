//
//  WMMeAddressViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeAddressViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMMeAddressViewController ()
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UITextField *addressField;
@property(nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMMeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改地址";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.addressField];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.confirmButton];
    self.addressField.text = @"测试地址";
}

- (UILabel *)addressLabel {
    if(!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:WM_CGRectMake(0, Navi_Height+ 20, 60 ,44)];
        _addressLabel.backgroundColor = [UIColor whiteColor];
        _addressLabel.text = @"地址";
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressLabel;
}

- (UITextField *)addressField {
    if(!_addressField) {
        _addressField = [[UITextField alloc] initWithFrame:WM_CGRectMake(60, Navi_Height+20, self.view.frame.size.width-60, 44)];
        _addressField.backgroundColor = [UIColor whiteColor];
        _addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _addressField;
}

- (UIButton *)confirmButton {
    if(!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(20, Navi_Height+80, self.view.frame.size.width-40, 44)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = [UIColor greenColor];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)save {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
