//
//  TapSupportDetaileCell.m
//  SURE
//
//  Created by 王玉龙 on 16/10/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "TapSupportDetaileCell.h"
#import <Masonry.h>

@implementation TapSupportDetaileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.userHeaderImageView];
        [self.contentView addSubview:self.userNameLable];
        [self.contentView addSubview:self.optionButton];

        __weak __typeof__(self) weakSelf = self;
        [self.userHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(weakSelf);
            make.left.mas_equalTo(@10);
            make.height.mas_equalTo(@25);
            make.width.mas_equalTo(@25);
        }];
        
        
        [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.equalTo(weakSelf.userHeaderImageView.mas_right).with.offset(10);
             make.height.mas_equalTo(@20);
         }];
        
        [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@18);
             make.width.mas_equalTo(@50);
         }];
        
        _userNameLable.text = @"ORIGAL X YOUTH";
        _userHeaderImageView.image = [UIImage imageNamed:@"ownerHeader"];
        
        
        
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

- (UIImageView *)userHeaderImageView
{
    if (_userHeaderImageView == nil)
    {
        _userHeaderImageView = [[UIImageView alloc]init];
        _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
        _userHeaderImageView.layer.cornerRadius = 25 / 2.0;
        _userHeaderImageView.clipsToBounds = YES;
    }
    
    return _userHeaderImageView;
}

- (UILabel *)userNameLable
{
    if (_userNameLable == nil)
    {
        _userNameLable = [[UILabel alloc]init];
        _userNameLable.font = [UIFont fontWithName:FontName size:14];
        _userNameLable.textAlignment = NSTextAlignmentLeft;
        _userNameLable.textColor = [UIColor blackColor];
    }
    
    return _userNameLable;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
