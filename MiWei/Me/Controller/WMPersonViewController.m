//
//  WMPersonViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/11.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMPersonViewController.h"
#import "WMMeAddressViewController.h"
#import "WMMeNameViewController.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "WMMePortraitCell.h"

@interface WMPersonViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)UIImagePickerController *picker;
@property(nonatomic, strong) MBProgressHUD *hud;
@end

@implementation WMPersonViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WMMePortraitCell *cell = [WMMePortraitCell cellWithTableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = @"头像";
        [cell.portraitView sd_setImageWithURL:[WMHTTPUtility urlWithPortraitId:[WMHTTPUtility currentProfile].portrait] placeholderImage:[UIImage imageNamed:@"me_portrait"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [WMUIUtility color:@"0x444444"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text= [WMHTTPUtility currentProfile].nickname;
        } else {
            cell.textLabel.text = @"地址";
            WMProfile *profile = [WMHTTPUtility currentProfile];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@", profile.region.lev1?:@"", profile.region.lev2?:@"", profile.region.lev3?:@"", profile.addrDetail?:@""];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [WMUIUtility WMCGFloatForY:80];
    } else {
        return [WMUIUtility WMCGFloatForY:50];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"拍照"
                                                        otherButtonTitles:@"从相册选择", nil];
        [actionSheet showInView:self.view];
    } else if(indexPath.row == 1) {
        WMMeNameViewController *vc = [[WMMeNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WMMeAddressViewController *vc = [[WMMeAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.picker.showsCameraControls = YES;
            } else {
                NSLog(@"模拟器无法连接相机");
            }
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
            
        case 1:
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.label.text = @"上传图片中";
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [WMHTTPUtility uploadFile:data
                     response:^(WMHTTPResult *result) {
                         if (result.success) {
                             NSDictionary *content = result.content;
                             NSString *fileId = content[@"fileID"];
                             [WMHTTPUtility currentProfile].portrait = fileId;
                             NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                             [d setObject:fileId forKey:@"portraitID"];
                             [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                                                        URLString:@"/mobile/user/editUserInfo"
                                                       parameters:d
                                                         response:^(WMHTTPResult *result) {
                                                             if (result.success) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.hud hideAnimated:YES];
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"WMProfileUpdate" object:nil];
                                                                     [self.tableView reloadData];
                                                                 });
                                                             } else {
                                                                 NSLog(@"imagePickerController, set error");
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.hud hideAnimated:YES];
                                                                 });
                                                             }
                                                         }];
                         } else {
                             NSLog(@"imagePickerController, upload error");
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.hud hideAnimated:YES];
                             });
                         }
                     }];
}

#pragma mark - Getters and setters
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImagePickerController *)picker {
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = NO;
    }
    return _picker;
}

@end
