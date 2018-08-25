//
//  WMDeviceRankView.m
//  MiWei
//
//  Created by LiFei on 2018/7/24.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceRankView.h"
#import "WMUIUtility.h"

#define Image_X         5
#define Image_Width     22
#define Image_Height    22

#define Text_X          35
#define Text_Width      280

@implementation WMDeviceRankView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
        [self addSubview:self.textView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat y = (self.frame.size.height - Image_Height) / 2;
        _imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Image_X, y, Image_Width, Image_Height)];
        _imageView.image = [UIImage imageNamed:@"device_rank"];
    }
    return _imageView;
}

- (UILabel *)textView {
    if (!_textView) {
        _textView = [[UILabel alloc] initWithFrame:WM_CGRectMake(Text_X, 0, Text_Width, 70)];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [WMUIUtility color:@"0x444444"];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.numberOfLines = 0;
    }
    return _textView;
}

@end
