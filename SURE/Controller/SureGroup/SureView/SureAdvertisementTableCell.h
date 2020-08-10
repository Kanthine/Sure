//
//  SureAdvertisementTableCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/23.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

@interface SureAdvertisementTableCell : UITableViewCell

@property (nonatomic ,strong) BaseViewController *currentViewController;

- (void)refreshBrandListScrollViewWithBrandArray:(NSMutableArray<BrandDetaileModel *>  *)brandArray;

@end
