//
//  ShippingAddressModel.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippingAddressModel : NSObject

@property (nonatomic ,assign) BOOL isDefaultAdress;
@property (nonatomic ,copy) NSString *nameString;
@property (nonatomic ,copy) NSString *phoneString;
@property (nonatomic ,copy) NSString *addressString;

@property (nonatomic ,copy) NSString *address_name;
@property (nonatomic ,copy) NSString *address_id;

@property (nonatomic ,copy) NSString *provinceID;
@property (nonatomic ,copy) NSString *cityID;
@property (nonatomic ,copy) NSString *districtID;

@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *district;
@property (nonatomic ,copy) NSString *provinceCityName;

+ (NSMutableArray *)parserDataWithShippingAddressArray:(NSArray *)addressArray;//解析

//增 删 查 改
+ (void)insertShippingAdressWithModel:(ShippingAddressModel *)adressModel;


+ (void)deletaShippingAdressWithModel:(ShippingAddressModel *)adressModel;


+ (NSArray *)queryShippingAdressWithModel:(ShippingAddressModel *)adressModel;


+ (void)updateShippingAdressWithModel:(ShippingAddressModel *)adressModel;

+ (void)deletaAllShippingAdress;

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
