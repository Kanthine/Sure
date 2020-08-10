//
//  RecommendCellSix.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define RecommendCellSexHeight  ((ScreenWidth - 3) / 4.0 * 2 + 2)
#define RecommendCellSixCategory @"热门品牌"


#import <UIKit/UIKit.h>

@interface RecommendCellSix : UITableViewCell


@property (nonatomic ,weak) UIViewController *currentViewControler;

- (void)updateRecommendCellSixWithDict:(NSDictionary *)dict;



@end


// 热门品牌类别
