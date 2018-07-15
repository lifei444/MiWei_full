//
//  WMDeviceInfoHeadView.m
//  WeiMi
//
//  Created by Sin on 2018/4/15.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceInfoHeadView.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

#define ViewHeight 280

@interface WMDeviceInfoHeadView ()
@property (weak, nonatomic) IBOutlet UIButton *bindDeviceButton;
@property (weak, nonatomic) IBOutlet UIButton *rankButton;
@property (weak, nonatomic) IBOutlet UILabel *innerPMLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UILabel *outerPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *snLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseDeviceButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseSNButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseMacButton;

@end

@implementation WMDeviceInfoHeadView
+ (instancetype)headView {
    return [[self alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, ViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}
- (IBAction)bindDevice:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)rank:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)chooseAddress:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)chooseDevice:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)chooseSn:(id)sender {
    NSLog(@"%s",__func__);
}
- (IBAction)chooseMac:(id)sender {
    NSLog(@"%s",__func__);
}

+ (CGFloat)viewHeight {
    return ViewHeight;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
