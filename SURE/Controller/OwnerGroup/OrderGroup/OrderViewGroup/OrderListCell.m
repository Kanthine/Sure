//
//  OrderListCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OrderListCell.h"

@interface OrderListCell()


@property (nonatomic ,strong) UIImageView *productLogoImageView;
@property (nonatomic ,strong) UILabel *nameLable;
@property (nonatomic ,strong) UILabel *attributeLable;
@property (nonatomic ,strong) UILabel *oldPriceLable;
@property (nonatomic ,strong) UILabel *lineLable;
@property (nonatomic ,strong) UILabel *cutPriceLable;
@property (nonatomic ,strong) UILabel *countLable;

@end

@implementation OrderListCell

- (void)dealloc
{
    [_nameLable removeObserver:self forKeyPath:@"text"];
    _nameLable = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _productLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, OrderListCellHeight - 20, OrderListCellHeight - 20)];
        [self addSubview:_productLogoImageView];
        
        _cutPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 10, 70, 20)];
        _cutPriceLable.numberOfLines = 1;
        _cutPriceLable.textAlignment = NSTextAlignmentRight;
        _cutPriceLable.font = [UIFont systemFontOfSize:14];
        _cutPriceLable.textColor = TextColorBlack;
        [self addSubview:_cutPriceLable];
        
        
        _oldPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 40, 70, CGRectGetHeight(_cutPriceLable.frame))];
        _oldPriceLable.numberOfLines = 1;
        _oldPriceLable.textAlignment = NSTextAlignmentRight;
        _oldPriceLable.font = [UIFont systemFontOfSize:14];
        _oldPriceLable.textColor = TextColor149;
        [self addSubview:_oldPriceLable];
        
        _lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_cutPriceLable.frame) / 2.0, 70, 1)];
        _lineLable.backgroundColor = GrayColor;
        [_oldPriceLable addSubview:_lineLable];
        
        
        _countLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 60 , 70, 50, CGRectGetHeight(_cutPriceLable.frame))];
        _countLable.numberOfLines = 1;
        _countLable.textAlignment = NSTextAlignmentRight;
        _countLable.font = [UIFont systemFontOfSize:14];
        _countLable.textColor = TextColorBlack;
        [self addSubview:_countLable];
        
        
        
        _nameLable = [[UILabel alloc]initWithFrame:CGRectMake(OrderListCellHeight, 10, ScreenWidth - OrderListCellHeight - 80 - 10, 20)];
        _nameLable.numberOfLines = 2;
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = TextColorBlack;
        [self addSubview:_nameLable];
        [_nameLable addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew |
         NSKeyValueObservingOptionOld context:NULL];
        
        
        _attributeLable = [[UILabel alloc]initWithFrame:CGRectMake(OrderListCellHeight, _nameLable.frame.origin.y + CGRectGetHeight(_nameLable.frame) + 10, CGRectGetWidth(_nameLable.frame), 20)];
        _attributeLable.numberOfLines = 1;
        _attributeLable.textAlignment = NSTextAlignmentLeft;
        _attributeLable.font = [UIFont systemFontOfSize:14];
        _attributeLable.textColor = TextColor149;
        [self addSubview:_attributeLable];
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateCellInfoWithProductModel:(OrderProductModel *)product
{
    NSString *goodImage = product.goodsImg;
    goodImage = [NSString stringWithFormat:@"%@/%@",ImageUrl,goodImage];
    [_productLogoImageView sd_setImageWithURL:[NSURL URLWithString:goodImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _nameLable.text = product.goodsName;
    _attributeLable.text = @"颜色尺寸：藏青色/XL";
    _oldPriceLable.text = @"￥509.98";
    _cutPriceLable.text = [NSString stringWithFormat:@"￥ %@",product.goodsPrice];
    _countLable.text = [NSString stringWithFormat:@"x %@",product.goodsNumber];
    
    CGFloat oldPriceWidth = [_oldPriceLable.text boundingRectWithSize:CGSizeMake(70, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _oldPriceLable.font} context:nil].size.width;
    _lineLable.frame = CGRectMake(70 - oldPriceWidth, _lineLable.frame.origin.y, oldPriceWidth, 1);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat nameHeight = [self boundingHeightWithString:_nameLable.text Font:_nameLable.font];
    
    if (nameHeight > 35.5)
    {
        nameHeight = 35.5;
    }
    
    CGRect nameFrame = _nameLable.frame;
    nameFrame.size.height = nameHeight;
    _nameLable.frame = nameFrame;
    
    _attributeLable.frame = CGRectMake(OrderListCellHeight, _nameLable.frame.origin.y + CGRectGetHeight(_nameLable.frame) + 10, CGRectGetWidth(_nameLable.frame), 20);
}

- (CGFloat)boundingHeightWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 90 - OrderListCellHeight , 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect.size.height;
}


@end
