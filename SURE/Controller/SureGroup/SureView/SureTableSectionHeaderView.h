//
//  SureTableSectionHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SureViewController;
@interface SureTableSectionHeaderView : UITableViewHeaderFooterView


@property (nonatomic ,weak) SureViewController *currentViewController;
@property (nonatomic ,assign) NSInteger section;


@property (strong, nonatomic) UILabel *headerTitleLable;
@property (strong, nonatomic) UIImageView *headerImageView;


@property (nonatomic ,copy) void(^ sectionHeaderDetaileButtonClick)();
@property (nonatomic ,copy) void(^ sectionHeaderMoreButtonClick)();


- (void)updateSectionHeaderInfoWith:(SUREModel *)sureModel;

@end
