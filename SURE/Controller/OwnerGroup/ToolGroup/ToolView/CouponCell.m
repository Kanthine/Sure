//
//  CouponCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    _nameLable.adjustsFontSizeToFitWidth = YES;
    _timeLable.adjustsFontSizeToFitWidth = YES;
    _stateIconImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateCellInfoWithCouponModel:(CouponModel *)coupon
{
    
    NSString *nameStr = [NSString stringWithFormat:@"%@ 满%d减%d",coupon.nameString,[coupon.maxMoneyString intValue],[coupon.cutMoneyString intValue]];
    NSString *timeStr = [NSString stringWithFormat:@"有效期：%@ - %@",coupon.startTimeString,coupon.endTimeString];
    
    self.nameLable.text = nameStr;
    self.timeLable.text = timeStr;
    self.privilegeLable.text = [NSString stringWithFormat:@"%d",[coupon.cutMoneyString intValue]];
    
    if (coupon.couponType == CouponStateNormal)
    {
        self.backImageView.image = [UIImage imageNamed:@"couponBack"];
        self.stateIconImageView.hidden = YES;
    }
    else if (coupon.couponType == CouponStateUsed)
    {
        self.backImageView.image = [UIImage imageNamed:@"couponBackGray"];
        self.stateIconImageView.image = [UIImage imageNamed:@"coupon_Used"];
        self.stateIconImageView.hidden = NO;
    }
    else if (coupon.couponType == CouponStateOutTime)
    {
        self.backImageView.image = [UIImage imageNamed:@"couponBackGray"];
        self.stateIconImageView.image = [UIImage imageNamed:@"coupon_Disabled"];
        self.stateIconImageView.hidden = NO;
    }
}


@end
