//
//  AFNetDiskCache.m
//  SURE
//
//  Created by 王玉龙 on 16/12/7.
//  Copyright © 2016年 longlong. All rights reserved.
//

//有效期十分钟
#define Cache_Expire_Time  10 * 60

#import "AFNetDiskCache.h"

#import "FilePathManager.h"


@implementation AFNetDiskCache

+ (BOOL)cacheIsExitWithURL:(NSString *)url parameters:(NSDictionary *)params
{
    NSString *path = [FilePathManager getHTTPCachePathWithURL:url params:params];

    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return isExit;
}

+ (BOOL)isExpireWithRequest:(NSString *)request parameters:(NSDictionary *)params
{
    NSString *path = [FilePathManager getHTTPCachePathWithURL:request params:params];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>Cache_Expire_Time);
}


+ (void)cacheResponseObject:(id)responseObject request:(NSString *)request parameters:(NSDictionary *)params
{
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]])
    {
        NSString *path = [FilePathManager getHTTPCachePathWithURL:request params:params];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSError *error = nil;
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]])
        {
            data = responseObject;
        }
        else
        {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil)
        {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk)
            {
                NSLog(@"缓存文件成功 %@\n", path);
            }
            else
            {
                NSLog(@"缓存文件失败 %@\n", path);
            }
        }
    }
}


//获取缓存
+ (id)cahceResponseWithURL:(NSString *)url parameters:(NSDictionary *)params
{
    id cacheData = nil;
    
    if (url)
    {
        NSString *path = [FilePathManager getHTTPCachePathWithURL:url params:params];
        
        NSLog(@"缓存路径 ========= %@",path);
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data)
        {
            cacheData = data;
        }
    }
    
    if (cacheData == nil)
    {
        return nil;
    }
    
    NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableLeaves error:nil];
    
    
    return originalDict;
}

+ (NSUInteger)getDiskNetCacheSize
{
    NSUInteger size = 0;
    
    NSString *fileFinderPath = [FilePathManager createHttpCacheFolderIfNotExist];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:fileFinderPath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [fileFinderPath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (void)clearDiskNetCacheSize
{
    NSString *fileFinderPath = [FilePathManager createHttpCacheFolderIfNotExist];
    
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:fileFinderPath];
    
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [fileFinderPath stringByAppendingPathComponent:fileName];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}



@end
