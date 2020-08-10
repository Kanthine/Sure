//
//  CollectModel.m
//  SURE
//
//  Created by 王玉龙 on 16/12/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CollectModel.h"
#import "TimeStamp.h"

//收藏单品
@implementation CollectProductModel

+ (NSMutableArray *)parserDataWithArray:(NSArray *)array
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    
    NSMutableArray *oldArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         CollectProductModel *model = [CollectProductModel modelObjectWithDictionary:obj];
         [oldArray addObject:model];
     }];
    
    
    
    for (int i = 0; i < 12; i++)
    {
        NSString *keyStr = [NSString stringWithFormat:@"%d",i];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"compareMonth LIKE %@",keyStr];
        
        NSArray *array = [oldArray filteredArrayUsingPredicate:predicate];
        
        
        if (array && array.count)
        {
            NSMutableArray *resArr = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 [resArr addObject:obj];
            }];
            [parserArray addObject:resArr];
        }
        else
        {
            break;
        }

    }
    
    
    
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
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *goodsDict = [dict objectForKey:@"goods_info"];
        
        
        self.productName = [self objectOrNilForKey:@"goods_name" fromDictionary:goodsDict];
        self.productID = [self objectOrNilForKey:@"goods_id" fromDictionary:goodsDict];
        self.productPrice = [self objectOrNilForKey:@"shop_price" fromDictionary:goodsDict];
        self.imageStr = [NSString stringWithFormat:@"%@/%@",ImageUrl,[self objectOrNilForKey:@"goods_img" fromDictionary:goodsDict]];
        
        self.collectTime = [TimeStamp timeStampSwitchTime:[self objectOrNilForKey:@"updatetime" fromDictionary:dict]];

        
        self.compareMonth = [NSString stringWithFormat:@"%ld",[self separateWithTheTime:self.collectTime]];
        
        NSLog(@"collectTime ===== %@",dict);

    }
    
    return self;
    
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (NSDate *)getDateWithTime:(NSString *)time
{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    return [df dateFromString:time];
    
}

-(NSInteger)separateWithTheTime:(NSString *)theTime
{
    NSDate *currentDate = [NSDate date];
    
    NSDate *specifiedDate =[self getDateWithTime:theTime];
    
    //日历
    NSCalendar*calendar = [NSCalendar currentCalendar];
    
    //计算两个月份的差值
    NSDateComponents*cmps= [calendar components:NSCalendarUnitMonth fromDate:specifiedDate toDate:currentDate options:NSCalendarMatchStrictly];
    
    NSLog(@"月份差值 ------- %ld",(long)cmps.month);
    
    
    return cmps.month;

    
}

@end


//收藏品牌
@implementation CollectBrandModel

+ (NSMutableArray *)parserDataWithArray:(NSArray *)array
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         CollectBrandModel *model = [CollectBrandModel modelObjectWithDictionary:obj];
         [parserArray addObject:model];
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
    if(self && [dict isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *shopDict = [dict objectForKey:@"shop_info"];
        
        
        self.brandName = [self objectOrNilForKey:@"supplier_name" fromDictionary:shopDict];
        self.brandID = [self objectOrNilForKey:@"supplier_id" fromDictionary:shopDict];
        self.imageStr = [NSString stringWithFormat:@"%@/%@",ImageUrl,[self objectOrNilForKey:@"brand_img" fromDictionary:dict]];
        
        self.collectTime = [TimeStamp timeStampSwitchTime:[self objectOrNilForKey:@"updatetime" fromDictionary:dict]];
        
        
        NSLog(@"collectTime ===== %@",dict);
        
    }
    
    return self;
    
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
