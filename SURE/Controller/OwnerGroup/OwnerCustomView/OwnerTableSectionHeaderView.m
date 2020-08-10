//
//  OwnerTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerTableSectionHeaderView.h"
#import <Masonry.h>

@implementation OwnerTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];


        
        [self.contentView addSubview:self.headerTitleLable];
        [self.contentView addSubview:self.lookAllButton];
    }
    
    
    return self;
}

- (UILabel *)headerTitleLable
{
    if (_headerTitleLable == nil)
    {
        _headerTitleLable = [[UILabel alloc]init];
        _headerTitleLable.backgroundColor = [UIColor clearColor];
        _headerTitleLable.font = [UIFont systemFontOfSize:14];
        _headerTitleLable.textAlignment = NSTextAlignmentLeft;
        _headerTitleLable.textColor = TextColorBlack;
    }
    
    return _headerTitleLable;
}

- (UIButton *)lookAllButton
{
    if (_lookAllButton == nil)
    {
        _lookAllButton = [[UIButton alloc]init];
        [_lookAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 28)];
        [_lookAllButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_lookAllButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_lookAllButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        _lookAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        
        [_lookAllButton addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(_lookAllButton);
            make.right.mas_equalTo(@-15);
            make.width.mas_equalTo(@7);
            make.height.mas_equalTo(@12);
        }];
        
    }
    
    return _lookAllButton;
}



@end
