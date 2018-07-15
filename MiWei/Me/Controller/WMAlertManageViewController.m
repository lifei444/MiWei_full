//
//  WMAlertManageViewController.m
//  MiWei
//
//  Created by LiFei on 2018/6/17.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMAlertManageViewController.h"

@interface WMAlertManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WMAlertManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警管理";
    [self.view addSubview:self.tableView];
}

//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    if(indexPath.row == 0) {
//        cell.textLabel.text = @"头像";
//        //        cell.imageView.image = [UIImage imageNamed:@"person_portrait"];
//    }else if(indexPath.row == 1) {
//        cell.textLabel.text = @"昵称";
//        cell.detailTextLabel.text= @"Megeid";
//    }else {
//        cell.textLabel.text = @"地址";
//        cell.detailTextLabel.text= @"北京市海淀区";
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row == 0) {
//        return 80;
//    }else {
//        return 50;
//    }
//}

@end
