//
//  UITableView+EmptyData.h
//  MiWei
//
//  Created by LiFei on 2018/8/25.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)
- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end
