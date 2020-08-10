//
//  SalesTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SalesTableSectionHeaderView.h"

@implementation SalesTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.text = @"订单编号：";
        CGSize textSize = [lable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size;
        lable.frame = CGRectMake(10, 0, textSize.width, 40);
        [self.contentView addSubview:lable];
        
        self.orderNumberLable.frame = CGRectMake(10 + textSize.width, 0, 150,  40);
        [self.contentView addSubview:self.orderNumberLable];
        
        self.orderTimeLable.frame = CGRectMake(ScreenWidth - 160, 0, 150,  40);
        [self.contentView addSubview:self.orderTimeLable];
    }
    
    
    return self;
}

- (UILabel *)orderNumberLable
{
    if (_orderNumberLable == nil)
    {
        _orderNumberLable = [[UILabel alloc]init];
        _orderNumberLable.backgroundColor = [UIColor clearColor];
        _orderNumberLable.font = [UIFont systemFontOfSize:14];
        _orderNumberLable.textAlignment = NSTextAlignmentLeft;
        _orderNumberLable.textColor = TextColorBlack;
    }
    
    return _orderNumberLable;
}

- (UILabel *)orderTimeLable
{
    if (_orderTimeLable == nil)
    {
        _orderTimeLable = [[UILabel alloc]init];
        _orderTimeLable.backgroundColor = [UIColor clearColor];
        _orderTimeLable.font = [UIFont systemFontOfSize:14];
        _orderTimeLable.textAlignment = NSTextAlignmentRight;
        _orderTimeLable.textColor = TextColor149;
    }
    
    return _orderTimeLable;
}


@end
