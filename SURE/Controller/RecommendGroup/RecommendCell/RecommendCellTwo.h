//
//  RecommendCellTwo.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//



#define TwoCellSpace 10.0f
#define Collection_TwoCell_Weight  (ScreenWidth - TwoCellSpace * 4 )/ 4.0
#define Collection_TwoCell_Height  Collection_TwoCell_Weight
#define RecommendCellTwoHeight  (Collection_TwoCell_Height + 20.0)
#define RecommendCellTwoCategory @"优选品牌"



#import <UIKit/UIKit.h>

@interface RecommendCellTwo : UITableViewCell

@property (nonatomic ,weak) UIViewController *currentViewControler;

- (void)updateRecommendCellTwoWithDict:(NSDictionary *)dict;

@end


// 优选品牌类型
