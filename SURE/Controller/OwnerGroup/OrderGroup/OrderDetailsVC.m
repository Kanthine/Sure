//
//  OrderDetailsVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define RowInterval 8.0


#import "OrderDetailsVC.h"

#import "CountdownTimeLable.h"

#import "TimeStamp.h"
#import "OrderDetaileProductView.h"
#import "UIImage+Extend.h"
#import "ChatViewController.h"
#import "MessageCenterVC.h"
#import "LookLogisticsVC.h"

#import "ApplyRefundVC.h"
@interface OrderDetailsVC ()

{
    UIButton *_messageBarButton;
}

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *addressView;
@property (nonatomic ,strong) UIView *orderNumberView;
@property (nonatomic ,strong) UIView *commodityView;
@property (nonatomic ,strong) UIView *freeView;
@property (nonatomic ,strong) UIView *linkView;
@property (nonatomic ,strong) UIView *bottomView;

@end

@implementation OrderDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customNavBar];
    
    [self.view addSubview:self.scrollView];
    
    [_scrollView addSubview:self.addressView];
    [_scrollView addSubview:self.orderNumberView];
    [_scrollView addSubview:self.commodityView];
    [_scrollView addSubview:self.freeView];
    [_scrollView addSubview:self.linkView];
    _scrollView.contentSize = CGSizeMake(ScreenWidth, _linkView.frame.origin.y + CGRectGetHeight(_linkView.frame));
    
    [self.view addSubview:self.bottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"订单详情";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _messageBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
    [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];
    [_messageBarButton addTarget:self action:@selector(navBar_MessageButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_messageBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navBar_MessageButtonEditClick:(UIButton *)button
{
    MessageCenterVC *messageVC = [[MessageCenterVC alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)addressView
{
    if (_addressView == nil)
    {
        _addressView = [[UIView alloc]init];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"orderDetaile_Adress"];
        [_addressView addSubview:imageView];
        
        
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 200, 20)];
        nameLable.textColor = TextColor149;
        nameLable.font = [UIFont systemFontOfSize:LableFountSize];
        nameLable.text = _orderModel.buyer;
        nameLable.textAlignment = NSTextAlignmentLeft;
        CGFloat nameHeight = [nameLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :nameLable.font} context:nil].size.height;

        [_addressView addSubview:nameLable];
        
        UILabel *phoneLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 110, 10, 100, 20)];
        phoneLable.text = _orderModel.mobile;
        phoneLable.font = [UIFont systemFontOfSize:LableFountSize];
        phoneLable.textAlignment = NSTextAlignmentRight;
        phoneLable.textColor = TextColor149;
        [_addressView addSubview:phoneLable];

        UILabel *addressLable = [[UILabel alloc]init];
        addressLable.text = [NSString stringWithFormat:@"收货地址:%@ %@ %@ %@",_orderModel.provinceName ,_orderModel.cityName ,_orderModel.districtName ,_orderModel.address];
        addressLable.font = [UIFont systemFontOfSize:LableFountSize];
        addressLable.textColor = TextColor149;
        addressLable.textAlignment = NSTextAlignmentLeft;
        CGFloat textHeight = [addressLable.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(addressLable.frame) , 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : addressLable.font} context:nil].size.height;
        addressLable.frame = CGRectMake(40, 10 + nameHeight + RowInterval, ScreenWidth - 50, textHeight);
        [_addressView addSubview:addressLable];
        
        
        UILabel *grayLable = [[UILabel alloc]init];
        grayLable.backgroundColor = GrayColor;
        [_addressView addSubview:grayLable];
        
        
        
        
        _addressView.frame = CGRectMake(0, 0, ScreenWidth, addressLable.frame.origin.y + CGRectGetHeight(addressLable.frame) + 10);
        
        imageView.center = CGPointMake(imageView.center.x, _addressView.center.y);
        grayLable.frame = CGRectMake(0, CGRectGetHeight(_addressView.frame) - 1, ScreenWidth, 1);
    }
    
    return _addressView;
}

- (UIView *)orderNumberView
{
    if (_orderNumberView == nil)
    {
        
        _orderNumberView = [[UIView alloc]init];

        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"orderDetaile_Number"];
        [_orderNumberView addSubview:imageView];
        
        
        CGFloat textHeight = [@"文字" boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:LableFountSize]} context:nil].size.height;

        
        UILabel *orderSnLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, ScreenWidth - 50, textHeight)];
        orderSnLable.text = [NSString stringWithFormat:@"订单编号:%@",_orderModel.orderSn];
        orderSnLable.font = [UIFont systemFontOfSize:LableFountSize];
        orderSnLable.textColor = TextColor149;
        orderSnLable.textAlignment = NSTextAlignmentLeft;
        [_orderNumberView addSubview:orderSnLable];
        
        
        UILabel *orderStatusLable = [[UILabel alloc]initWithFrame:CGRectMake(40, orderSnLable.frame.origin.y + textHeight + RowInterval, ScreenWidth - 50, textHeight)];
        orderStatusLable.text = [NSString stringWithFormat:@"订单状态:%@",_orderModel.orderStatus];
        orderStatusLable.font = [UIFont systemFontOfSize:LableFountSize];
        orderStatusLable.textColor = TextColor149;
        orderStatusLable.textAlignment = NSTextAlignmentLeft;
        [_orderNumberView addSubview:orderStatusLable];

        
        UILabel *addTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(40, orderStatusLable.frame.origin.y + textHeight + RowInterval, ScreenWidth - 50, textHeight)];
        addTimeLable.text = [NSString stringWithFormat:@"创建时间:%@",[TimeStamp timeStampSwitchTime:_orderModel.addTime]];
        addTimeLable.font = [UIFont systemFontOfSize:LableFountSize];
        addTimeLable.textColor = TextColor149;
        addTimeLable.textAlignment = NSTextAlignmentLeft;
        [_orderNumberView addSubview:addTimeLable];
        
        
        UILabel *payTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(40, addTimeLable.frame.origin.y + textHeight + RowInterval, ScreenWidth - 50, textHeight)];
        payTimeLable.text = [NSString stringWithFormat:@"付款时间:%@",[TimeStamp timeStampSwitchTime:_orderModel.payTime]];
        payTimeLable.font = [UIFont systemFontOfSize:LableFountSize];
        payTimeLable.textColor = TextColor149;
        payTimeLable.textAlignment = NSTextAlignmentLeft;
        [_orderNumberView addSubview:payTimeLable];
        
        
        
        UILabel *sendLable = [[UILabel alloc]initWithFrame:CGRectMake(40, payTimeLable.frame.origin.y + textHeight + RowInterval, ScreenWidth - 50, textHeight)];
        sendLable.text = [NSString stringWithFormat:@"发货时间:%@",[TimeStamp timeStampSwitchTime:_orderModel.shippingTime]];
        sendLable.font = [UIFont systemFontOfSize:LableFountSize];
        sendLable.textColor = TextColor149;
        sendLable.textAlignment = NSTextAlignmentLeft;
        [_orderNumberView addSubview:sendLable];
        
        
        UILabel *grayLable = [[UILabel alloc]init];
        grayLable.backgroundColor = GrayColor;
        [_orderNumberView addSubview:grayLable];
        
        _orderNumberView.frame = CGRectMake(0, _addressView.frame.origin.y + CGRectGetHeight(_addressView.frame), ScreenWidth, sendLable.frame.origin.y + textHeight + 10);
        grayLable.frame = CGRectMake(0, CGRectGetHeight(_orderNumberView.frame) - 1, ScreenWidth, 1);

    }
    
    return _orderNumberView;
}

- (UIView *)commodityView
{
    if (_commodityView == nil)
    {
        _commodityView = [[UIView alloc]init];
        
        __block CGFloat y = 0.0;
        __block CGFloat height = 100.0;
        
        [_orderModel.goodsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            OrderDetaileProductView *cellView = [[OrderDetaileProductView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, 100) ProductModel:obj];
            [cellView.refundButton addTarget:self action:@selector(refundButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cellView.refundButton.tag = idx + 10;
            
            [_commodityView addSubview:cellView];
            
            height = cellView.frame.size.height;
            y = cellView.frame.origin.y + height;
        }];
        
        
        _commodityView.frame = CGRectMake(0, _orderNumberView.frame.origin.y + CGRectGetHeight(_orderNumberView.frame), ScreenWidth,y);
        
    }
    
    
    return _commodityView;
}

- (UIView *)freeView
{
    if (_freeView == nil)
    {
        _freeView = [[UIView alloc]init];
        
        UILabel *sendFreeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        sendFreeLable.text = [NSString stringWithFormat:@"运费合计"];
        sendFreeLable.font = [UIFont systemFontOfSize:LableFountSize];
        sendFreeLable.textColor = TextColor149;
        sendFreeLable.textAlignment = NSTextAlignmentLeft;
        [_freeView addSubview:sendFreeLable];
        
        
        UILabel *sendPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 10, 150, 20)];
        sendPriceLable.text = [NSString stringWithFormat:@"￥%@",_orderModel.shippingFee];
        sendPriceLable.font = [UIFont systemFontOfSize:14];
        sendPriceLable.textColor = TextColorPurple;
        sendPriceLable.textAlignment = NSTextAlignmentRight;
        [_freeView addSubview:sendPriceLable];
        
        
        UILabel *goodsFreeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 20)];
        goodsFreeLable.text = [NSString stringWithFormat:@"商品总额"];
        goodsFreeLable.font = [UIFont systemFontOfSize:LableFountSize];
        goodsFreeLable.textColor = TextColor149;
        goodsFreeLable.textAlignment = NSTextAlignmentLeft;
        [_freeView addSubview:goodsFreeLable];
        
        
        UILabel *goodsPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 160, 35, 150, 20)];
        goodsPriceLable.text = [NSString stringWithFormat:@"￥%@",_orderModel.goodsAmount];
        goodsPriceLable.font = [UIFont systemFontOfSize:14];
        goodsPriceLable.textColor = TextColorPurple;
        goodsPriceLable.textAlignment = NSTextAlignmentRight;
        [_freeView addSubview:goodsPriceLable];

        
        
        UILabel *totalPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, ScreenWidth - 50, 20)];
        totalPriceLable.text = [NSString stringWithFormat:@"￥%@",_orderModel.totalFee];
        totalPriceLable.font = [UIFont systemFontOfSize:LableFountSize];
        totalPriceLable.textColor = TextColorPurple;
        totalPriceLable.textAlignment = NSTextAlignmentRight;
        [_freeView addSubview:totalPriceLable];
        
        
        CGFloat textWidth = [totalPriceLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : totalPriceLable.font} context:nil].size.width;
        totalPriceLable.frame = CGRectMake(ScreenWidth - 10 - textWidth, 60, textWidth, 20);
        
        
        UILabel *totalFreeLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 10 - textWidth - 100, 60, 100, 20)];
        totalFreeLable.text = [NSString stringWithFormat:@"合计："];
        totalFreeLable.font = [UIFont systemFontOfSize:LableFountSize];
        totalFreeLable.textColor = TextColorBlack;
        totalFreeLable.textAlignment = NSTextAlignmentRight;
        [_freeView addSubview:totalFreeLable];

        
        _freeView.frame = CGRectMake(0, _commodityView.frame.origin.y + CGRectGetHeight(_commodityView.frame), ScreenWidth, totalFreeLable.frame.origin.y + CGRectGetHeight(totalFreeLable.frame) + 10);

        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_freeView.frame) - 1, ScreenWidth, 1)];
        grayLable.backgroundColor = GrayColor;
        [_freeView addSubview:grayLable];
        
        
        
    }
    return _freeView;
    
}

- (UIView *)linkView
{
    if (_linkView == nil)
    {
        _linkView = [[UIView alloc]init];

        
        CGFloat buttonWidth = ScreenWidth / 2.0;
        
        CGFloat imageSpace = (buttonWidth - 17) / 2.0;
        
        UIButton *imButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imButton.adjustsImageWhenHighlighted = NO;
        imButton.adjustsImageWhenDisabled = NO;
        imButton.frame = CGRectMake(0, 0, buttonWidth, 45);
        imButton.imageEdgeInsets = UIEdgeInsetsMake(14, imageSpace - 20, 14, imageSpace + 20);
        [imButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [imButton setImage:[UIImage imageNamed:@"orderDetaile_IM"]forState:UIControlStateNormal];
        [imButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        imButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [imButton addTarget:self action:@selector(linkServicerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_linkView addSubview:imButton];
        
        
        UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneButton.adjustsImageWhenHighlighted = NO;
        phoneButton.adjustsImageWhenDisabled = NO;
        phoneButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, 45);
        phoneButton.imageEdgeInsets = UIEdgeInsetsMake(14, imageSpace - 20, 14, imageSpace + 20);
        [phoneButton setTitle:@"拨打电话" forState:UIControlStateNormal];
        [phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [phoneButton setImage:[UIImage imageNamed:@"orderDetaile_Phone"] forState:UIControlStateNormal];
        [phoneButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        phoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_linkView addSubview:phoneButton];
        
        
        UILabel *grayLable1 = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth - 0.5, 0, 1, 45)];
        grayLable1.backgroundColor = GrayColor;
        [_linkView addSubview:grayLable1];
        
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 45 -1, ScreenWidth, 1)];
        grayLable.backgroundColor = GrayColor;
        [_linkView addSubview:grayLable];
        
        
        _linkView.frame = CGRectMake(0, _freeView.frame.origin.y + CGRectGetHeight(_freeView.frame), ScreenWidth, 45);
        
        
    }
    
    return _linkView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
        _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - CGRectGetHeight(_bottomView.frame));
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        grayLable.backgroundColor = GrayColor;
        [_bottomView addSubview:grayLable];
        

        //待付款  剩余关闭时间 取消订单 立即付款
        //待收货
        //交易成功 删除订单
        //交易取消 删除订单
        
//        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 13, 13)];
//        imageview.contentMode = UIViewContentModeScaleAspectFit;
//        imageview.image = [UIImage imageNamed:@"orderDetaile_DownTime"];
//        [_bottomView addSubview:imageview];
        
//        UILabel *shengLable = [[UILabel alloc]init];
//        shengLable.text = [NSString stringWithFormat:@"剩余"];
//        shengLable.font = [UIFont systemFontOfSize:LableFountSize];
//        shengLable.textColor = TextColor149;
//        shengLable.textAlignment = NSTextAlignmentRight;
//        CGFloat textWidth = [shengLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : shengLable.font} context:nil].size.width;
//        shengLable.frame = CGRectMake(30, 12.5, textWidth, 20);
//        [_bottomView addSubview:shengLable];

        
//        UILabel *countLable = [[UILabel alloc]init];
//        countLable.font = [UIFont systemFontOfSize:LableFountSize];
//        countLable.textColor = TextColor149;
//        countLable.textAlignment = NSTextAlignmentRight;
//        CGFloat countWidth = [@"19:59:39" boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : countLable.font} context:nil].size.width;
//        countLable.frame = CGRectMake(shengLable.frame.origin.x + CGRectGetWidth(shengLable.frame), 12.5, countWidth, 20);
//        [_bottomView addSubview:countLable];
        
//        CountdownTimeLable *timer3 = [[CountdownTimeLable alloc] initWithLabel:countLable andTimerType:CountTimerLabelTypeTimer];
//        [timer3 setCountDownTime:60 * 60 * 23];
//        [timer3 start];
//        
//        UILabel *shutLable = [[UILabel alloc]init];
//        shutLable.text = [NSString stringWithFormat:@"自动关闭"];
//        shutLable.font = [UIFont systemFontOfSize:LableFountSize];
//        shutLable.textColor = TextColor149;
//        shutLable.textAlignment = NSTextAlignmentRight;
//        CGFloat shutWidth = [shutLable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : shutLable.font} context:nil].size.width;
//        shutLable.frame = CGRectMake(countLable.frame.origin.x + CGRectGetWidth(countLable.frame), 12.5, shutWidth, 20);
//        [_bottomView addSubview:shutLable];
        
        if (_orderType == 6)//待收货 剩余确认时间  查看物流 确认收货
        {
            
            UIButton *payMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [payMoneyButton setTitle:@"立即付款" forState:UIControlStateNormal];
            payMoneyButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
            [payMoneyButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            payMoneyButton.layer.cornerRadius = 2;
            payMoneyButton.clipsToBounds = YES;
            payMoneyButton.layer.borderWidth = 1;
            [payMoneyButton addTarget:self action:@selector(payMoneyButtonClick) forControlEvents:UIControlEventTouchUpInside];
            payMoneyButton.layer.borderColor = TextColorPurple.CGColor;
            payMoneyButton.frame = CGRectMake(ScreenWidth - 80 , 7, 70, 30);
            [_bottomView addSubview:payMoneyButton];
            
            
            UIButton *cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
            cancelOrderButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
            [cancelOrderButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            cancelOrderButton.layer.cornerRadius = 2;
            cancelOrderButton.clipsToBounds = YES;
            cancelOrderButton.layer.borderWidth = 1;
            [cancelOrderButton addTarget:self action:@selector(cancelOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            cancelOrderButton.layer.borderColor = TextColor149.CGColor;
            cancelOrderButton.frame = CGRectMake(ScreenWidth - 160 , 7, 70, 30);
            [_bottomView addSubview:cancelOrderButton];
        }
        
        
        
        if (YES)//待收货 剩余确认时间  查看物流 确认收货
        {
            UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
            confirmButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
            [confirmButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            confirmButton.layer.cornerRadius = 2;
            confirmButton.clipsToBounds = YES;
            confirmButton.layer.borderWidth = 1;
            [confirmButton addTarget:self action:@selector(confirmOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            confirmButton.layer.borderColor = TextColorPurple.CGColor;
            confirmButton.frame = CGRectMake(ScreenWidth - 80 , 7, 70, 30);
            [_bottomView addSubview:confirmButton];
            
            
            UIButton *lookLogisticsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [lookLogisticsButton setTitle:@"查看物流" forState:UIControlStateNormal];
            lookLogisticsButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
            [lookLogisticsButton setTitleColor:TextColor149 forState:UIControlStateNormal];
            lookLogisticsButton.layer.cornerRadius = 2;
            lookLogisticsButton.clipsToBounds = YES;
            lookLogisticsButton.layer.borderWidth = 1;
            [lookLogisticsButton addTarget:self action:@selector(lookLogisticsButtonClick) forControlEvents:UIControlEventTouchUpInside];
            lookLogisticsButton.layer.borderColor = TextColor149.CGColor;
            lookLogisticsButton.frame = CGRectMake(ScreenWidth - 160 , 7, 70, 30);
            [_bottomView addSubview:lookLogisticsButton];
        }
        
        
        
        
        if (_orderType == 5)//交易成功 交易取消
        {
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
            deleteButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
            [deleteButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
            deleteButton.layer.cornerRadius = 2;
            deleteButton.clipsToBounds = YES;
            deleteButton.layer.borderWidth = 1;
            [deleteButton addTarget:self action:@selector(deleteOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.layer.borderColor = TextColorPurple.CGColor;
            deleteButton.frame = CGRectMake(ScreenWidth - 80 , 7, 70, 30);
            [_bottomView addSubview:deleteButton];

        }
        
        
    }
    
    
    return _bottomView;
}



- (void)linkServicerButtonClick
{
    //联系客服
    ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
    [self  presentViewController:nav animated:YES completion:nil];
    
    
}


- (void)phoneButtonClick
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:4006668800"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006668800"]];
}

- (void)payMoneyButtonClick
{
    
}

- (void)cancelOrderButtonClick
{
    
}

- (void)confirmOrderButtonClick
{
    
}

- (void)refundButtonButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    
    OrderProductModel *model = _orderModel.goodsList[index];
    
    
    
    ApplyRefundVC *refundVC = [[ApplyRefundVC alloc]init];
    [refundVC.modelArray addObject:model];
    [self.navigationController pushViewController:refundVC animated:YES];
    
}

- (void)lookLogisticsButtonClick
{
    LookLogisticsVC *logisticsVC = [[LookLogisticsVC alloc]init];
    
    [self.navigationController pushViewController:logisticsVC animated:YES];
}

- (void)deleteOrderButtonClick
{
    
}

@end
