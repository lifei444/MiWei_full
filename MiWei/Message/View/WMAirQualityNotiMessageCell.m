//
//  WMAirQualityNotiMessageCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/6.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMAirQualityNotiMessageCell.h"
#import "WMUIUtility.h"

@implementation WMAirQualityNotiMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)loadSubViews {
    
}

- (void)setDataModel:(id)model {
    
}

+ (CGFloat)cellHeight {
    return [WMUIUtility WMCGFloatForY:280];
}

@end
