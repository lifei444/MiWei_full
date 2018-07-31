//
//  RCEActiveWheel.m
//  RongEnterpriseApp
//
//  Created by zhaobindong on 2017/6/8.
//  Copyright © 2017年 rongcloud. All rights reserved.
//

#import "RCEActiveWheel.h"

@interface RCEActiveWheel ()
@property(nonatomic) BOOL *ptimeoutFlag;
@end

@implementation RCEActiveWheel

- (id)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.tintColor = [UIColor blackColor];
    }
    return self;
}

- (id)initWithWindow:(UIWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.processString = nil;
}

+ (RCEActiveWheel *)showHUDAddedTo:(UIView *)view {
    RCEActiveWheel *hud = [[RCEActiveWheel alloc] initWithView:view];
    hud.contentColor = [UIColor whiteColor];
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}

+ (void)showPromptHUDAddedTo:(UIView *)view text:(NSString *)text {
    RCEActiveWheel *hud = [RCEActiveWheel showHUDAddedTo:view];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];

    [hud hideAnimated:YES afterDelay:2.0f];
}

+ (void)dismissForView:(UIView *)view {
    MBProgressHUD *hud = [super HUDForView:view];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES];
}

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView *)view warningText:(NSString *)text;
{
    RCEActiveWheel *wheel = (RCEActiveWheel *)[super HUDForView:view];
    ;
    [wheel performSelector:@selector(setWarningString:) withObject:text afterDelay:0];
    [RCEActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

+ (void)dismissViewDelay:(NSTimeInterval)interval forView:(UIView *)view processText:(NSString *)text {
    RCEActiveWheel *wheel = (RCEActiveWheel *)[super HUDForView:view];
    ;
    wheel.processString = text;
    [RCEActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

+ (void)dismissForView:(UIView *)view delay:(NSTimeInterval)interval {
    [RCEActiveWheel performSelector:@selector(dismissForView:) withObject:view afterDelay:interval];
}

- (void)setProcessString:(NSString *)processString {
    // self.labelColor = [UIColor colorWithRed:219/255.0f green:78/255.0f blue:32/255.0f alpha:1];
    self.label.text = processString;
}

- (void)setWarningString:(NSString *)warningString {
    self.label.textColor = [UIColor redColor];
    self.label.text = warningString;
}


+ (void)hidePromptHUDDelay:(UIView *)view text:(NSString *)text {
    RCEActiveWheel *wheel = (RCEActiveWheel *)[super HUDForView:view];
    //  hud.square = YES;
    wheel.mode = MBProgressHUDModeText;
    wheel.label.text = nil;
    wheel.detailsLabel.text = text;
    wheel.detailsLabel.textColor = [UIColor whiteColor];
    [wheel hideAnimated:YES afterDelay:2.0f];
}

@end
