//
//  WMMeNameViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeNameViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMMeNameViewController ()
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UITextField *nameField;
@property(nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMMeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.confirmButton];
    self.nameField.text = @"测试昵称";
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:WM_CGRectMake(0, Navi_Height+ 20, 60 ,44)];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.text = @"昵称";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UITextField *)nameField {
    if(!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:WM_CGRectMake(60, Navi_Height+20, self.view.frame.size.width-60, 44)];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _nameField;
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
