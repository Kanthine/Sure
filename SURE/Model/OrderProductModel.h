//
//  OrderProductModel.h
//
//  Created by   on 16/11/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface OrderProductModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *goodsNumber;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *goodsAttrId;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *goodsPrice;
@property (nonatomic, strong) NSString *goodsAttr;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) NSString *goodsImg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;




@end
