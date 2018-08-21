//
//  WMFeedBackChooseQuestionViewController.h
//  MiWei
//
//  Created by LiFei on 2018/8/21.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMViewController.h"
#import "WMFeedBackQuestion.h"

@protocol WMFeedBackChooseQuestionDelegate <NSObject>
- (void)onQuestionSelect:(WMFeedBackQuestion *)question;
@end

@interface WMFeedBackChooseQuestionViewController : WMViewController
@property (nonatomic, weak) id<WMFeedBackChooseQuestionDelegate> delegate;
@end
