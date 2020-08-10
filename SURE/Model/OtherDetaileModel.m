//
//  OtherDetaileModel.m
//  SURE
//
//  Created by 王玉龙 on 17/1/3.
//  Copyright © 2017年 longlong. All rights reserved.
//


NSString *const kOtherDetaileModellUserName = @"nickname";
NSString *const kOtherDetaileModellUserID = @"user_id";
NSString *const kOtherDetaileModellUserHeader = @"headimg";
NSString *const kOtherDetaileModellUserSignature = @"real_name";
NSString *const kOtherDetaileModellIsOption = @"islike";//是否关注
NSString *const kOtherDetaileModellTapedCount = @"get_psure_count";//被赞数
NSString *const kOtherDetaileModellFansCount = @"plike";//粉丝数
NSString *const kOtherDetaileModellOptionCount = @"like";//关注数
NSString *const kOtherDetaileModellSureList = @"sure_list";
NSString *const kOtherDetaileModellTapSureList = @"like_sure_list";
NSString *const kOtherDetaileModellTagBrandList = @"like_brand_list";

#import "OtherDetaileModel.h"

@implementation OtherDetaileModel

+ (OtherDetaileModel *)parserOtherDetaileModelWithDict:(NSDictionary *)dict
{
    OtherDetaileModel *userDetaileModel = [[OtherDetaileModel alloc]init];
    
    
    NSDictionary *user_info = dict[@"user_info"];
    
    userDetaileModel.userName = user_info[kOtherDetaileModellUserName];
    userDetaileModel.userID = user_info[kOtherDetaileModellUserID];
    userDetaileModel.userHeader = user_info[kOtherDetaileModellUserHeader];
    userDetaileModel.userSignature = user_info[kOtherDetaileModellUserSignature];
    
    userDetaileModel.tapedCount = dict[kOtherDetaileModellTapedCount];
    userDetaileModel.fansCount = dict[kOtherDetaileModellFansCount];
    userDetaileModel.optionCount = dict[kOtherDetaileModellOptionCount];
    userDetaileModel.isOption = dict[kOtherDetaileModellIsOption];
    
    
    // SURE 列表
    NSArray *sure_list = [userDetaileModel objectOrNilForKey:kOtherDetaileModellSureList fromDictionary:dict];
    if (sure_list && sure_list.count)
    {
        userDetaileModel.sureListArray = [NSMutableArray array];
        [sure_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            SUREModel * sureModel = [SUREModel modelObjectWithDictionary:obj];
            [userDetaileModel.sureListArray addObject:sureModel];
        }];
    }
    
    
    
    //赞过的SURE 列表
    NSArray *like_sure_list = [userDetaileModel objectOrNilForKey:kOtherDetaileModellTapSureList fromDictionary:dict];
    if (like_sure_list && like_sure_list.count)
    {
        userDetaileModel.tapSureListArray = [NSMutableArray array];
        [like_sure_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             SUREModel * sureModel = [SUREModel modelObjectWithDictionary:obj];
             [userDetaileModel.tapSureListArray addObject:sureModel];
         }];
    }
    
    
    // Tag 过得品牌
    NSArray *like_brand_list = [userDetaileModel objectOrNilForKey:kOtherDetaileModellTagBrandList fromDictionary:dict];
    if (like_brand_list && like_brand_list.count)
    {
        userDetaileModel.tagBrandListArray = [NSMutableArray array];
        [like_brand_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
//             SUREModel * sureModel = [SUREModel modelObjectWithDictionary:obj];
//             [userDetaileModel.tagBrandListArray addObject:sureModel];
         }];
    }
    
    
    return userDetaileModel;
}


- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
