//
//  FilePathManager.m
//  FilerVideoRecorderDemo
//
//  Created by 王玉龙 on 16/12/2.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "FilePathManager.h"

#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)
+ (NSString *)hybnetworking_md5:(NSString *)string;
@end

@implementation NSString (md5)
+ (NSString *)hybnetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

@end




@implementation FilePathManager

+ (BOOL)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    
    NSString *folderPath = [path stringByAppendingPathComponent:VideoFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VideoFile];
    

    NSString *fileName = [[path stringByAppendingPathComponent:[FilePathManager createCurrentTimeToTimestamp]] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VideoFile];
    

    NSString *timeStr = [FilePathManager createCurrentTimeToTimestamp];
    timeStr = [NSString stringWithFormat:@"smallVideo%@",timeStr];
    NSString *fileName = [[path stringByAppendingPathComponent:timeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
}

+ (NSString *)getVideoSaveFolderPathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VideoFile];
    
    return path;
}

+ (NSString *)getFilerVideoFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VideoFile];
    
    NSString *fileName = [[path stringByAppendingPathComponent:[FilePathManager createCurrentTimeToTimestamp]] stringByAppendingString:@"filerVideo.mp4"];
    
    return fileName;

}

+ (NSString *)createImageFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    
    NSString *folderPath = [path stringByAppendingPathComponent:ImageFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"创建图片文件夹失败");
            return folderPath;
        }
        return folderPath;
    }
    return folderPath;
}

+ (NSString *)getImageFilePathString
{
    NSString *path = [FilePathManager createImageFolderIfNotExist];
    NSString *dateString = [FilePathManager createCurrentTimeToTimestamp];
    
    NSString *fileName = [[path stringByAppendingPathComponent:dateString] stringByAppendingString:@"status.png"];
    
    return fileName;
}

//当前时间戳
+(NSString*)createCurrentTimeToTimestamp
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)createHttpCacheFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    
    NSString *folderPath = [path stringByAppendingPathComponent:HttpCache];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"创建缓存文件夹失败");
            return folderPath;
        }
        return folderPath;
    }
    return folderPath;
}

+ (NSString *)getHTTPCachePathWithURL:(NSString *)url params:(id)params
{
    
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || ((NSDictionary *)params).count == 0)
    {
        return url;
    }
    
    
    NSString *queries = @"";
    for (NSString *key in params)
    {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]])
        {
            continue;
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            continue;
        }
        else if ([value isKindOfClass:[NSSet class]])
        {
            continue;
        }
        else
        {
            
            
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1)
    {
        queries = [queries substringToIndex:queries.length - 1];
    }


    
    if (queries.length > 1)
    {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound)
        {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        }
        else
        {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    
    NSString *directoryPath = [FilePathManager createHttpCacheFolderIfNotExist];//沙盒文件
    NSString *absoluteURL = url.length == 0 ? queries : url;//url地址 + 参数
    NSString *key = [NSString hybnetworking_md5:absoluteURL];//地址进行MD5加密
    NSString *path = [directoryPath stringByAppendingPathComponent:key];
    
    return path;
}


/*
 * 判断SURE列表视频文件夹是否存在 不存在则创建
 */
+ (NSString *)createSureListVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    
    NSString *folderPath = [path stringByAppendingPathComponent:SURELISTVideoFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"创建图片文件夹失败");
            return folderPath;
        }
        return folderPath;
    }
    return folderPath;
}


/*
 * 获取缓存路径
 */
+ (NSString *)getSureListVideoPathWithURLString:(NSString *)urlString
{
    
    if (urlString == nil || ![urlString isKindOfClass:[NSString class]] || urlString.length == 0)
    {
        return @"";
    }
    
    NSString *directoryPath = [FilePathManager createSureListVideoFolderIfNotExist];//沙盒文件
    NSString *key = [NSString hybnetworking_md5:urlString];//地址进行MD5加密
    NSString *path = [directoryPath stringByAppendingPathComponent:key];
    path = [NSString stringWithFormat:@"%@.mp4",path];
    return path;
}

+ (NSString *)createBackImageFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    
    NSString *folderPath = [path stringByAppendingPathComponent:BackImageFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir)
        {
            NSLog(@"创建缓存文件夹失败");
            return folderPath;
        }
        return folderPath;
    }
    return folderPath;

}

+ (NSString *)getDefaultBackImagePath;
{
    NSString *path = [FilePathManager createBackImageFolderIfNotExist];
    
    NSString *fileName = [path stringByAppendingPathComponent:@"DefaultBackImage.png"];
    
    return fileName;

}

@end
