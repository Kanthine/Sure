//
//  CollectModel.h
//  SURE
//
//  Created by 王玉龙 on 16/12/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectProductModel : NSObject

@property (nonatomic ,copy) NSString *productName;
@property (nonatomic ,copy) NSString *productID;
@property (nonatomic ,copy) NSString *productPrice;
@property (nonatomic ,copy) NSString *imageStr;

@property (nonatomic ,copy) NSString *compareMonth;

@property (nonatomic ,copy) NSString *collectTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

/*
 *两级数组 根据月份分开展示
 */
+ (NSMutableArray *)parserDataWithArray:(NSArray *)array;


@end


@interface CollectBrandModel : NSObject

@property (nonatomic ,copy) NSString *brandName;
@property (nonatomic ,copy) NSString *brandID;
@property (nonatomic ,copy) NSString *imageStr;

@property (nonatomic ,copy) NSString *collectTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

+ (NSMutableArray *)parserDataWithArray:(NSArray *)array;

@end
