//
//  CouponModel.h
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,CouponState)
{
    CouponStateNormal = 0,
    CouponStateUsed,
    CouponStateOutTime,
};

@interface CouponModel : NSObject


@property (nonatomic, assign) CouponState couponType;

@property (nonatomic , copy) NSString *nameString;
@property (nonatomic , copy) NSString *startTimeString;
@property (nonatomic , copy) NSString *endTimeString;
@property (nonatomic , copy) NSString *maxMoneyString;
@property (nonatomic , copy) NSString *cutMoneyString;

+ (CouponModel *)parserDataWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)parserDataWithArray:(NSArray *)couponArray;



@end
