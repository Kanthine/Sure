//
//  ApplyRefundCommodityTableCell.m
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ApplyRefundCommodityTableCell.h"

#import <Masonry.h>

@implementation ApplyRefundCommodityTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.nameLable];
        
        
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@10);
             make.width.mas_equalTo(@40);
             make.height.mas_equalTo(@40);
         }];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.equalTo(_logoImageView.mas_right).with.offset(10);
             make.right.mas_equalTo(@-10);
         }];

    }
    
    return self;
}


- (UIImageView *)logoImageView
{
    if (_logoImageView == nil)
    {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
    }
    
    return _logoImageView;
}

- (UILabel *)nameLable
{
    if (_nameLable == nil)
    {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = TextColorBlack;
        _nameLable.numberOfLines = 3;
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _nameLable;
}


@end
