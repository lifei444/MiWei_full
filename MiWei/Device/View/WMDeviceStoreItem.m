//
//  WMDeviceStoreItem.m
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMDeviceStoreItem.h"
#import "WMUIUtility.h"

#define Image_X         10
#define Image_Y         5
#define Image_Width     19
#define Image_Height    18

#define Label_X         35
#define Label_Width     40

#define Item_Height     28

@implementation WMDeviceStoreItem
#pragma mark - Life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [WMUIUtility color:@"0x126168"];
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark - Getters & setters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(Image_X, Image_Y, Image_Width, Image_Height)];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:WM_CGRectMake(Label_X, 0, Label_Width, Item_Height)];
        _label.textColor = [WMUIUtility color:@"0xffffff"];
        _label.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:16]];
    }
    return _label;
}
@end
