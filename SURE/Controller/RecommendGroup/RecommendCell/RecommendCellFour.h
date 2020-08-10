//
//  RecommendCellFour.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define RecommendCellFourHeight  ((ScreenWidth - 3 * 10.0) / 2.0 + 2 * 10.0)
#define RecommendCellFourCategory @"潮人搭配"




#import <UIKit/UIKit.h>

@interface RecommendCellFour : UITableViewCell

- (void)updateRecommendCellFourWithDict:(NSDictionary *)dict;

@end


// 超人搭配类别
