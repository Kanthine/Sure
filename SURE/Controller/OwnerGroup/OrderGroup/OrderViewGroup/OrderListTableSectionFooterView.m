//
//  OrderListTableSectionFooterView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define ButtonWidth 70.0
#define ButtonHeight 26.0

#import "OrderListTableSectionFooterView.h"
#import <Masonry.h>


#import "LookLogisticsVC.h"

#import "PayOrderVC.h"

#import "ChatViewController.h"

@interface OrderListTableSectionFooterView ()

@property (nonatomic ,strong) UIButton *leftButton;
@property (nonatomic ,strong) UIButton *middleButton;
@property (nonatomic ,strong) UIButton *rightButton;

@end

@implementation OrderListTableSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.describeLable];
        
        __weak __typeof__(self) weakSelf = self;
        [self.describeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@20);
         }];
        
        
        UIView *middleLineView = UIView.new;
        middleLineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:middleLineView];
        [middleLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.describeLable.mas_bottom).with.offset(10);
             make.left.mas_equalTo(@20);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
         }];
        

        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.middleButton];
        [self.contentView addSubview:self.rightButton];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLineView.mas_bottom).with.offset(15);
             make.height.mas_equalTo(@(ButtonHeight));
             make.width.mas_equalTo(@(ButtonWidth));
         }];
        [self.middleButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLineView.mas_bottom).with.offset(15);
             make.left.equalTo(weakSelf.leftButton.mas_right).with.offset(10);
             make.height.mas_equalTo(@(ButtonHeight));
             make.width.mas_equalTo(@(ButtonWidth));
         }];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(middleLineView.mas_bottom).with.offset(15);
             make.left.equalTo(weakSelf.middleButton.mas_right).with.offset(10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@(ButtonHeight));
             make.width.mas_equalTo(@(ButtonWidth));
         }];
        
        
        
        UIView *grayAreaView = UIView.new;
        grayAreaView.backgroundColor = RGBA(237, 237, 242, 1);
        [self.contentView addSubview:grayAreaView];
        [grayAreaView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(@100);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@20);
         }];
        
    }
    
    return self;
}

- (UILabel *)describeLable
{
    if (_describeLable == nil)
    {
        _describeLable = [[UILabel alloc]init];
        _describeLable.textAlignment = NSTextAlignmentRight;
        _describeLable.font = [UIFont systemFontOfSize:14];
        _describeLable.textColor = TextColorBlack;
    }
    
    return _describeLable;
}

- (UIButton *)leftButton
{
    if (_leftButton == nil)
    {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftButton.layer.cornerRadius = 5;
        _leftButton.clipsToBounds = YES;
        _leftButton.layer.borderWidth = 1;
    }
    
    return _leftButton;
}

- (UIButton *)middleButton
{
    if (_middleButton == nil)
    {
        _middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _middleButton.layer.cornerRadius = 5;
        _middleButton.clipsToBounds = YES;
        _middleButton.layer.borderWidth = 1;
    }
    
    return _middleButton;
}

- (UIButton *)rightButton
{
    if (_rightButton == nil)
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightButton.layer.cornerRadius = 5;
        _rightButton.clipsToBounds = YES;
        _rightButton.layer.borderWidth = 1;
    }
    
    return _rightButton;
}

- (void)setOrderState:(OrderTpye)orderState
{
    _orderState = orderState;
    
    _leftButton.hidden = YES;
    _middleButton.hidden = YES;
    _rightButton.hidden = YES;
    
    switch (_orderState)
    {
        case OrderTpyeWaitPay:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"付款" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            
            _middleButton.hidden = NO;
            [_middleButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_middleButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _middleButton.layer.borderColor = TextColor149.CGColor;
            [_middleButton addTarget:self action:@selector(cancelOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _leftButton.hidden = NO;
            [_leftButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [_leftButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _leftButton.layer.borderColor = TextColor149.CGColor;
            [_leftButton addTarget:self action:@selector(linkServicerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case OrderTpyeWaitSendGoods:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"提醒发货" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            [_rightButton addTarget:self action:@selector(alertSendGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case OrderTpyeReceiveGoods:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            [_rightButton addTarget:self action:@selector(confirmReceiveGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _middleButton.hidden = NO;
            [_middleButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [_middleButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _middleButton.layer.borderColor = TextColor149.CGColor;
            [_middleButton addTarget:self action:@selector(lookLogisticsButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _leftButton.hidden = NO;
            [_leftButton setTitle:@"延长收货" forState:UIControlStateNormal];
            [_leftButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _leftButton.layer.borderColor = TextColor149.CGColor;
            [_leftButton addTarget:self action:@selector(extendReceiveGoodsButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case OrderTpyeWaitSure:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            [_rightButton addTarget:self action:@selector(deleteOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _middleButton.hidden = NO;
            [_middleButton setTitle:@"评价" forState:UIControlStateNormal];
            [_middleButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _middleButton.layer.borderColor = TextColor149.CGColor;
            [_middleButton addTarget:self action:@selector(evaluateButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
}

- (void)setRefundState:(RefundTpye)refundState
{
    _refundState = refundState;
    
    _leftButton.hidden = YES;
    _middleButton.hidden = YES;
    _rightButton.hidden = YES;
    
    
    switch (_refundState)
    {
        case RefundTpyeHandle:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"查看进度" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            [_rightButton addTarget:self action:@selector(lookRefundProgressButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            _middleButton.hidden = NO;
            [_middleButton setTitle:@"催促退款" forState:UIControlStateNormal];
            [_middleButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            _middleButton.layer.borderColor = TextColor149.CGColor;
            [_middleButton addTarget:self action:@selector(alertRefundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case RefundTpyeFinished:
        {
            _rightButton.hidden = NO;
            [_rightButton setTitle:@"钱款去向" forState:UIControlStateNormal];
            [_rightButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            _rightButton.layer.borderColor = TextColorPurple.CGColor;
            [_rightButton addTarget:self action:@selector(refundMoneyDirectionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Button click



- (void)alertSendGoodsButtonClick
{
    NSLog(@"---------  提醒发货 -------------");
}

- (void)linkServicerButtonClick
{
    NSLog(@"---------  联系客服   -------------");
    //联系客服
    ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
    [self.currentViewController presentViewController:nav animated:YES completion:nil];

}
- (void)cancelOrderButtonClick
{
    NSLog(@"---------  取消订单  -------------");
}

- (void)payButtonClick
{
    NSLog(@"--------- 付款 -------------");
    
    
    NSDictionary *dict = @{@"order_id":self.orderIDStr};
    
    [MBProgressHUD showHUDAddedTo:self.currentViewController.view animated:YES];
    
    [self.currentViewController.httpManager getOrderPayInfoWithParameterDict:dict CompletionBlock:^(NSDictionary *payDict, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.currentViewController.view animated:YES];
        NSString *orderString = payDict[@"result"];
        
        
        NSDictionary *payInfo = @{@"order_string":orderString,@"order_id":self.orderIDStr};
        PayOrderVC *payVC = [[PayOrderVC alloc]initWithPayInfo:payInfo];
        [self.currentViewController.navigationController pushViewController:payVC animated:YES];
        
    }];
    
    
    
    
    
    
    
    
}

- (void)extendReceiveGoodsButtonClick
{
    NSLog(@"---------  延长收货  -------------");
}

- (void)lookLogisticsButtonClick
{
    LookLogisticsVC *refundVC = [[LookLogisticsVC alloc]init];
    refundVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewController.navigationController pushViewController:refundVC animated:YES];
    
    NSLog(@"---------  查看物流  -------------");
}

- (void)confirmReceiveGoodsButtonClick
{
    NSLog(@"---------  确认收货  -------------");
}

- (void)deleteOrderButtonClick
{
    NSLog(@"---------  删除订单  -------------");
}


- (void)evaluateButtonClick
{
    NSLog(@"---------  评价  -------------");
}

- (void)refundMoneyDirectionButtonClick
{
    NSLog(@"---------  钱款去向  -------------");
}

- (void)alertRefundButtonClick
{
    NSLog(@"---------  催促退款  -------------");
}

- (void)lookRefundProgressButtonClick
{
    NSLog(@"---------  查看退款进度  -------------");
}
@end
