//
//  CollectBrandTableCell.m
//  SURE
//
//  Created by 王玉龙 on 17/1/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "CollectBrandTableCell.h"

#import <Masonry.h>

@interface CollectBrandTableCell ()


@end

@implementation CollectBrandTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.brandLogoImageView];
        [self.contentView addSubview:self.brandNameLable];
        [self.contentView addSubview:self.optionButton];
        
        __weak __typeof__(self) weakSelf = self;
        [self.brandLogoImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.mas_equalTo(@10);
             make.height.mas_equalTo(@25);
             make.width.mas_equalTo(@25);
         }];
        
        
        [self.brandNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.equalTo(weakSelf.brandLogoImageView.mas_right).with.offset(10);
             make.height.mas_equalTo(@20);
         }];
        
        [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@18);
             make.width.mas_equalTo(@50);
         }];
        
        _brandNameLable.text = @"ORIGAL X YOUTH";
        _brandLogoImageView.image = [UIImage imageNamed:@"ownerHeader"];
        
        
        
        UIView *bottomLineView = UIView.new;
        bottomLineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.height.mas_equalTo(@1);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];

    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView *)brandLogoImageView
{
    if (_brandLogoImageView == nil)
    {
        _brandLogoImageView = [[UIImageView alloc]init];
        _brandLogoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _brandLogoImageView.layer.cornerRadius = 25 / 2.0;
        _brandLogoImageView.clipsToBounds = YES;
    }
    
    return _brandLogoImageView;
}

- (UILabel *)brandNameLable
{
    if (_brandNameLable == nil)
    {
        _brandNameLable = [[UILabel alloc]init];
        _brandNameLable.font = [UIFont fontWithName:FontName size:14];
        _brandNameLable.textAlignment = NSTextAlignmentLeft;
        _brandNameLable.textColor = [UIColor blackColor];
    }
    
    return _brandNameLable;
}

- (UIButton *)optionButton
{
    if (_optionButton == nil)
    {
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionButton setImage:[UIImage imageNamed:@"tapSupport_FocusNo"] forState:UIControlStateNormal];
        [_optionButton setImage:[UIImage imageNamed:@"tapSupport_Focused"] forState:UIControlStateSelected];
    }
    
    return _optionButton;
}


@end
