//
//  OrderProductModel.m
//
//  Created by   on 16/11/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "OrderProductModel.h"


NSString *const kOrderProductModelGoodsNumber = @"goods_number";
NSString *const kOrderProductModelOrderId = @"order_id";
NSString *const kOrderProductModelGoodsAttrId = @"goods_attr_id";
NSString *const kOrderProductModelTotalPrice = @"total_price";
NSString *const kOrderProductModelGoodsPrice = @"goods_price";
NSString *const kOrderProductModelGoodsAttr = @"goods_attr";
NSString *const kOrderProductModelGoodsName = @"goods_name";
NSString *const kOrderProductModelGoodsId = @"goods_id";
NSString *const kOrderProductModelGoodsImg = @"goods_img";


@interface OrderProductModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation OrderProductModel

@synthesize goodsNumber = _goodsNumber;
@synthesize orderId = _orderId;
@synthesize goodsAttrId = _goodsAttrId;
@synthesize totalPrice = _totalPrice;
@synthesize goodsPrice = _goodsPrice;
@synthesize goodsAttr = _goodsAttr;
@synthesize goodsName = _goodsName;
@synthesize goodsId = _goodsId;
@synthesize goodsImg = _goodsImg;


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
            self.goodsNumber = [self objectOrNilForKey:kOrderProductModelGoodsNumber fromDictionary:dict];
            self.orderId = [self objectOrNilForKey:kOrderProductModelOrderId fromDictionary:dict];
            self.goodsAttrId = [self objectOrNilForKey:kOrderProductModelGoodsAttrId fromDictionary:dict];
            self.totalPrice = [self objectOrNilForKey:kOrderProductModelTotalPrice fromDictionary:dict];
            self.goodsPrice = [self objectOrNilForKey:kOrderProductModelGoodsPrice fromDictionary:dict];
            self.goodsAttr = [self objectOrNilForKey:kOrderProductModelGoodsAttr fromDictionary:dict];
            self.goodsName = [self objectOrNilForKey:kOrderProductModelGoodsName fromDictionary:dict];
            self.goodsId = [self objectOrNilForKey:kOrderProductModelGoodsId fromDictionary:dict];
            self.goodsImg = [self objectOrNilForKey:kOrderProductModelGoodsImg fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.goodsNumber forKey:kOrderProductModelGoodsNumber];
    [mutableDict setValue:self.orderId forKey:kOrderProductModelOrderId];
    [mutableDict setValue:self.goodsAttrId forKey:kOrderProductModelGoodsAttrId];
    [mutableDict setValue:self.totalPrice forKey:kOrderProductModelTotalPrice];
    [mutableDict setValue:self.goodsPrice forKey:kOrderProductModelGoodsPrice];
    [mutableDict setValue:self.goodsAttr forKey:kOrderProductModelGoodsAttr];
    [mutableDict setValue:self.goodsName forKey:kOrderProductModelGoodsName];
    [mutableDict setValue:self.goodsId forKey:kOrderProductModelGoodsId];
    [mutableDict setValue:self.goodsImg forKey:kOrderProductModelGoodsImg];

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

    self.goodsNumber = [aDecoder decodeObjectForKey:kOrderProductModelGoodsNumber];
    self.orderId = [aDecoder decodeObjectForKey:kOrderProductModelOrderId];
    self.goodsAttrId = [aDecoder decodeObjectForKey:kOrderProductModelGoodsAttrId];
    self.totalPrice = [aDecoder decodeObjectForKey:kOrderProductModelTotalPrice];
    self.goodsPrice = [aDecoder decodeObjectForKey:kOrderProductModelGoodsPrice];
    self.goodsAttr = [aDecoder decodeObjectForKey:kOrderProductModelGoodsAttr];
    self.goodsName = [aDecoder decodeObjectForKey:kOrderProductModelGoodsName];
    self.goodsId = [aDecoder decodeObjectForKey:kOrderProductModelGoodsId];
    self.goodsImg = [aDecoder decodeObjectForKey:kOrderProductModelGoodsImg];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_goodsNumber forKey:kOrderProductModelGoodsNumber];
    [aCoder encodeObject:_orderId forKey:kOrderProductModelOrderId];
    [aCoder encodeObject:_goodsAttrId forKey:kOrderProductModelGoodsAttrId];
    [aCoder encodeObject:_totalPrice forKey:kOrderProductModelTotalPrice];
    [aCoder encodeObject:_goodsPrice forKey:kOrderProductModelGoodsPrice];
    [aCoder encodeObject:_goodsAttr forKey:kOrderProductModelGoodsAttr];
    [aCoder encodeObject:_goodsName forKey:kOrderProductModelGoodsName];
    [aCoder encodeObject:_goodsId forKey:kOrderProductModelGoodsId];
    [aCoder encodeObject:_goodsImg forKey:kOrderProductModelGoodsImg];

}

- (id)copyWithZone:(NSZone *)zone
{
    OrderProductModel *copy = [[OrderProductModel alloc] init];
    
    if (copy) {

        copy.goodsNumber = [self.goodsNumber copyWithZone:zone];
        copy.orderId = [self.orderId copyWithZone:zone];
        copy.goodsAttrId = [self.goodsAttrId copyWithZone:zone];
        copy.totalPrice = [self.totalPrice copyWithZone:zone];
        copy.goodsPrice = [self.goodsPrice copyWithZone:zone];
        copy.goodsAttr = [self.goodsAttr copyWithZone:zone];
        copy.goodsName = [self.goodsName copyWithZone:zone];
        copy.goodsId = [self.goodsId copyWithZone:zone];
        copy.goodsImg = [self.goodsImg copyWithZone:zone];

    }
    
    return copy;
}


@end
