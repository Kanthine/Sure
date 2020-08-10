//
//  AFNetDiskCache.h
//  SURE
//
//  Created by 王玉龙 on 16/12/7.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AFNetDiskCacheType)
{
    AFNetDiskCacheTypeUseCacheThenLoad = 0,//有缓存就使用缓存，然后请求数据
    AFNetDiskCacheTypeUseLoadThenCache,//请求数据 缓存数据
    AFNetDiskCacheTypeIgnoringCache,// 不缓存
    AFNetDiskCacheTypeUseCacheThenUseLoad,//有缓存就使用缓存，然后请求数据在更新UI
};

@interface AFNetDiskCache : NSObject

/*
 *  判断本地是否拥有缓存数据
 */
+ (BOOL)cacheIsExitWithURL:(NSString *)url parameters:(NSDictionary *)params;

/**
 *  缓存数据
 *
 *  data 需要缓存的二进制
 */
+ (void)cacheResponseObject:(id)responseObject request:(NSString *)request parameters:(NSDictionary *)params;

/**
 *  取出缓存数据
 *
 *  @return 处理过得JSON数据
 */
+ (id)cahceResponseWithURL:(NSString *)url parameters:(NSDictionary *)params;

/**
 *  判断缓存文件是否过期
 *
 *  过期则不返回
 */
+ (BOOL)isExpireWithRequest:(NSString *)request parameters:(NSDictionary *)params;

/**
 *  获取缓存的大小
 *
 *  @return 缓存的大小  单位是B
 */
+ (NSUInteger)getDiskNetCacheSize;

/**
 *  清除缓存
 */
+ (void)clearDiskNetCacheSize;



@end
