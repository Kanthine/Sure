//
//  RecommendTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/13.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "RecommendTableSectionHeaderView.h"

#import <Masonry.h>

@interface RecommendTableSectionHeaderView()

{
    NSDictionary *_infoDict;
}
@property (nonatomic ,strong) UILabel *kindLable;

@property (nonatomic ,strong) UIButton *lookAllButton;

@end

@implementation RecommendTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:self.kindLable];
        [self.kindLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
        
        
        [self.contentView addSubview:self.lookAllButton];
        [self.lookAllButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.width.mas_equalTo(@100);
             make.bottom.mas_equalTo(@0);
             make.top.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UILabel *)kindLable
{
    if (_kindLable == nil)
    {
        _kindLable = [[UILabel alloc]init];
        _kindLable.font = [UIFont systemFontOfSize:16];
        _kindLable.textColor = [UIColor blackColor];
        _kindLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _kindLable;
}

- (UIButton *)lookAllButton
{
    if (_lookAllButton == nil)
    {
        _lookAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_lookAllButton setTitle:@"查看全部" forState:UIControlStateNormal];
        _lookAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_lookAllButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        [_lookAllButton addTarget:self action:@selector(lookAllButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_lookAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_lookAllButton addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_lookAllButton);
             make.width.mas_equalTo(@9);
             make.height.mas_equalTo(@15);
             make.right.mas_equalTo(@-10);
         }];

        
        
    }
    
    return _lookAllButton;
}

- (void)lookAllButtonClick
{
    NSString *cellCategory = _infoDict[@"position_name"];
    
    
    if ([cellCategory containsString:RecommendCellOneCategory])
    {
        //新人特惠
    }
    else if ([cellCategory containsString:RecommendCellTwoCategory])
    {
        //优选品牌
        [self.currentViewControler.navigationController.tabBarController setSelectedIndex:0];
    }
    else if ([cellCategory containsString:RecommendCellThreeCategory])
    {
        //优选单品
    }
    else if ([cellCategory containsString:RecommendCellFourCategory])
    {
        //潮人搭配"
    }
    else if ([cellCategory containsString:RecommendCellFiveCategory])
    {
        //热门品类
        [self.currentViewControler.navigationController.tabBarController setSelectedIndex:3];

    }
    else if ([cellCategory containsString:RecommendCellSixCategory])
    {
        //热门品牌
        [self.currentViewControler.navigationController.tabBarController setSelectedIndex:0];
        
    }
}

- (void)updateRecommendTableSectionHeaderViewWithDict:(NSDictionary *)dict
{
    _infoDict = dict;

    NSString *categoryNameString = dict[@"ad_name"];
    self.kindLable.text = categoryNameString;
}


@end
