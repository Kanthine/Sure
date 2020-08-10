//
//  BrandTagTableViewCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/29.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BrandTagTableViewCell.h"

#import <Masonry.h>


@interface BrandTagTableViewCell()

// 普通用户
@property (nonatomic ,strong) UIImageView *productLogoImageView;
@property (nonatomic ,strong) UILabel *nameLable;
@property (nonatomic ,strong) UILabel *attributeLable;
@property (nonatomic ,strong) UILabel *oldPriceLable;
@property (nonatomic ,strong) UILabel *lineLable;
@property (nonatomic ,strong) UILabel *cutPriceLable;
@property (nonatomic ,strong) UILabel *countLable;

@end

@implementation BrandTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
        
        if ([reuseIdentifier isEqualToString:BrandTagNormalCell])
        {
            [self setNoramlCellUI];
        }
        else if ([reuseIdentifier isEqualToString:BrandTagSignerCell])
        {
            [self setSignerCellUI];
        }
        
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
         }];
        
    }
    
    return self;
}

#pragma mark - SignerCellUI

- (void)setSignerCellUI
{
    [self.contentView addSubview:self.brandLable];
    __weak __typeof__(self) weakSelf = self;

    [self.brandLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(weakSelf);
         make.left.mas_equalTo(@10);
     }];
}

- (UILabel *)brandLable
{
    if (_brandLable == nil)
    {
        _brandLable = [[UILabel alloc]init];
        _brandLable.backgroundColor = [UIColor clearColor];
        _brandLable.textColor = TextColorBlack;
        _brandLable.textAlignment = NSTextAlignmentLeft;
        _brandLable.font = [UIFont systemFontOfSize:14];
        
    }
    
    return _brandLable;
}


#pragma mark - NoramlCellUI

- (void)setNoramlCellUI
{
    
    [self.contentView addSubview:self.productLogoImageView];
    
    [self.contentView addSubview:self.cutPriceLable];
    
    [self.contentView addSubview:self.oldPriceLable];
    
    [self.contentView addSubview:self.countLable];
    
    [self.contentView addSubview:self.nameLable];
    
    [self.contentView addSubview:self.attributeLable];
    
    
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.productLogoImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(@10);
        make.left.mas_equalTo(@10);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@80);
    }];
    
    [self.cutPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@10);
         make.right.mas_equalTo(@-10);
     }];

    [self.oldPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(weakSelf.cutPriceLable.mas_bottom).with.offset(5);
         make.right.mas_equalTo(@-10);
     }];
    
    [self.countLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(weakSelf.oldPriceLable.mas_bottom).with.offset(5);
         make.right.mas_equalTo(@-10);
     }];

    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@10);
         make.left.equalTo(weakSelf.productLogoImageView.mas_right).with.offset(5);
//         make.right.equalTo(weakSelf.cutPriceLable.mas_left).with.offset(-5);
         make.right.equalTo(weakSelf.oldPriceLable.mas_left).with.offset(-5);
     }];

    
    [self.attributeLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(weakSelf.nameLable.mas_bottom).with.offset(5);
         make.left.equalTo(weakSelf.productLogoImageView.mas_right).with.offset(5);
         make.right.equalTo(weakSelf.oldPriceLable.mas_left).with.offset(-5);
         make.right.equalTo(weakSelf.countLable.mas_left).with.offset(-5);
//         make.bottom.mas_equalTo(@-10);
     }];

}

- (UIImageView *)productLogoImageView
{
    if (_productLogoImageView == nil)
    {
        _productLogoImageView = [[UIImageView alloc]init];
        _productLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _productLogoImageView;
}

- (UILabel *)cutPriceLable
{
    if (_cutPriceLable == nil)
    {
        _cutPriceLable = [[UILabel alloc]init];
        _cutPriceLable.numberOfLines = 1;
        _cutPriceLable.textAlignment = NSTextAlignmentRight;
        _cutPriceLable.font = [UIFont systemFontOfSize:14];
        _cutPriceLable.textColor = TextColorBlack;
    }
    
    return _cutPriceLable;
}

- (UILabel *)oldPriceLable
{
    if (_oldPriceLable == nil)
    {
        _oldPriceLable = [[UILabel alloc]init];
        _oldPriceLable.numberOfLines = 1;
        _oldPriceLable.textAlignment = NSTextAlignmentRight;
        _oldPriceLable.font = [UIFont systemFontOfSize:14];
        _oldPriceLable.textColor = TextColor149;
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayColor;
        [_oldPriceLable addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(_oldPriceLable);
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.height.mas_equalTo(@1);
        }];

    }
    
    return _oldPriceLable;
}

- (UILabel *)countLable
{
    if (_countLable == nil)
    {
        _countLable = [[UILabel alloc]init];
        _countLable.numberOfLines = 1;
        _countLable.textAlignment = NSTextAlignmentRight;
        _countLable.font = [UIFont systemFontOfSize:14];
        _countLable.textColor = TextColorBlack;
    }
    
    return _countLable;
}

- (UILabel *)nameLable
{
    if (_nameLable == nil)
    {
        _nameLable = [[UILabel alloc]init];
        _nameLable.numberOfLines = 2;
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = TextColorBlack;
    }
    
    return _nameLable;
}

- (UILabel *)attributeLable
{
    if (_attributeLable == nil)
    {
        _attributeLable = [[UILabel alloc]init];
        _attributeLable.numberOfLines = 1;
        _attributeLable.textAlignment = NSTextAlignmentLeft;
        _attributeLable.font = [UIFont systemFontOfSize:14];
        _attributeLable.textColor = TextColor149;
    }
    
    return _attributeLable;
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
}

@end
