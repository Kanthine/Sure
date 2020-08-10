//
//  BrandTagTableSectionHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define BrandTagTableSectionNormalHeaderView @"BrandTagTableSectionNormalHeaderView"
#define BrandTagTableSectionsignedHeaderView @"BrandTagTableSectionsignedHeaderView"




#import <UIKit/UIKit.h>

@interface BrandTagTableSectionHeaderView : UITableViewHeaderFooterView

//普通用户 更新信息
- (void)updateHeaderInfoWithProductModel:(OrderModel *)orderModel;

//签约用户 品牌分类
@property (nonatomic ,strong) UILabel *brandKindLable;

@end
