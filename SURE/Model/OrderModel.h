//
//  OrderModel.h
//
//  Created by   on 16/11/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderProductModel.h"


@interface OrderModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *cardFee;
@property (nonatomic, strong) NSString *shippingStatus;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *payFee;
@property (nonatomic, strong) NSString *invoiceNo;
@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *orderSn;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *insureFee;
@property (nonatomic, strong) NSString *buyer;
@property (nonatomic, strong) NSString *tax;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *postscript;
@property (nonatomic, strong) NSString *shippingTime;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *payNote;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *confirmTime;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *packFee;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *toBuyer;
@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSArray *goodsList;
@property (nonatomic, strong) NSString *goodsAmount;
@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *shippingFee;
@property (nonatomic, strong) NSString *allStatus;
@property (nonatomic, strong) NSString *goodsListNumber;

@property (nonatomic, strong) NSString *brandNameString;
@property (nonatomic, strong) NSString *brandIDString;
@property (nonatomic, strong) NSString *brandLogo;




+ (NSMutableArray *)parserDataWithOrderListArray:(NSArray *)orderListArray;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;




@end


//NSString *order_status;//订单状态
//NSString *shipping_status;//物流状态
//NSString *pay_status;//付款状态
//NSString *order_sn;
//NSString *goods_amount;//商品价钱
//NSString *shipping_fee;//运费
//NSString *total_fee;//总价



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



