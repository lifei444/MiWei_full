//
//  WMScanView.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

/** 扫描内容的X值 */
#define scanContent_X       59
/** 扫描内容的Y值 */
#define scanContent_Y       (115 + 50)
#define scanContent_Width   257
#define scanContent_Height  230

@interface WMScanView()
@property(nonatomic, strong) CALayer *basedLayer;
@property(nonatomic, strong) AVCaptureDevice *device;
/** 扫描动画线(冲击波) */
@property(nonatomic, strong) UIImageView *animation_line;
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation WMScanView

/** 扫描动画线(冲击波) 的高度 */
static CGFloat const animation_line_H = 54;
/** 扫描内容外部View的alpha值 */
static CGFloat const scanBorderOutsideViewAlpha = 0.4;
/** 定时器和动画的时间 */
static CGFloat const timer_animation_Duration = 0.05;

- (instancetype)initWithSuperView:(UIView *)superView {
    return [self initWithFrame:superView.bounds outsideViewLayer:superView.layer];
}

- (instancetype)initWithFrame:(CGRect)frame outsideViewLayer:(CALayer *)outsideViewLayer {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:scanBorderOutsideViewAlpha];
        _basedLayer = outsideViewLayer;
        // 创建扫描边框
        [self setupScanningQRCodeEdging];
    }
    return self;
}

+ (instancetype)scanningQRCodeViewWithFrame:(CGRect)frame outsideViewLayer:(CALayer *)outsideViewLayer {
    return [[self alloc] initWithFrame:frame outsideViewLayer:outsideViewLayer];
}

// 创建扫描边框
- (void)setupScanningQRCodeEdging {
    // 扫描内容的创建
    self.scanContentView = [[UIView alloc] init];
    CGFloat scanContentViewX = scanContent_X;
    CGFloat scanContentViewY = scanContent_Y;
    CGFloat scanContentViewW = scanContent_Width;
    CGFloat scanContentViewH = scanContent_Height;
    self.scanContentView.frame = WM_CGRectMake(scanContentViewX, scanContentViewY, scanContentViewW, scanContentViewH);
    
    self.scanContentView.backgroundColor = [UIColor clearColor];
    [self.basedLayer addSublayer:self.scanContentView.layer];
    
    //扫描框
    UIImageView *scanImageView = [[UIImageView alloc] init];
    scanImageView.frame = WM_CGRectMake(scanContentViewX, scanContentViewY, scanContentViewW, scanContentViewH);
    scanImageView.image = [UIImage imageNamed:@"scan_edge"];
    [self.basedLayer addSublayer:scanImageView.layer];
    
    //提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = scanContent_Y + scanContent_Height + 44;
    CGFloat promptLabelW = Screen_Width;
    CGFloat promptLabelH = 14;
    promptLabel.frame = WM_CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14.0];
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = @"请对准设备上的二维码";
    [self addSubview:promptLabel];
}

#pragma mark - - - 执行定时器方法
- (void)animation_line_action {
    __block CGRect frame = _animation_line.frame;
    
    static BOOL flag = YES;
    
    if (flag) {
        frame.origin.y = [WMUIUtility WMCGFloatForY:scanContent_Y];
        flag = NO;
        [UIView animateWithDuration:timer_animation_Duration
                         animations:^{
                             frame.origin.y += 5;
                             _animation_line.frame = frame;
                         }
                         completion:nil];
    } else {
        if (_animation_line.frame.origin.y >= [WMUIUtility WMCGFloatForY:scanContent_Y]) {
            CGFloat scanContent_MaxY = [WMUIUtility WMCGFloatForY:(scanContent_Y + scanContent_Height)];
            if (_animation_line.frame.origin.y >= scanContent_MaxY - animation_line_H - 15) {
                frame.origin.y = [WMUIUtility WMCGFloatForY:scanContent_Y];
                _animation_line.frame = frame;
                flag = YES;
            } else {
                [UIView animateWithDuration:timer_animation_Duration
                                 animations:^{
                                     frame.origin.y += 5;
                                     _animation_line.frame = frame;
                                 }
                                 completion:nil];
            }
        } else {
            flag = !flag;
        }
    }
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timer_animation_Duration
                                                  target:self
                                                selector:@selector(animation_line_action)
                                                userInfo:nil
                                                 repeats:YES];
    [self.basedLayer addSublayer:self.animation_line.layer];
}

/** 移除定时器 */
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.animation_line.layer removeFromSuperlayer];
    [self.animation_line removeFromSuperview];
}

- (UIImageView *)animation_line {
    if (!_animation_line) {
        // 扫描动画添加
        _animation_line = [[UIImageView alloc] init];
        _animation_line.image = [UIImage imageNamed:@"scan_animation_line"];
        _animation_line.frame =
        WM_CGRectMake(scanContent_X, scanContent_Y, scanContent_Width, animation_line_H);
    }
    return _animation_line;
}

@end
