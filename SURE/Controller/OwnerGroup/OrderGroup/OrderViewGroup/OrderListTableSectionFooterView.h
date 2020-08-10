//
//  OrderListTableSectionFooterView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define OrderListFooterViewHeight 120

#define describeText(count,sumPrice,freight)  [NSString stringWithFormat:@"共%d件商品 合计￥%.2f(含运费￥%.2f)",count,sumPrice,freight]

typedef NS_ENUM(NSInteger ,OrderTpye)
{
    OrderTpyeWaitPay = 0,
    OrderTpyeWaitSendGoods,
    OrderTpyeReceiveGoods,
    OrderTpyeWaitSure,
};

typedef NS_ENUM(NSInteger ,RefundTpye)
{
    RefundTpyeHandle = 0,
    RefundTpyeFinished,
};



#import <UIKit/UIKit.h>

@class BaseViewController;
@interface OrderListTableSectionFooterView : UITableViewHeaderFooterView


@property (nonatomic ,strong) BaseViewController *currentViewController;
@property (nonatomic ,strong) NSString *orderIDStr;
@property (nonatomic, assign) OrderTpye orderState;
@property (nonatomic ,assign) RefundTpye refundState;
@property (nonatomic ,strong) UILabel *describeLable;



@end


// 交易成功 查看物流 确认收货
//交易关闭 删除订单
//待发货 提醒发货
//待付款 联系客服 取消订单 付款
//待收货 延长收货 查看物流 确认收货
//待Suere  删除订单 评价
