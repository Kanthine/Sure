//
//  OrderModel.m
//
//  Created by   on 16/11/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "OrderModel.h"


NSString *const kOrderModelCardFee = @"card_fee";
NSString *const kOrderModelShippingStatus = @"shipping_status";
NSString *const kOrderModelZipcode = @"zipcode";
NSString *const kOrderModelAddress = @"address";
NSString *const kOrderModelPayFee = @"pay_fee";
NSString *const kOrderModelInvoiceNo = @"invoice_no";
NSString *const kOrderModelPayStatus = @"pay_status";
NSString *const kOrderModelTel = @"tel";
NSString *const kOrderModelOrderStatus = @"order_status";
NSString *const kOrderModelDistrict = @"district";
NSString *const kOrderModelConsignee = @"consignee";
NSString *const kOrderModelAddTime = @"add_time";
NSString *const kOrderModelOrderSn = @"order_sn";
NSString *const kOrderModelEmail = @"email";
NSString *const kOrderModelInsureFee = @"insure_fee";
NSString *const kOrderModelBuyer = @"buyer";
NSString *const kOrderModelTax = @"tax";
NSString *const kOrderModelOrderId = @"order_id";
NSString *const kOrderModelCity = @"city";
NSString *const kOrderModelPostscript = @"postscript";
NSString *const kOrderModelShippingTime = @"shipping_time";
NSString *const kOrderModelMobile = @"mobile";
NSString *const kOrderModelPayTime = @"pay_time";
NSString *const kOrderModelPayNote = @"pay_note";
NSString *const kOrderModelProvince = @"province";
NSString *const kOrderModelConfirmTime = @"confirm_time";
NSString *const kOrderModelUserId = @"user_id";
NSString *const kOrderModelProvinceName = @"province_name";
NSString *const kOrderModelPackFee = @"pack_fee";
NSString *const kOrderModelCityName = @"city_name";
NSString *const kOrderModelToBuyer = @"to_buyer";
NSString *const kOrderModelTotalFee = @"total_fee";
NSString *const kOrderModelGoodsList = @"goods_list";
NSString *const kOrderModelGoodsAmount = @"goods_amount";
NSString *const kOrderModelDistrictName = @"district_name";
NSString *const kOrderModelDiscount = @"discount";
NSString *const kOrderModelShippingFee = @"shipping_fee";
NSString *const kOrderModelAllStatus = @"all_status";
NSString *const kOrderModelGoodsListNumber = @"goods_list_number";
NSString *const kOrderModelBrandName = @"supplier_name";
NSString *const kOrderModelBrandLogo = @"brand_img";
NSString *const kOrderModelBrandID= @"supplier_id";

@interface OrderModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderModel

@synthesize cardFee = _cardFee;
@synthesize shippingStatus = _shippingStatus;
@synthesize zipcode = _zipcode;
@synthesize address = _address;
@synthesize payFee = _payFee;
@synthesize invoiceNo = _invoiceNo;
@synthesize payStatus = _payStatus;
@synthesize tel = _tel;
@synthesize orderStatus = _orderStatus;
@synthesize district = _district;
@synthesize consignee = _consignee;
@synthesize addTime = _addTime;
@synthesize orderSn = _orderSn;
@synthesize email = _email;
@synthesize insureFee = _insureFee;
@synthesize buyer = _buyer;
@synthesize tax = _tax;
@synthesize orderId = _orderId;
@synthesize city = _city;
@synthesize postscript = _postscript;
@synthesize shippingTime = _shippingTime;
@synthesize mobile = _mobile;
@synthesize payTime = _payTime;
@synthesize payNote = _payNote;
@synthesize province = _province;
@synthesize confirmTime = _confirmTime;
@synthesize userId = _userId;
@synthesize provinceName = _provinceName;
@synthesize packFee = _packFee;
@synthesize cityName = _cityName;
@synthesize toBuyer = _toBuyer;
@synthesize totalFee = _totalFee;
@synthesize goodsList = _goodsList;
@synthesize goodsAmount = _goodsAmount;
@synthesize districtName = _districtName;
@synthesize discount = _discount;
@synthesize shippingFee = _shippingFee;
@synthesize allStatus = _allStatus;
@synthesize goodsListNumber = _goodsListNumber;
@synthesize brandNameString = _brandNameString;
@synthesize brandLogo = _brandLogo;
@synthesize brandIDString = _brandIDString;

+ (NSMutableArray *)parserDataWithOrderListArray:(NSArray *)orderListArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    [orderListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         OrderModel *orderModel = [OrderModel modelObjectWithDictionary:obj];
         [parserArray addObject:orderModel];
     }];
    
    return parserArray;
}


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.cardFee = [self objectOrNilForKey:kOrderModelCardFee fromDictionary:dict];
            self.shippingStatus = [self objectOrNilForKey:kOrderModelShippingStatus fromDictionary:dict];
            self.zipcode = [self objectOrNilForKey:kOrderModelZipcode fromDictionary:dict];
            self.address = [self objectOrNilForKey:kOrderModelAddress fromDictionary:dict];
            self.payFee = [self objectOrNilForKey:kOrderModelPayFee fromDictionary:dict];
            self.invoiceNo = [self objectOrNilForKey:kOrderModelInvoiceNo fromDictionary:dict];
            self.payStatus = [self objectOrNilForKey:kOrderModelPayStatus fromDictionary:dict];
            self.tel = [self objectOrNilForKey:kOrderModelTel fromDictionary:dict];
            self.orderStatus = [self objectOrNilForKey:kOrderModelOrderStatus fromDictionary:dict];
            self.district = [self objectOrNilForKey:kOrderModelDistrict fromDictionary:dict];
            self.consignee = [self objectOrNilForKey:kOrderModelConsignee fromDictionary:dict];
            self.addTime = [self objectOrNilForKey:kOrderModelAddTime fromDictionary:dict];
            self.orderSn = [self objectOrNilForKey:kOrderModelOrderSn fromDictionary:dict];
            self.email = [self objectOrNilForKey:kOrderModelEmail fromDictionary:dict];
            self.insureFee = [self objectOrNilForKey:kOrderModelInsureFee fromDictionary:dict];
            self.buyer = [self objectOrNilForKey:kOrderModelBuyer fromDictionary:dict];
            self.tax = [self objectOrNilForKey:kOrderModelTax fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kOrderModelOrderId fromDictionary:dict];
            self.city = [self objectOrNilForKey:kOrderModelCity fromDictionary:dict];
            self.postscript = [self objectOrNilForKey:kOrderModelPostscript fromDictionary:dict];
            self.shippingTime = [self objectOrNilForKey:kOrderModelShippingTime fromDictionary:dict];
            self.mobile = [self objectOrNilForKey:kOrderModelMobile fromDictionary:dict];
            self.payTime = [self objectOrNilForKey:kOrderModelPayTime fromDictionary:dict];
            self.payNote = [self objectOrNilForKey:kOrderModelPayNote fromDictionary:dict];
            self.province = [self objectOrNilForKey:kOrderModelProvince fromDictionary:dict];
            self.confirmTime = [self objectOrNilForKey:kOrderModelConfirmTime fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kOrderModelUserId fromDictionary:dict];
            self.provinceName = [self objectOrNilForKey:kOrderModelProvinceName fromDictionary:dict];
            self.packFee = [self objectOrNilForKey:kOrderModelPackFee fromDictionary:dict];
            self.cityName = [self objectOrNilForKey:kOrderModelCityName fromDictionary:dict];
            self.toBuyer = [self objectOrNilForKey:kOrderModelToBuyer fromDictionary:dict];
            self.totalFee = [self objectOrNilForKey:kOrderModelTotalFee fromDictionary:dict];
            self.allStatus = [self objectOrNilForKey:kOrderModelAllStatus fromDictionary:dict];
        
        
        
        NSDictionary *shopInfoDict = [self objectOrNilForKey:@"shop_info" fromDictionary:dict];
        if (shopInfoDict && [shopInfoDict isKindOfClass:[NSDictionary class]])
        {
            self.brandNameString = [self objectOrNilForKey:kOrderModelBrandName fromDictionary:shopInfoDict];
        }
        
        

        self.brandLogo = [self objectOrNilForKey:kOrderModelBrandLogo fromDictionary:dict];
        self.brandIDString = [self objectOrNilForKey:kOrderModelBrandID fromDictionary:dict];

        

        self.goodsListNumber = [self objectOrNilForKey:kOrderModelGoodsListNumber fromDictionary:dict];
            

        
    NSObject *receivedGoodsList = [dict objectForKey:kOrderModelGoodsList];
    NSMutableArray *parsedGoodsList = [NSMutableArray array];
    if ([receivedGoodsList isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *item in (NSArray *)receivedGoodsList)
        {
            if ([item isKindOfClass:[NSDictionary class]])
            {
                [parsedGoodsList addObject:[OrderProductModel modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedGoodsList isKindOfClass:[NSDictionary class]])
    {
       [parsedGoodsList addObject:[OrderProductModel modelObjectWithDictionary:(NSDictionary *)receivedGoodsList]];
    }
    
    self.goodsList = [NSArray arrayWithArray:parsedGoodsList];
    self.goodsAmount = [self objectOrNilForKey:kOrderModelGoodsAmount fromDictionary:dict];
    self.districtName = [self objectOrNilForKey:kOrderModelDistrictName fromDictionary:dict];
    self.discount = [self objectOrNilForKey:kOrderModelDiscount fromDictionary:dict];
    self.shippingFee = [self objectOrNilForKey:kOrderModelShippingFee fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cardFee forKey:kOrderModelCardFee];
    [mutableDict setValue:self.shippingStatus forKey:kOrderModelShippingStatus];
    [mutableDict setValue:self.zipcode forKey:kOrderModelZipcode];
    [mutableDict setValue:self.address forKey:kOrderModelAddress];
    [mutableDict setValue:self.payFee forKey:kOrderModelPayFee];
    [mutableDict setValue:self.invoiceNo forKey:kOrderModelInvoiceNo];
    [mutableDict setValue:self.payStatus forKey:kOrderModelPayStatus];
    [mutableDict setValue:self.tel forKey:kOrderModelTel];
    [mutableDict setValue:self.orderStatus forKey:kOrderModelOrderStatus];
    [mutableDict setValue:self.district forKey:kOrderModelDistrict];
    [mutableDict setValue:self.consignee forKey:kOrderModelConsignee];
    [mutableDict setValue:self.addTime forKey:kOrderModelAddTime];
    [mutableDict setValue:self.orderSn forKey:kOrderModelOrderSn];
    [mutableDict setValue:self.email forKey:kOrderModelEmail];
    [mutableDict setValue:self.insureFee forKey:kOrderModelInsureFee];
    [mutableDict setValue:self.buyer forKey:kOrderModelBuyer];
    [mutableDict setValue:self.tax forKey:kOrderModelTax];
    [mutableDict setValue:self.orderId forKey:kOrderModelOrderId];
    [mutableDict setValue:self.city forKey:kOrderModelCity];
    [mutableDict setValue:self.postscript forKey:kOrderModelPostscript];
    [mutableDict setValue:self.shippingTime forKey:kOrderModelShippingTime];
    [mutableDict setValue:self.mobile forKey:kOrderModelMobile];
    [mutableDict setValue:self.payTime forKey:kOrderModelPayTime];
    [mutableDict setValue:self.payNote forKey:kOrderModelPayNote];
    [mutableDict setValue:self.province forKey:kOrderModelProvince];
    [mutableDict setValue:self.confirmTime forKey:kOrderModelConfirmTime];
    [mutableDict setValue:self.userId forKey:kOrderModelUserId];
    [mutableDict setValue:self.provinceName forKey:kOrderModelProvinceName];
    [mutableDict setValue:self.packFee forKey:kOrderModelPackFee];
    [mutableDict setValue:self.cityName forKey:kOrderModelCityName];
    [mutableDict setValue:self.toBuyer forKey:kOrderModelToBuyer];
    [mutableDict setValue:self.totalFee forKey:kOrderModelTotalFee];
    [mutableDict setValue:self.goodsListNumber forKey:kOrderModelGoodsListNumber];
    [mutableDict setValue:self.allStatus forKey:kOrderModelAllStatus];
    [mutableDict setValue:self.brandNameString forKey:kOrderModelBrandName];
    [mutableDict setValue:self.brandLogo forKey:kOrderModelBrandLogo];
    [mutableDict setValue:self.brandIDString forKey:kOrderModelBrandID];

    
    
    NSMutableArray *tempArrayForGoodsList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.goodsList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGoodsList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGoodsList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGoodsList] forKey:kOrderModelGoodsList];
    [mutableDict setValue:self.goodsAmount forKey:kOrderModelGoodsAmount];
    [mutableDict setValue:self.districtName forKey:kOrderModelDistrictName];
    [mutableDict setValue:self.discount forKey:kOrderModelDiscount];
    [mutableDict setValue:self.shippingFee forKey:kOrderModelShippingFee];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.cardFee = [aDecoder decodeObjectForKey:kOrderModelCardFee];
    self.shippingStatus = [aDecoder decodeObjectForKey:kOrderModelShippingStatus];
    self.zipcode = [aDecoder decodeObjectForKey:kOrderModelZipcode];
    self.address = [aDecoder decodeObjectForKey:kOrderModelAddress];
    self.payFee = [aDecoder decodeObjectForKey:kOrderModelPayFee];
    self.invoiceNo = [aDecoder decodeObjectForKey:kOrderModelInvoiceNo];
    self.payStatus = [aDecoder decodeObjectForKey:kOrderModelPayStatus];
    self.tel = [aDecoder decodeObjectForKey:kOrderModelTel];
    self.orderStatus = [aDecoder decodeObjectForKey:kOrderModelOrderStatus];
    self.district = [aDecoder decodeObjectForKey:kOrderModelDistrict];
    self.consignee = [aDecoder decodeObjectForKey:kOrderModelConsignee];
    self.addTime = [aDecoder decodeObjectForKey:kOrderModelAddTime];
    self.orderSn = [aDecoder decodeObjectForKey:kOrderModelOrderSn];
    self.email = [aDecoder decodeObjectForKey:kOrderModelEmail];
    self.insureFee = [aDecoder decodeObjectForKey:kOrderModelInsureFee];
    self.buyer = [aDecoder decodeObjectForKey:kOrderModelBuyer];
    self.tax = [aDecoder decodeObjectForKey:kOrderModelTax];
    self.orderId = [aDecoder decodeObjectForKey:kOrderModelOrderId];
    self.city = [aDecoder decodeObjectForKey:kOrderModelCity];
    self.postscript = [aDecoder decodeObjectForKey:kOrderModelPostscript];
    self.shippingTime = [aDecoder decodeObjectForKey:kOrderModelShippingTime];
    self.mobile = [aDecoder decodeObjectForKey:kOrderModelMobile];
    self.payTime = [aDecoder decodeObjectForKey:kOrderModelPayTime];
    self.payNote = [aDecoder decodeObjectForKey:kOrderModelPayNote];
    self.province = [aDecoder decodeObjectForKey:kOrderModelProvince];
    self.confirmTime = [aDecoder decodeObjectForKey:kOrderModelConfirmTime];
    self.userId = [aDecoder decodeObjectForKey:kOrderModelUserId];
    self.provinceName = [aDecoder decodeObjectForKey:kOrderModelProvinceName];
    self.packFee = [aDecoder decodeObjectForKey:kOrderModelPackFee];
    self.cityName = [aDecoder decodeObjectForKey:kOrderModelCityName];
    self.toBuyer = [aDecoder decodeObjectForKey:kOrderModelToBuyer];
    self.totalFee = [aDecoder decodeObjectForKey:kOrderModelTotalFee];
    self.goodsList = [aDecoder decodeObjectForKey:kOrderModelGoodsList];
    self.goodsAmount = [aDecoder decodeObjectForKey:kOrderModelGoodsAmount];
    self.districtName = [aDecoder decodeObjectForKey:kOrderModelDistrictName];
    self.discount = [aDecoder decodeObjectForKey:kOrderModelDiscount];
    self.shippingFee = [aDecoder decodeObjectForKey:kOrderModelShippingFee];
    self.allStatus = [aDecoder decodeObjectForKey:kOrderModelAllStatus];
    self.goodsListNumber = [aDecoder decodeObjectForKey:kOrderModelGoodsListNumber];
    self.brandNameString = [aDecoder decodeObjectForKey:kOrderModelBrandName];
    self.brandLogo = [aDecoder decodeObjectForKey:kOrderModelBrandLogo];
    self.brandIDString = [aDecoder decodeObjectForKey:kOrderModelBrandID];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cardFee forKey:kOrderModelCardFee];
    [aCoder encodeObject:_shippingStatus forKey:kOrderModelShippingStatus];
    [aCoder encodeObject:_zipcode forKey:kOrderModelZipcode];
    [aCoder encodeObject:_address forKey:kOrderModelAddress];
    [aCoder encodeObject:_payFee forKey:kOrderModelPayFee];
    [aCoder encodeObject:_invoiceNo forKey:kOrderModelInvoiceNo];
    [aCoder encodeObject:_payStatus forKey:kOrderModelPayStatus];
    [aCoder encodeObject:_tel forKey:kOrderModelTel];
    [aCoder encodeObject:_orderStatus forKey:kOrderModelOrderStatus];
    [aCoder encodeObject:_district forKey:kOrderModelDistrict];
    [aCoder encodeObject:_consignee forKey:kOrderModelConsignee];
    [aCoder encodeObject:_addTime forKey:kOrderModelAddTime];
    [aCoder encodeObject:_orderSn forKey:kOrderModelOrderSn];
    [aCoder encodeObject:_email forKey:kOrderModelEmail];
    [aCoder encodeObject:_insureFee forKey:kOrderModelInsureFee];
    [aCoder encodeObject:_buyer forKey:kOrderModelBuyer];
    [aCoder encodeObject:_tax forKey:kOrderModelTax];
    [aCoder encodeObject:_orderId forKey:kOrderModelOrderId];
    [aCoder encodeObject:_city forKey:kOrderModelCity];
    [aCoder encodeObject:_postscript forKey:kOrderModelPostscript];
    [aCoder encodeObject:_shippingTime forKey:kOrderModelShippingTime];
    [aCoder encodeObject:_mobile forKey:kOrderModelMobile];
    [aCoder encodeObject:_payTime forKey:kOrderModelPayTime];
    [aCoder encodeObject:_payNote forKey:kOrderModelPayNote];
    [aCoder encodeObject:_province forKey:kOrderModelProvince];
    [aCoder encodeObject:_confirmTime forKey:kOrderModelConfirmTime];
    [aCoder encodeObject:_userId forKey:kOrderModelUserId];
    [aCoder encodeObject:_provinceName forKey:kOrderModelProvinceName];
    [aCoder encodeObject:_packFee forKey:kOrderModelPackFee];
    [aCoder encodeObject:_cityName forKey:kOrderModelCityName];
    [aCoder encodeObject:_toBuyer forKey:kOrderModelToBuyer];
    [aCoder encodeObject:_totalFee forKey:kOrderModelTotalFee];
    [aCoder encodeObject:_goodsList forKey:kOrderModelGoodsList];
    [aCoder encodeObject:_goodsAmount forKey:kOrderModelGoodsAmount];
    [aCoder encodeObject:_districtName forKey:kOrderModelDistrictName];
    [aCoder encodeObject:_discount forKey:kOrderModelDiscount];
    [aCoder encodeObject:_shippingFee forKey:kOrderModelShippingFee];
    [aCoder encodeObject:_brandNameString forKey:kOrderModelBrandName];
    [aCoder encodeObject:_brandLogo forKey:kOrderModelBrandLogo];
    [aCoder encodeObject:_brandIDString forKey:kOrderModelBrandID];

    [aCoder encodeObject:_goodsListNumber forKey:kOrderModelGoodsListNumber];
    [aCoder encodeObject:_allStatus forKey:kOrderModelAllStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    OrderModel *copy = [[OrderModel alloc] init];
    
    if (copy) {

        copy.cardFee = [self.cardFee copyWithZone:zone];
        copy.shippingStatus = [self.shippingStatus copyWithZone:zone];
        copy.zipcode = [self.zipcode copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.payFee = [self.payFee copyWithZone:zone];
        copy.invoiceNo = [self.invoiceNo copyWithZone:zone];
        copy.payStatus = [self.payStatus copyWithZone:zone];
        copy.tel = [self.tel copyWithZone:zone];
        copy.orderStatus = [self.orderStatus copyWithZone:zone];
        copy.district = [self.district copyWithZone:zone];
        copy.consignee = [self.consignee copyWithZone:zone];
        copy.addTime = [self.addTime copyWithZone:zone];
        copy.orderSn = [self.orderSn copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.insureFee = [self.insureFee copyWithZone:zone];
        copy.buyer = [self.buyer copyWithZone:zone];
        copy.tax = [self.tax copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.postscript = [self.postscript copyWithZone:zone];
        copy.shippingTime = [self.shippingTime copyWithZone:zone];
        copy.mobile = [self.mobile copyWithZone:zone];
        copy.payTime = [self.payTime copyWithZone:zone];
        copy.payNote = [self.payNote copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.confirmTime = [self.confirmTime copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.provinceName = [self.provinceName copyWithZone:zone];
        copy.packFee = [self.packFee copyWithZone:zone];
        copy.cityName = [self.cityName copyWithZone:zone];
        copy.toBuyer = [self.toBuyer copyWithZone:zone];
        copy.totalFee = [self.totalFee copyWithZone:zone];
        copy.goodsList = [self.goodsList copyWithZone:zone];
        copy.goodsAmount = [self.goodsAmount copyWithZone:zone];
        copy.districtName = [self.districtName copyWithZone:zone];
        copy.discount = [self.discount copyWithZone:zone];
        copy.shippingFee = [self.shippingFee copyWithZone:zone];
        copy.goodsListNumber = [self.goodsListNumber copyWithZone:zone];
        copy.allStatus = [self.allStatus copyWithZone:zone];
        copy.brandNameString = [self.brandNameString copyWithZone:zone];
        copy.brandLogo = [self.brandLogo copyWithZone:zone];
        copy.brandIDString = [self.brandIDString copyWithZone:zone];

    }
    
    return copy;
}


@end
