//
//  WMDeviceDataView.h
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMDeviceDataView : UIView

@property (nonatomic, strong) UILabel *PMLabel;
@property (nonatomic, strong) UILabel *co2Label;
@property (nonatomic, strong) UILabel *ch2oLabel;//甲醛
@property (nonatomic, strong) UILabel *tvocLabel;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *humidityLabel;//湿度

@end
