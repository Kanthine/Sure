//
//  OrderListCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define OrderListCellHeight 100

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

- (void)updateCellInfoWithProductModel:(OrderProductModel *)product;

@end
