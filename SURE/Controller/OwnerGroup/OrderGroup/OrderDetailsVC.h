//
//  OrderDetailsVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger ,OrderType)
{
    OrderTypeAll = 0,
    OrderTypeWaitPay,
    OrderTypeWaitSendGoods,
    OrderTypeReceiveGoods,
    OrderTypeWaitSure,
};


@interface OrderDetailsVC : UIViewController


@property (nonatomic ,assign) OrderType orderType;

@property (nonatomic ,strong) OrderModel *orderModel;

@end
