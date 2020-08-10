//
//  ShopCarTableViewCell.m
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShopCarTableViewCell.h"

@implementation ShopCarTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.commodityImageButton.layer.cornerRadius = 5.0f;
    self.commodityImageButton.layer.masksToBounds = YES;
    self.commodityImageButton.clipsToBounds = YES;
}

- (IBAction)commoditySelectedStatusButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commoditySelectedStatusClick:isSelected:)])
    {
        [self.delegate commoditySelectedStatusClick:self isSelected:!sender.selected];
    }
}

- (IBAction)plusOrMinusCommodityNumberButtonClick:(UIButton *)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(plusOrMinusCommodityNumberClick:tag:)])
    {
        [self.delegate plusOrMinusCommodityNumberClick:self tag:sender.tag];
    }
}


// 点击单个cell里面的垃圾桶回调
- (IBAction)deleteProductButtonClick:(id)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteProductClick:)])
    {
        [self.delegate deleteProductClick:self];
    }
}

- (IBAction)editingProductAttributeInfoButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editingProductAttributeInfoClick:)])
    {
        [self.delegate editingProductAttributeInfoClick:self];
    }
}







- (IBAction)commodityImageButtonIMGButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickProductIMG:)])
    {
        [self.delegate clickProductIMG:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
