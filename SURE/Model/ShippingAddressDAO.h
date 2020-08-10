//
//  ShippingAddressDAO.h
//  SURE
//
//  Created by 王玉龙 on 16/11/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShippingAdress;

@interface ShippingAddressDAO : NSObject

+ (NSMutableArray *)parserDataWithShippingAddressArray:(NSArray *)addressArray;//解析

//增 删 查 改
+ (void)insertShippingAdressWithModel:(ShippingAdress *)adressModel;


+ (void)deletaShippingAdressWithAdressID:(NSString *)addressID;


+ (void)deletaAllShippingAdress;


+ (NSArray *)queryShippingAdressWithAdressID:(NSString *)addressID;


+ (void)updateShippingAdressWithModel:(ShippingAdress *)adressModel;



@end
/*
 address_id : 16
 　　　　　　address_name :
 　　　　　　user_id : 1
 　　　　　　consignee : anan
 　　　　　　email : cuibo@68ecshop.com
 　　　　　　country : 1
 　　　　　　province : 10
 　　　　　　city : 145
 　　　　　　district : 1194
 　　　　　　address : 森林逸城B区
 　　　　　　zipcode :
 　　　　　　tel : --
 　　　　　　mobile : 18630360371
 　　　　　　sign_building :
 　　　　　　best_time :
 */
