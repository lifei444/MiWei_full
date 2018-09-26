//
//  WMDeviceAddressView.h
//  MiWei
//
//  Created by LiFei on 2018/7/22.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMDeviceAddressView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

- (void)adjustLabelSize:(NSString *)shortString;
@end
