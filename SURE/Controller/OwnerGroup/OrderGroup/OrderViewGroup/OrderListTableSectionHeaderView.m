//
//  OrderListTableSectionHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OrderListTableSectionHeaderView.h"
#import <Masonry.h>

@interface OrderListTableSectionHeaderView()

@property (nonatomic ,strong) UIImageView *rightImageView;

@end

@implementation OrderListTableSectionHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.brandLogoImageView];
        [self.contentView addSubview:self.brandNameLable];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.orderStateLable];
        
        __weak __typeof__(self) weakSelf = self;
        [self.brandLogoImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.mas_equalTo(@10);
             make.width.mas_equalTo(@20);
             make.height.mas_equalTo(@20);
        }];
        
        [self.brandNameLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.brandLogoImageView.mas_right).with.offset(5);
            make.height.mas_equalTo(@20);
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.equalTo(weakSelf.brandNameLable.mas_right).with.offset(5);
             make.width.mas_equalTo(@6);
             make.height.mas_equalTo(@10);
         }];
        
        [self.orderStateLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@20);
         }];
    }
    
    return self;
}

- (UIImageView *)brandLogoImageView
{
    if (_brandLogoImageView == nil)
    {
        _brandLogoImageView = [[UIImageView alloc]init];
    }
    
    return _brandLogoImageView;
}

- (UILabel *)brandNameLable
{
    if (_brandNameLable == nil)
    {
        _brandNameLable = [[UILabel alloc]init];
        _brandNameLable.textAlignment = NSTextAlignmentLeft;
        _brandNameLable.font = [UIFont systemFontOfSize:14];
        _brandNameLable.textColor = TextColorBlack;
    }
    
    return _brandNameLable;
}

- (UIImageView *)rightImageView
{
    if (_rightImageView == nil)
    {
        _rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
    }
    
    return _rightImageView;
}

- (UILabel *)orderStateLable
{
    if (_orderStateLable == nil)
    {
        _orderStateLable = [[UILabel alloc]init];
        _orderStateLable.textAlignment = NSTextAlignmentRight;
        _orderStateLable.font = [UIFont systemFontOfSize:14];
        _orderStateLable.textColor = TextColorPurple;
    }
    
    return _orderStateLable;
}


- (void)updateHeaderInfoWithProductModel:(OrderModel *)orderModel
{
    self.brandNameLable.text= orderModel.orderSn;
    self.orderStateLable.text = [self getOrderStatus:orderModel.allStatus];
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",ImageUrl,orderModel.brandLogo];
    NSLog(@"orderModel.brandLogo ======= %@",urlString);

    [self.brandLogoImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}


- (NSString *)getOrderStatus:(NSString *)allStatus
{
    NSString *orderStatus = nil;
    if ([allStatus isEqualToString:@"WAIT_PAY"])
    {
        orderStatus = @"待付款";
    }
    else if ([allStatus isEqualToString:@"WAIT_SHIP"])
    {
        orderStatus = @"待发货";
    }
    else if ([allStatus isEqualToString:@"WAIT_GET"])
    {
        orderStatus = @"待收货";
    }
    else if ([allStatus isEqualToString:@"WAIT_SURE"])
    {
        orderStatus = @"待SURE";
    }
    else
    {
        orderStatus = @"其他";
    }
    

    
    return orderStatus;
}

@end
