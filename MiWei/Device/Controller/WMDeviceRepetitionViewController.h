//
//  WMDeviceRepetitionViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/19.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMViewController.h"
#import "WMDeviceTimer.h"

@protocol WMDeviceRepetitionDelegate<NSObject>
- (void)onRepetitionConfirm:(NSNumber *)repetition;
@end

@interface WMDeviceRepetitionViewController : WMViewController
@property (nonatomic, strong) NSNumber *repetition;
@property (nonatomic, weak)   id<WMDeviceRepetitionDelegate> delegate;
@end
