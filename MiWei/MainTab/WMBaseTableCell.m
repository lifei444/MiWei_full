//
//  WMBaseCell.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMBaseTableCell.h"

@implementation WMBaseTableCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WMBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if(!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    NSLog(@"%s 子类必须实现此方法",__func__);
}

- (void)setDataModel:(id)model {
    NSLog(@"%s 子类必须实现此方法",__func__);
}

+ (CGFloat)cellHeight {
    NSLog(@"%s 子类必须实现此方法",__func__);
    return 50;
}
@end
