//
//  FilePathManager.h
//  FilerVideoRecorderDemo
//
//  Created by 王玉龙 on 16/12/2.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define SURELISTVideoFile @"SURELISTVideoFile"
#define VideoFile @"VideoFile"
#define ImageFile @"ImageFile"
#define HttpCache @"HttpCache"
#define BackImageFile @"BackImageFile"

#import <Foundation/Foundation.h>

@interface FilePathManager : NSObject

/*
 * 判断文件夹是否存在 不存在则创建
 */
+ (BOOL)createVideoFolderIfNotExist;

/*
 * 获取一个视频地址
 */
+ (NSString *)getVideoSaveFilePathString;

/*
 * 获取一个合成视频的地址
 */
+ (NSString *)getVideoMergeFilePathString;

/*
 * 获取视频 文件夹地址
 */
+ (NSString *)getVideoSaveFolderPathString;

/*
 * 获取一个滤镜视频地址
 */
+ (NSString *)getFilerVideoFilePathString;




/*
 * 判断文件夹是否存在 不存在则创建
 */
+ (NSString *)createImageFolderIfNotExist;

/*
 * 获取一个视频地址
 */
+ (NSString *)getImageFilePathString;

/*
 * 判断缓存文件夹是否存在 不存在则创建
 */
+ (NSString *)createHttpCacheFolderIfNotExist;

/*
 * 获取缓存路径
 */
+ (NSString *)getHTTPCachePathWithURL:(NSString *)url params:(id)params;

/*
 * 判断SURE列表视频文件夹是否存在 不存在则创建
 */
+ (NSString *)createSureListVideoFolderIfNotExist;

/*
 * 获取缓存路径
 */
+ (NSString *)getSureListVideoPathWithURLString:(NSString *)urlString;


/*
 * 判断背景文件夹是否存在 不存在则创建
 */
+ (NSString *)createBackImageFolderIfNotExist;
/*
 * 默认背景图片
 */
+ (NSString *)getDefaultBackImagePath;

@end
