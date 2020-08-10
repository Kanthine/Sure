//
//  MySureHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "MySureHeaderView.h"

#import <Masonry.h>

@interface MySureHeaderView()

@property (nonatomic ,strong) UIImageView *nameSignImageView;

@end

@implementation MySureHeaderView

- (instancetype)initWithFrame:(CGRect)frame IsMy:(BOOL)isMy
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.nameSignImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"namesign"]];
        _nameSignImageView.frame = CGRectMake(10, 90, 0, 0);
        _nameSignImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_nameSignImageView];
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLable];
        [self addSubview:self.signNameLable];
        [self addSubview:self.countView];

        __weak __typeof__(self) weakSelf = self;

        [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@10);
             make.height.mas_equalTo(@80);
             make.width.mas_equalTo(@80);
         }];
        self.headerImageView.layer.cornerRadius = 40;
        
//        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make)
//         {
//             make.top.equalTo(weakSelf.headerImageView.mas_bottom).width.offset(10);
//             make.left.mas_equalTo(@10);
//             make.height.mas_equalTo(@20);
//         }];
//        [nameSignImageView mas_makeConstraints:^(MASConstraintMaker *make)
//         {
//             make.centerY.equalTo(weakSelf.nameLable);
//             make.left.equalTo(weakSelf.nameLable.mas_right).width.offset(10);
//             make.height.mas_equalTo(@15);
//             make.width.mas_equalTo(@15);
//         }];
        
        
//        [self.signNameLable mas_makeConstraints:^(MASConstraintMaker *make)
//         {
//             make.top.equalTo(weakSelf.nameLable.mas_bottom).width.offset(5);
//             make.left.mas_equalTo(@10);
//             make.right.mas_equalTo(@10);
//         }];
        
        
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@40);
             make.width.mas_equalTo(@180);
         }];
        
        
        if (isMy == NO)
        {
            [self addSubview:self.optionButton];
//            [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
//             {
//                 make.top.equalTo(weakSelf.countView.mas_bottom).width.offset(10);
//                 make.right.mas_equalTo(@-50);
//                 make.height.mas_equalTo(@40);
//                 make.width.mas_equalTo(@180);
//             }];
        }
        
        
        
        UIView *bottomLineView = UIView.new;
        bottomLineView.backgroundColor = GrayLineColor;
        [self addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
             make.bottom.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil)
    {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.clipsToBounds = YES;
    }
    
    return _headerImageView;
}

- (UILabel *)nameLable
{
    if (_nameLable == nil)
    {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = [UIColor blackColor];
        _nameLable.font = [UIFont systemFontOfSize:16];
    }
    
    return _nameLable;
}

- (UILabel *)signNameLable
{
    if (_signNameLable == nil)
    {
        _signNameLable = [[UILabel alloc]init];
        _signNameLable.textColor = TextColorBlack;
        _signNameLable.font = [UIFont systemFontOfSize:15];
        _signNameLable.numberOfLines = 0;
    }
    return _signNameLable;
}

- (MySureHeaderCountView *)countView
{
    if (_countView == nil)
    {
        _countView = [[MySureHeaderCountView alloc]init];
    }
    return _countView;
}

- (UIButton *)optionButton
{
    if (_optionButton == nil)
    {
        _optionButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 190, 60, 180, 40)];
        _optionButton.clipsToBounds = YES;
        
        _optionButton.layer.cornerRadius = 3;
        
        _optionButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_optionButton setTitle:@"关注" forState:UIControlStateNormal];
        [_optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_optionButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_optionButton setTitleColor:RGBA(141, 31, 203, 1) forState:UIControlStateSelected];
        _optionButton.backgroundColor = RGBA(141, 31, 203, 1);

        
        _optionButton.layer.borderColor = RGBA(141, 31, 203, 1).CGColor;
        _optionButton.layer.borderWidth = 1.5;
    }
    
    return _optionButton;
}

- (CGFloat )updateUIGetHeight
{
    CGFloat width = [self.nameLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _nameLable.font} context:nil].size.width;
    self.nameLable.frame = CGRectMake(10, 100, width + 5, 17);
    
    self.nameSignImageView.frame = CGRectMake(10 + width + 10, 101, 15, 15);
    
    CGFloat height = [self.signNameLable.text boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.signNameLable.font} context:nil].size.height;
    
    
    self.signNameLable.frame = CGRectMake(10, 127, ScreenWidth - 20, height);
    
    
    if (self.optionButton.selected)
    {
        _optionButton.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        _optionButton.backgroundColor = RGBA(141, 31, 203, 1);
    }
    
    return 130 + height + 10;
}

@end
