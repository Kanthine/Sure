//
//  RecommendCellOne.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define HeaderHeight (ScreenWidth * 9.0 / 16.0)

#define CellSpace 10.0f
#define Collection_Cell_Weight  (ScreenWidth - CellSpace * 3 )/ 3.0
#define Collection_Cell_Height  (Collection_Cell_Weight * 29.0 / 22.0 + 55)
#define RecommendCellOneHeight  (HeaderHeight + Collection_Cell_Height + 20.0)
#define RecommendCellOneCategory @"新人特惠"


#import <UIKit/UIKit.h>

@interface RecommendCellOne : UITableViewCell

@property (nonatomic ,weak) UIViewController *currentViewControler;

- (void)updateRecommendCellOneWithDict:(NSDictionary *)dict;


@end

// 新人特惠类别
