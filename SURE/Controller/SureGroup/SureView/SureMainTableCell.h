//
//  SureMainTableCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SureTapSupportView.h"

@class BaseViewController;

@interface LineLable : UILabel

@end

@interface SureMainTableCell : UITableViewCell

@property (nonatomic ,strong) NSIndexPath *indexPath;

@property (strong, nonatomic)  UILabel *statusLable;

@property (nonatomic ,weak) BaseViewController *currentViewController;



- (void)updateSureMainCellDataWithModel:(SUREModel *)model;

- (void)updateTapViewWithTapModel:(SURETapModel *)tapModel;

@end
