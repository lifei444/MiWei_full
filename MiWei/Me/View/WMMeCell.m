//
//  WMMeCell.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMeCell.h"
#import "WMUIUtility.h"

@interface WMMeCell ()
@property (nonatomic,strong) UIImageView *detailImageView;
@end

@implementation WMMeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [super cellWithTableView:tableView];
}

- (void)loadSubViews {
    self.iconImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(30, 17, 16, 16)];
    self.label = [[UILabel alloc] initWithFrame:WM_CGRectMake(67, 4, 100, 42)];
    self.label.textColor = [WMUIUtility color:@"0x333333"];
    self.detailImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(346, 19, 6, 11)];
    self.detailImageView.image = [UIImage imageNamed:@"me_detail"];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.detailImageView];
}

+ (CGFloat)cellHeight {
    return 50;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
