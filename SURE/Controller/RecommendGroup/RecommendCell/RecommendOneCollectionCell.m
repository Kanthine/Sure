//
//  RecommendOneCollectionCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "RecommendOneCollectionCell.h"


@interface RecommendOneCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *commodityNameLable;
@property (weak, nonatomic) IBOutlet UILabel *commodityNewPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *commodityOldPriceLable;



@end


@implementation RecommendOneCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithData:(NSDictionary *)dict
{
    NSString *image = dict[@"goods_thumb"];
    image = [NSString stringWithFormat:@"%@/%@",ImageUrl,image];
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    self.commodityNameLable.text = dict[@"goods_name"];
    
    
    NSString *shopPrice = dict[@"shop_price"];
    NSString *marketPrice = dict[@"market_price"];
    marketPrice =[NSString stringWithFormat:@"￥%@",marketPrice];
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:marketPrice];
    [attriStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, marketPrice.length)];

    
    self.commodityNewPriceLable.text = [NSString stringWithFormat:@"￥%@",shopPrice];
    self.commodityOldPriceLable.attributedText = attriStr;

    
}

@end
