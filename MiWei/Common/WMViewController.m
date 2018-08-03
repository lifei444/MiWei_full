//
//  WMViewController.m
//  MiWei
//
//  Created by LiFei on 2018/6/17.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMViewController.h"

@interface WMViewController ()

@end

@implementation WMViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    //left button
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"register_return"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemPressed:)];
    [backButton setTintColor:[UIColor grayColor]];
    self.navigationItem.leftBarButtonItem = backButton;
     
    //title
//    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:16];
//    NSDictionary *dic = @{NSFontAttributeName:font,
//                          NSForegroundColorAttributeName: [UIColor blackColor]};
//    self.navigationController.navigationBar.titleTextAttributes = dic;
}

- (void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
