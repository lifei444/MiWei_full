//
//  WMDeviceStrainerStatusCell.h
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WMDeviceStrainerStatusCellDelegate <NSObject>
- (void)onReset:(NSInteger)tag;
@end

@interface WMDeviceStrainerStatusCell : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, weak)   id<WMDeviceStrainerStatusCellDelegate> delegate;
@end
