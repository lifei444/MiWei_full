//
//  WMMessageBaseCell.h
//  MiWei
//
//  Created by LiFei on 2018/8/9.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMBaseTableCell.h"
#import "WMMessageCellFooterView.h"

@interface WMMessageBaseCell : WMBaseTableCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WMMessageCellFooterView *footerView;

- (NSString *)timeStringWithTimestamp:(NSNumber *)timestamp;

@end
