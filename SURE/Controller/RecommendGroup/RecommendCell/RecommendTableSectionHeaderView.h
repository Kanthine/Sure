//
//  RecommendTableSectionHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/13.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define RecommendTableSectionHeaderViewHeight 48


#import <UIKit/UIKit.h>


#import "RecommendCellOne.h"
#import "RecommendCellTwo.h"
#import "RecommendCellThree.h"
#import "RecommendCellFour.h"
#import "RecommendCellFive.h"
#import "RecommendCellSix.h"




@interface RecommendTableSectionHeaderView : UITableViewHeaderFooterView


@property (nonatomic ,weak) UIViewController *currentViewControler;

- (void)updateRecommendTableSectionHeaderViewWithDict:(NSDictionary *)dict;





@end
