//
//  WMUnderLineView.h
//  WeiMi
//
//  Created by Sin on 2018/4/12.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WMUnderLineViewTypeNormal,
    WMUnderLineViewTypeWithRightImage,
    WMUnderLineViewTypeWithRightButton,
} WMUnderLineViewType;

@interface WMUnderLineView : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UIButton *rightButton;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame withType:(WMUnderLineViewType)type;
@end
