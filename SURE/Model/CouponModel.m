//
//  CouponModel.m
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "CouponModel.h"
@implementation CouponModel

+ (CouponModel *)parserDataWithDictionary:(NSDictionary *)dictionary
{
    CouponModel *couponModel = [[CouponModel alloc]init];
    

    NSString *nameString = [dictionary objectForKey:@"bonus_name"];
    NSString *startTimeString = [dictionary objectForKey:@"use_start_date"];
    NSString *endTimeString = [dictionary objectForKey:@"use_end_date"];
    NSString *maxMoneyString = [dictionary objectForKey:@"min_goods_amount"];
    NSString *cutMoneyString = [dictionary objectForKey:@"bonus_money"];
    
    startTimeString = [CouponModel timeStampSwitchTime:startTimeString];
    endTimeString = [CouponModel timeStampSwitchTime:endTimeString];

    couponModel.nameString = nameString;
    couponModel.startTimeString = startTimeString;
    couponModel.endTimeString = endTimeString;
    couponModel.maxMoneyString = maxMoneyString;
    couponModel.cutMoneyString = cutMoneyString;
    
    return couponModel;
}

+ (NSString*)timeStampSwitchTime:(NSString*)timeStamp
{
    
    if ([timeStamp isKindOfClass:[NSString class]])
    {
        if (timeStamp != nil && timeStamp.length > 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY.MM.dd"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp integerValue]  + 8 *3600];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            return confromTimespStr;
        }
        else
        {
            return @"";
        }
    }
    else
    {
        return @"";
    }
    
}

/*
{
    "emailed" : "1",
    "supplier_id" : "0",
    "bonus_type_id" : "2",
    "bonus_id" : "1",
    "use_end_date" : "1472544000",
    "user_id" : "1",
    "order_id" : "192",
    "bonus_name" : "用户红包10元",
    "min_goods_amount" : "80.00",
    "used_time" : "1471348492",
    "bonus_money" : "10.00",
    "use_start_date" : "1437552000",
    "bonus_sn" : "0"
    */

+ (NSMutableArray *)parserDataWithArray:(NSArray *)couponArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    [couponArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        CouponModel *attributeModel = [CouponModel parserDataWithDictionary:obj];
        
        [parserArray addObject:attributeModel];
    }];
    
    return parserArray;
}


@end
