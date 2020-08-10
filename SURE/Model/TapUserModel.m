//
//  TapUserModel.m
//  SURE
//
//  Created by 王玉龙 on 17/1/2.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "TapUserModel.h"

@implementation TapUserModel

+ (NSMutableArray *)parserTapUserListWithArray:(NSArray *)array
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        TapUserModel *modle = [TapUserModel parserTapUserModelWithDict:obj];
        [parserArray addObject:modle];
    }];
    
    
    return parserArray;
}


+ (TapUserModel *)parserTapUserModelWithDict:(NSDictionary *)dict
{
    TapUserModel *model = [[TapUserModel alloc]init];
    
    NSString *userName = dict[@"user_name"];
    NSString *userHeader = dict[@"headimg"];
    NSString *userID = dict[@"user_id"];
    NSString *isOptioned = dict[@"follow_status"];
    
    model.userName = userName;
    model.userHeader = userHeader;
    model.userID = userID;
    model.isOptioned = isOptioned;
    
    
    return model;
}

@end
