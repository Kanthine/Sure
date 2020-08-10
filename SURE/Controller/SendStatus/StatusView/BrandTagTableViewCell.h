//
//  BrandTagTableViewCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/29.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BrandTagTableViewNormalCellHeight 100
#define BrandTagTableViewSignerCellHeight 40

#define BrandTagNormalCell @"BrandTagNormalCell"
#define BrandTagSignerCell @"BrandTagSignerCell"

#import <UIKit/UIKit.h>

@interface BrandTagTableViewCell : UITableViewCell

// 普通用户 更新订单信息
- (void)updateCellInfoWithProductModel:(OrderProductModel *)product;

//签约用户 更新品牌信息
@property (nonatomic ,strong) UILabel *brandLable;


@end
