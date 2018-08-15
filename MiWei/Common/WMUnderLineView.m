//
//  WMUnderLineView.m
//  WeiMi
//
//  Created by Sin on 2018/4/12.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMUnderLineView.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@implementation WMUnderLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withType:WMUnderLineViewTypeNormal];
}

- (instancetype)initWithFrame:(CGRect)frame withType:(WMUnderLineViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews:type];
    }
    return self;
}

- (void)addSubviews:(WMUnderLineViewType)type {
    CGFloat imageViewX = 37;
    CGFloat imageViewY = 3;
    CGFloat imageViewW = 12;
    CGFloat imageViewH = 18;
    self.imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    [self addSubview:self.imageView];
    
    CGFloat textFieldX = CGRectGetMaxX(self.imageView.frame) + 15;
    CGFloat textFieldW = Screen_Width - textFieldX - 40;
    if (type == WMUnderLineViewTypeWithRightButton) {
        textFieldW -= 80;
    }
    CGFloat textFieldY = 3;
    CGFloat textFieldH = 15;
    self.textField = [[UITextField alloc] initWithFrame:WM_CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH)];
    self.textField.textColor = [WMUIUtility color:@"0x444444"];
    self.textField.font = [UIFont fontWithName:@"Heiti SC" size:[WMUIUtility WMCGFloatForY:15]];
    [self addSubview:self.textField];
    
    if (type == WMUnderLineViewTypeWithRightImage) {
        CGFloat rightImageViewX = textFieldX + textFieldW - 20;
        CGFloat rightImageViewW = 16;
        CGFloat rightImageViewY = 4;
        CGFloat rightImageViewH = 11;
        self.rightImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(rightImageViewX, rightImageViewY, rightImageViewW, rightImageViewH)];
        [self addSubview:self.rightImageView];
    }
    
    if(type == WMUnderLineViewTypeWithRightButton) {
        CGFloat rightX = 260;
        CGFloat rightY = -4;
        CGFloat rightH = 30;
        self.rightButton = [[UIButton alloc] initWithFrame:WM_CGRectMake(rightX, rightY, 80, rightH)];
        [self addSubview:self.rightButton];
    }
    
    CGFloat w = 300;
    CGFloat x = imageViewX;
    CGFloat y = 29;
    CGFloat h = 1;
    UIView *line = [[UIView alloc] initWithFrame:WM_CGRectMake(x, y, w, h)];
    line.backgroundColor = [WMUIUtility color:@"0xcdcdcd"];
    [self addSubview:line];
}

@end
