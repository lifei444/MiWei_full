//
//  WMWeatherCell.m
//  WeiMi
//
//  Created by Sin on 2018/4/10.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMMessageCell.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

#define cellH 150

@interface WMMessageCell()
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UILabel *weatherLabel;
@property (nonatomic,strong) UILabel *pmLabel;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UILabel *outerLabel;
@end

@implementation WMMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [super cellWithTableView:tableView];
}

- (void)loadSubViews {
    self.backImageView = [[UIImageView alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, cellH-8)];
    self.backImageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.backImageView];
    
    CGFloat cityLabelX = 15;
    CGFloat cityLabelY = 35;
    CGFloat cityLabelWidth = 80;
    CGFloat cityLabelHeight = 50;
    self.cityLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(cityLabelX, cityLabelY, cityLabelWidth, cityLabelHeight)];
    self.cityLabel.text = @"北京";
    self.cityLabel.font = [UIFont systemFontOfSize:30];
    self.cityLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.cityLabel];
    [self.cityLabel sizeToFit];
    
    CGFloat weatherLabelX = CGRectGetMaxX(self.cityLabel.frame )+8;
    CGFloat weatherLabelHeight = 35;
    CGFloat weatherLabelY = cityLabelY+cityLabelHeight-weatherLabelHeight;
    CGFloat weatherLabelWidth = 80;
    self.weatherLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(weatherLabelX, weatherLabelY, weatherLabelWidth, weatherLabelHeight)];
    self.weatherLabel.text = @"晴";
    self.weatherLabel.font = [UIFont systemFontOfSize:15];
    self.weatherLabel.textAlignment = NSTextAlignmentLeft;
    self.weatherLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.weatherLabel];
    
    
    CGFloat pmLabellWidth = 80+20;
    CGFloat pmLabelX = Screen_Width - cityLabelX -pmLabellWidth;
    CGFloat pmLabelHeight = cityLabelHeight;
    CGFloat pmLabelY = cityLabelY;
    self.pmLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(pmLabelX, pmLabelY, pmLabellWidth, pmLabelHeight)];
    self.pmLabel.text = @"PM2.5";
    self.pmLabel.font = [UIFont systemFontOfSize:30];
    self.pmLabel.textAlignment = NSTextAlignmentLeft;
    self.pmLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.pmLabel];
    
    CGFloat temperatureLabellWidth = 80+60;
    CGFloat temperatureLabelX = cityLabelX;
    CGFloat temperatureLabelHeight = weatherLabelHeight;
    CGFloat temperatureLabelY = cityLabelY + cityLabelHeight;
    self.temperatureLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(temperatureLabelX, temperatureLabelY, temperatureLabellWidth, temperatureLabelHeight)];
    self.temperatureLabel.text = @"湿度20% 温度20'";
    self.temperatureLabel.font = [UIFont systemFontOfSize:15];
    self.temperatureLabel.textAlignment = NSTextAlignmentLeft;
    self.temperatureLabel.textColor = [UIColor whiteColor];
    [self.backImageView addSubview:self.temperatureLabel];
    
    CGFloat outerLabellWidth = temperatureLabellWidth;
    CGFloat outerLabelX = Screen_Width - cityLabelX - outerLabellWidth;
    CGFloat outerLabelHeight = temperatureLabelHeight;
    CGFloat outerLabelY = cityLabelY + cityLabelHeight;
    self.outerLabel = [[UILabel alloc] initWithFrame:WM_CGRectMake(outerLabelX, outerLabelY, outerLabellWidth, outerLabelHeight)];
    self.outerLabel.text = @"室内20/室外100";
    self.outerLabel.font = [UIFont systemFontOfSize:15];
    self.outerLabel.textAlignment = NSTextAlignmentLeft;
    self.outerLabel.textColor = [UIColor whiteColor];
    self.outerLabel.textAlignment = NSTextAlignmentRight;
    [self.backImageView addSubview:self.outerLabel];
}

+ (CGFloat)cellHeight {
    return cellH;
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
