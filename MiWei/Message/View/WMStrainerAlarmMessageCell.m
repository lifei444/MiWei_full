//
//  WMStrainerAlartMessageCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/6.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMStrainerAlarmMessageCell.h"
#import "WMUIUtility.h"

@implementation WMStrainerAlarmMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)loadSubViews {
    
}

- (void)setDataModel:(id)model {
    
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:269];
}

@end
