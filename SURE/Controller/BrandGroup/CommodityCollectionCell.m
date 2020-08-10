//
//  CommodityCollectionCell.m
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CommodityCollectionCell.h"

@implementation CommodityCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];    
    
    self.layer.cornerRadius = 1;
    self.clipsToBounds = YES;
    self.layer.borderWidth = .5f;
    self.layer.borderColor = GrayColor.CGColor;

}

- (void)updateCommodityInfo:(ProductModel *)model
{
    self.productNameLable.text = model.productNameStr;
    self.productPriceLable.text = [NSString stringWithFormat:@"￥%@",model.productPriceStr] ;
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_thumbString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

@end
