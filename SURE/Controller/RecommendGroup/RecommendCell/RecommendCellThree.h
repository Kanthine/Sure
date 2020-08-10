//
//  RecommendCellThree.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define RecommendCellThreeHeight  (ScreenWidth * 9.0 / 8.0)
#define RecommendCellThreeCategory @"优选单品"

#import <UIKit/UIKit.h>

@interface RecommendCellThree : UITableViewCell

@property (nonatomic ,weak) UIViewController *currentViewControler;


- (void)updateRecommendCellThreeWithDict:(NSDictionary *)dict;


@end

// 优选单品类别
