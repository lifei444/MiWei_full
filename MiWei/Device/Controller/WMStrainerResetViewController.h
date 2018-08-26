//
//  WMStrainerResetViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/26.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMStrainerResetViewControllerDelegate <NSObject>
- (void)onDismiss;
@end

@interface WMStrainerResetViewController : UIViewController
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, weak) id<WMStrainerResetViewControllerDelegate> delegate;
@end
