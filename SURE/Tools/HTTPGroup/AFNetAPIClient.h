//
//  AFNetAPIClient.h
//  SURE
//
//  Created by 王玉龙 on 16/12/6.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFNetDiskCache.h"


@interface AFNetAPIClient : AFHTTPSessionManager

/*
 * 创建一个单例类
 */
+(AFNetAPIClient*)sharedClient;

/*
 * get 请求
 * url 请求地址
 * parameters 请求参数 为nil
 * 
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForGetUrl:(NSString*)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completion;


/*
 * post 请求
 * url 请求地址
 * parameters 请求参数 为nil
 *
 * cacheType 缓存类型
 *
 * isCacheData 返回的数据是否是本地缓存数据
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForPostUrl:(NSString*)url parameters:(NSDictionary *)parameters CacheType:(AFNetDiskCacheType)cacheType completion:(void (^)(BOOL isCacheData,id responseObject,NSError *error))completion;




@end
