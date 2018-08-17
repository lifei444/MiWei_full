//
//  WMSearchBar.h
//  MiWei
//
//  Created by LiFei on 2018/8/17.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMSearchBarDelegate <NSObject>
@optional
- (void)onClick;
- (void)onCancel;
- (void)onSearch:(NSString *)value;
@end

@interface WMSearchBar : UIView
@property (nonatomic, weak)   id<WMSearchBarDelegate> delegate;

- (void)showCancel;
@end
