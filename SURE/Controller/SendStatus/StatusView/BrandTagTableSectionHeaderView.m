//
//  BrandTagTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BrandTagTableSectionHeaderView.h"
#import <Masonry.h>

@interface BrandTagTableSectionHeaderView()

// 普通用户
@property (nonatomic ,strong) UILabel *headerTitleLable;
@property (nonatomic ,strong) UIImageView *headerImageView;

@end


@implementation BrandTagTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        if ([reuseIdentifier isEqualToString:BrandTagTableSectionNormalHeaderView])
        {
            [self setTableSectionNormalHeaderView];
        }
        else if ([reuseIdentifier isEqualToString:BrandTagTableSectionsignedHeaderView])
        {
            [self setTableSectionsignedHeaderView];
        }

    }
    
    return self;
}

- (void)setTableSectionNormalHeaderView
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.headerTitleLable];
    
    __weak __typeof(self)weakSelf = self;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(weakSelf);
         make.left.mas_equalTo(@10);
         make.width.mas_equalTo(@20);
         make.height.mas_equalTo(@20);
     }];
    [self.headerTitleLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(weakSelf);
         make.height.mas_equalTo(@20);
         make.left.equalTo(weakSelf.headerImageView.mas_right).with.offset(5);
         make.right.mas_equalTo(@0);
     }];
    
    UIView *bottomLineView =  UIView.new;
    bottomLineView.backgroundColor = GrayLineColor;
    [self.contentView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(@0);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.height.mas_equalTo(@1);
     }];
}

- (void)setTableSectionsignedHeaderView
{
    self.contentView.backgroundColor = RGBA(196, 196, 193, .7f);
    
    [self.contentView addSubview:self.brandKindLable];
    
    __weak __typeof(self)weakSelf = self;
    [self.brandKindLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.equalTo(weakSelf);
         make.left.mas_equalTo(@10);
     }];

}

- (UILabel *)brandKindLable
{
    if (_brandKindLable == nil)
    {
        _brandKindLable = [[UILabel alloc]init];
        _brandKindLable.backgroundColor = [UIColor clearColor];
        _brandKindLable.font = [UIFont systemFontOfSize:14];
        _brandKindLable.textColor = TextColorBlack;
        _brandKindLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _brandKindLable;
}


- (UILabel *)headerTitleLable
{
    if (_headerTitleLable == nil)
    {
        _headerTitleLable = [[UILabel alloc]init];
        _headerTitleLable.font = [UIFont systemFontOfSize:14];
        _headerTitleLable.textColor = TextColorBlack;
        _headerTitleLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _headerTitleLable;
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil)
    {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerImageView;
}


- (void)updateHeaderInfoWithProductModel:(OrderModel *)orderModel
{
    self.headerTitleLable.text= orderModel.brandNameString;
    NSString *logo = [NSString stringWithFormat:@"%@/%@",ImageUrl,orderModel.brandLogo];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}

@end
