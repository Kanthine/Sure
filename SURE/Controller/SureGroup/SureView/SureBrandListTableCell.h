//
//  SureBrandListTableCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

@interface SureBrandListTableCell : UITableViewCell

@property (nonatomic ,strong) BaseViewController *currentViewController;

- (void)refreshBrandListScrollViewWithBrandArray:(NSMutableArray *)userArray;

@end
