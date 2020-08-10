//
//  PhotosManager.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotosManager : NSObject

/**
 判断是否授权，yes授权成功，no没有授权
 */
+ (BOOL)authorizationStateAuthorized;

/*
 *加载图库所有照片
 */
+ (void)loadAllPhotosCompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block;

/*
 *获取最近一张照片
 */
+ (void)fetchLatestAssetCompletionBlock:(void (^) (PHAsset *asset))block;


/*
 *加载图库的相册夹
 */
+ (void)loadPhotoAlbumCompletionBlock:(void (^) (NSMutableArray <PHAssetCollection*>*listArray))block;

@end
