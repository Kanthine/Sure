//
//  CouponCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellHeight ((ScreenWidth - 20 ) / 7.0 * 2.0 + 10)

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *privilegeLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIImageView *stateIconImageView;


- (void)updateCellInfoWithCouponModel:(CouponModel *)coupon;

@end
