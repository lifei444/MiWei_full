//
//  WMScanView.h
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMScanView : UIView
/**
 初始化方法
 
 @param superView 扫描view
 @return 扫描view
 */
- (instancetype)initWithSuperView:(UIView *)superView;

/**
 开始定时器
 */
- (void)startTimer;

/**
 停止定时器
 */
- (void)stopTimer;

/** 扫描框 */
@property(nonatomic, strong) UIView *scanContentView;
@end
