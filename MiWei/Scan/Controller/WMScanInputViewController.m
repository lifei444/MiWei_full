//
//  WMScanInputViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMScanInputViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMScanInputViewController ()
@property (nonatomic,strong) UITextField *SNTextField;
@property (nonatomic,strong) UILabel *SNLabel;
@property (nonatomic,strong) UIButton *confirmButton;
@end

@implementation WMScanInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    titleLabel.text = @"手动输入";
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor blackColor];
    [self setRightNavBar];
    [self loadSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
}

- (void)setRightNavBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, 0, 80, 30)];
    [btn setTitle:@"切换扫描" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)setting:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadSubViews {
    CGFloat SNTextFieldX = 35;
    CGFloat SNTextFieldY = 100;
    CGFloat SNTextFieldW = Screen_Width - 2 *SNTextFieldX;
    CGFloat SNTextFieldH = 44;
    
    self.SNTextField = [[UITextField alloc] initWithFrame:WM_CGRectMake(SNTextFieldX, SNTextFieldY, SNTextFieldW, SNTextFieldH)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"请输入设备SN号" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:style}];
    self.SNTextField.backgroundColor = [UIColor whiteColor];
    self.SNTextField.attributedPlaceholder = attri;
    [self.view addSubview:self.SNTextField];
    
    CGFloat SNLabelX = 35;
    CGFloat SNLabelY = CGRectGetMaxY(self.SNTextField.frame)+10;
    CGFloat SNLabelW = Screen_Width - 2 *SNTextFieldX;
    CGFloat SNLabelH = 44;
    
    self.SNLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(SNLabelX, SNLabelY, SNLabelW, SNLabelH)];
    self.SNLabel.textColor = [UIColor whiteColor];
    self.SNLabel.text = @"请输入设备SN号";
    [self.view addSubview:self.SNLabel];
    
    CGFloat confirmButtonX = 35;
    CGFloat confirmButtonY = CGRectGetMaxY(self.SNLabel.frame)+30;
    CGFloat confirmButtonW = Screen_Width - 2 *SNTextFieldX;
    CGFloat confirmButtonH = 44;
    
    self.confirmButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(confirmButtonX, confirmButtonY, confirmButtonW, confirmButtonH)];
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    self.confirmButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.confirmButton];
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
