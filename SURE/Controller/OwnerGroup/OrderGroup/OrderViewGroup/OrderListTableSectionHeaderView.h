//
//  OrderListTableSectionHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define OrderListHeaderViewHeight 40.0

#import <UIKit/UIKit.h>

@interface OrderListTableSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong) UIImageView *brandLogoImageView;
@property (nonatomic ,strong) UILabel *brandNameLable;
@property (nonatomic ,strong) UILabel *orderStateLable;

- (void)updateHeaderInfoWithProductModel:(OrderModel *)orderModel;


@end
