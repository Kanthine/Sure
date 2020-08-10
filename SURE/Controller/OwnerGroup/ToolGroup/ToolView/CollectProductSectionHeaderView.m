//
//  CollectProductSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CollectProductSectionHeaderView.h"

#import <Masonry.h>

@implementation CollectProductSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:self.timeLable];
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
        
        
        
//        UIView *topGrayView = UIView.new;
//        topGrayView.backgroundColor = GrayColor;
//        [self.contentView addSubview:topGrayView];
//        [topGrayView mas_makeConstraints:^(MASConstraintMaker *make)
//         {
//             make.right.mas_equalTo(@0);
//             make.left.mas_equalTo(@0);
//             make.top.mas_equalTo(@0);
//             make.height.mas_equalTo(@0.5);
//         }];
        
        
        UIView *grayView = UIView.new;
        grayView.backgroundColor = GrayColor;
        [self.contentView addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@0.5);
         }];
    }
    
    return self;
}

- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = TextColorBlack;
        _timeLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLable;
}

@end
