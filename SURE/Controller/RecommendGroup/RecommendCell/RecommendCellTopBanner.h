//
//  RecommendCellTopBanner.h
//  SURE
//
//  Created by 王玉龙 on 17/1/18.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define RecommendTopBanaerViewHeight (200 / 375.0 * ScreenWidth)



#import <UIKit/UIKit.h>


@interface RecommendCellTopBanner : UITableViewCell

- (void)reloadTopBannerViewWithArray:(NSMutableArray *)listArray;

@end
