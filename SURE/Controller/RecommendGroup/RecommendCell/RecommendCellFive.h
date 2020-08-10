//
//  RecommendCellFive.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define RecommendCellFiveHeight  (((ScreenWidth - 3.0)/ 4.0 + 20) * 3.0 + 3.0 * 1)
#define RecommendCellFiveCategory @"热门品类"


#import <UIKit/UIKit.h>

@interface RecommendCellFive : UITableViewCell

@property (nonatomic ,weak) UIViewController *currentViewControler;


- (void)updateRecommendCellFiveWithDict:(NSDictionary *)dict;


@end


// 热门品类类别
