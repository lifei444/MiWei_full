//
//  WMPayRecordCell.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMPayRecordCell.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMPayRecordCell()
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation WMPayRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataModel:(id)model {
    self.nameLabel.text = @"小明的设备";
    self.dateLabel.text = @"2018-3-21";
    self.priceLabel.text = @"1元/1小时";
    self.timeLabel.text = @"1:20:10";
}

- (void)loadSubViews {
    CGFloat nameLabelX = 20;
    CGFloat nameLabelY = 25;
    CGFloat nameLabelW = 100;
    CGFloat nameLabelH = 20;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLabel];
    
    CGFloat dateLabelX = nameLabelX;
    CGFloat dateLabelY = CGRectGetMaxY(self.nameLabel.frame)+10;
    CGFloat dateLabelW = 100;
    CGFloat dateLabelH = 20;
    
    self.dateLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(dateLabelX, dateLabelY, dateLabelW, dateLabelH)];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.dateLabel];
    
    
    CGFloat priceLabelW = 100;
    CGFloat priceLabelX = Screen_Width -priceLabelW - 20;
    CGFloat priceLabelY = nameLabelY;
    CGFloat priceLabelH = 20;
    
    self.priceLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH)];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    
    CGFloat timeLabelW = 100;
    CGFloat timeLabelX = Screen_Width -timeLabelW - 20;
    CGFloat timeLabelY = dateLabelY;
    CGFloat timeLabelH = 20;
    
    self.timeLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH)];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
}

+ (CGFloat)cellHeight {
    return 88;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
