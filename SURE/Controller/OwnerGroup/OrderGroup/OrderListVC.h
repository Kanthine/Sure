//
//  OrderListVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger ,OrderState)
{
    OrderStateAll = 0,
    OrderStateWaitPay,
    OrderStateWaitSendGoods,
    OrderStateReceiveGoods,
    OrderStateWaitSure,
};


@interface OrderListVC : BaseViewController


@property (nonatomic ,assign) OrderState orderType;

@end

/*
 订单状态：
 order_status ： 
 0 未确认
 1 已确认
 2 已取消
 3 无效
 4 退货
 
 
 物流状态：
 shipping_status：
 0 未发货
 1 已发货
 2 已收货
 3 备货中
 
 付款状态：
 pay_status：
 0 未付款
 1 付款中
 2 已付款
 */


/*
 待付款  等待买家付款 （付款状态 0 1）&&（订单状态 0）
 待发货 ： 买家已付款 （付款状态 2）&&（物流状态 0）&&（订单状态 1） 退款中：
 待发货 ： 卖家已发货 （付款状态 2）&&（物流状态 1）&&（订单状态 1） 退款中：
 待SURE   交易成功  （付款状态 2）&&（物流状态 2）
 */

//我的订单 退款售后 收藏单品 收藏品牌 优惠券 购物车 SURE界面  商铺详情页面
