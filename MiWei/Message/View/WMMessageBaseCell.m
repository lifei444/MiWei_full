//
//  WMMessageBaseCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/9.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageBaseCell.h"
#import "WMUIUtility.h"

@interface WMMessageBaseCell ()
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation WMMessageBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.footerView];
    }
    return self;
}

- (NSString *)timeStringWithTimestamp:(NSNumber *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue] / 1000];
    return [self.formatter stringFromDate:date];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(15, 17, 300, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:[WMUIUtility WMCGFloatForY:18]];
    }
    return _titleLabel;
}

- (WMMessageCellFooterView *)footerView {
    if (!_footerView) {
        CGFloat y = [WMUIUtility WMCGFloatForY:269-45];
        _footerView = [[WMMessageCellFooterView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, [WMUIUtility WMCGFloatForY:45])];
    }
    return _footerView;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
//        [_formatter setDateStyle:NSDateFormatterShortStyle];
        [_formatter setDateFormat:@"yyyy-MM-dd   HH:mm:ss"];
    }
    return _formatter;
}

@end
