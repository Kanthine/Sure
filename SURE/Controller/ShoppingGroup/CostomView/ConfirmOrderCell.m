//
//  ConfirmOrderCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ConfirmOrderCell.h"



@implementation ConfirmOrderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConfirmOrderWithProduct:(CommodityInfoModel *)product
{
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:product.imageString]];
    self.nameLable.text = product.nameString;
    self.kindLable.text = product.attributeStrig;
    self.priceLable.text = [NSString stringWithFormat:@"￥%@",product.oldPriceString];
    self.countLable.text = [NSString stringWithFormat:@"x %ld",product.count];
    
}

@end
