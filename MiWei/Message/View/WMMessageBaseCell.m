//
//  WMMessageBaseCell.m
//  MiWei
//
//  Created by LiFei on 2018/8/9.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageBaseCell.h"
#import "WMUIUtility.h"
#import "WMCommonDefine.h"

@interface WMMessageBaseCell ()
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

#define Content_Width   MessageCell_Width
#define Content_X       (Screen_Width - Content_Width)/2

@implementation WMMessageBaseCell

- (void)loadSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.footerView];
}

- (void)setFrame:(CGRect)frame {
    frame.size.width = [WMUIUtility WMCGFloatForX:Content_Width];
    frame.origin.x = [WMUIUtility WMCGFloatForX:Content_X];
    [super setFrame:frame];
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
        CGFloat y = [[self class] cellHeight] - [WMUIUtility WMCGFloatForY:45];
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
