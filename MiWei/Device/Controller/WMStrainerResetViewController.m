//
//  WMStrainerResetViewController.m
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMStrainerResetViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"
#import "WMHTTPUtility.h"
#import "MBProgressHUD.h"
#import "WMDeviceStrainerStatus.h"
#import "WMDeviceStrainerStatusCell.h"

#define BG_Width                        320
#define BG_Height                       388
#define BG_X                            (Screen_Width - BG_Width) / 2
#define BG_Y                            (Screen_Height - BG_Height) / 2

#define Title_Y                         27
#define Title_Height                    15

#define GapBetweenTitleAndContainer     5

#define Container_Y                     (Title_Y + Title_Height + GapBetweenTitleAndContainer)
#define Container_Height                300

#define Container_Cell_Height           30

#define ResetButton_Width               44
#define ResetButton_Height              Container_Cell_Height

#define Seperator_Y                     (Container_Y + Container_Height)
#define Seperator_Height                1

#define CompleteButton_Y                (Seperator_Y + Seperator_Height)
#define CompleteButton_Height           40

@interface WMStrainerResetViewController () <WMDeviceStrainerStatusCellDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *seperator;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSArray <WMDeviceStrainerStatus *> *modelArray;
@property (nonatomic, strong) UILabel *noDataLabel;
@end

@implementation WMStrainerResetViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgView];
    [self loadData];
}

#pragma mark - Target action
- (void)onComplete {
    if ([self.delegate respondsToSelector:@selector(onDismiss)]) {
        [self.delegate onDismiss];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WMDeviceStrainerStatusCellDelegate
- (void)onReset:(NSInteger)tag {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", self.modelArray[tag].strainerIndex, @"resetStrainerIndex", nil];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodPost
                               URLString:@"/mobile/device/control"
                              parameters:dic
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            self.modelArray[tag].remainingRatio = 100;
                                            [self refreshView];
                                        } else {
                                            [WMUIUtility showAlertWithMessage:@"复位失败" viewController:self];
                                        }
                                    });
                                }];
}

#pragma mark - Private method
- (void)loadData {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMHTTPUtility requestWithHTTPMethod:WMHTTPRequestMethodGet
                               URLString:@"/mobile/device/queryStrainerStatus"
                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:self.deviceId, @"deviceID", nil]
                                response:^(WMHTTPResult *result) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.hud hideAnimated:YES];
                                        if (result.success) {
                                            NSMutableArray *arr = [[NSMutableArray alloc] init];
                                            for (NSDictionary *dic in result.content) {
                                                WMDeviceStrainerStatus *status = [WMDeviceStrainerStatus statusWithDic:dic];
                                                [arr addObject:status];
                                            }
                                            self.modelArray = arr;
                                            [self refreshView];
                                        } else {
                                            [WMUIUtility showAlertWithMessage:@"数据加载失败" viewController:self];
                                        }
                                    });
                                }];
}

- (void)refreshView {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.modelArray.count > 0) {
        self.noDataLabel.hidden = YES;
        int cellHeight = Container_Height / self.modelArray.count;
        //gap 有上下两个
        int gap = (cellHeight - Container_Cell_Height) / 2;
        int cellY = gap;
        for (int i = 0; i < self.modelArray.count; i++) {
            WMDeviceStrainerStatusCell *cell = [[WMDeviceStrainerStatusCell alloc] initWithFrame:WM_CGRectMake(0, cellY, BG_Width, Container_Cell_Height)];
            cell.tag = i;
            cell.nameLabel.text = self.modelArray[i].strainerName;
            cell.delegate = self;
            if (self.modelArray[i].remainingRatio < 0) {
                self.modelArray[i].remainingRatio = 0;
            }
            cell.progressView.progress = self.modelArray[i].remainingRatio/100;
            int value = self.modelArray[i].remainingRatio;
            cell.valueLabel.text = [NSString stringWithFormat:@"%d%%", value];
            cellY += cellHeight;
            [self.containerView addSubview:cell];
        }
    } else {
        self.noDataLabel.hidden = NO;
    }
}

#pragma mark - Getters & setters
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:WM_CGRectMake(BG_X, BG_Y, BG_Width, BG_Height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:self.titleLabel];
        [_bgView addSubview:self.containerView];
        [_bgView addSubview:self.seperator];
        [_bgView addSubview:self.completeButton];
        [_bgView addSubview:self.noDataLabel];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, Title_Y, BG_Width, Title_Height)];
        _titleLabel.text = @"滤网复位";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:15]];
    }
    return _titleLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:WM_CGRectMake(0, Container_Y, BG_Width, Container_Height)];
        
    }
    return _containerView;
}

- (UIView *)seperator {
    if (!_seperator) {
        _seperator = [[UIView alloc] initWithFrame:WM_CGRectMake(0, Seperator_Y, BG_Width, Seperator_Height)];
        _seperator.backgroundColor = [WMUIUtility color:@"0x666666"];
    }
    return _seperator;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(0, CompleteButton_Y, BG_Width, CompleteButton_Height)];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[WMUIUtility color:@"0x23938b"] forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(onComplete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(0, 0, BG_Width, BG_Height)];
        _noDataLabel.text = @"暂无滤网";
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [WMUIUtility color:@"0x444444"];
    }
    return _noDataLabel;
}
@end
