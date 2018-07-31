//
//  WMMePortraitCell.m
//  MiWei
//
//  Created by LiFei on 2018/7/31.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMePortraitCell.h"
#import "WMUIUtility.h"

@implementation WMMePortraitCell

- (void)loadSubViews {
    self.portraitView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(280, 14, 52, 52)];
    [self.contentView addSubview:self.portraitView];
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:80];
}

@end
