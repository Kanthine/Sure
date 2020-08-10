//
//  PhotosManager.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PhotosManager.h"

@implementation PhotosManager
/*
 http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
 
 PHAssetCollectionTypeAlbum///这是里对应的 PHAssetCollectionSubtype 用户自定义的相册文件也在其subtype
 PHAssetCollectionTypeSmartAlbum///对应的为系统里的相册文件
 PHAssetCollectionTypeMoment
 
 */


/**
 
 PHAsset: 代表照片库中的一个资源，跟 ALAsset 类似，通过 PHAsset 可以获取和保存资源
 PHFetchOptions: 获取资源时的参数，可以传 nil，即使用系统默认值
 PHFetchResult: 表示一系列的资源集合，也可以是相册的集合
 PHAssetCollection: 表示一个相册或者一个时刻，或者是一个「智能相册（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等，如下图所示）
 PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
 PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数
 */

+ (BOOL)authorizationStateAuthorized
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (void)loadAllPhotosCompletionBlock:(void (^) (NSMutableArray <PHAsset*>*listArray))block
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
   {
       //获取所有照片
       PHFetchOptions *timeOptions = [[PHFetchOptions alloc] init];
       timeOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //时间从近到远
       PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:timeOptions];
       
       for (int i = 0; i < assetsFetchResults.count; i ++)
       {
           PHAsset *asset = assetsFetchResults[i];
           
           [resultArray addObject:asset];
       }
       
       
       dispatch_async(dispatch_get_main_queue(), ^
                      {
                          block(resultArray);
                      });
       
   });

}

+ (void)loadPhotoAlbumCompletionBlock:(void (^) (NSMutableArray <PHAssetCollection*>*listArray))block
{
    NSMutableArray *resultArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        
        
        
        
        //1，PHAssetCollectionTypeSmartAlbum
        PHFetchResult *albumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        
        // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
        for (NSInteger i = 0; i < albumsFetchResult.count; i++)
        {
            // 获取一个相册（PHAssetCollection）
            PHCollection *collection = albumsFetchResult[i];
            
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                
                if ([assetCollection.localizedTitle isEqualToString:@"Videos"])
                {//过滤掉视频
                    continue;
                }

                //只加载图片
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
                
                if (fetchResult.count > 0)
                {
                    [resultArray addObject:assetCollection];
                }
            }
        }
        
        
        //2，PHAssetCollectionTypeAlbum
        PHFetchResult *ownAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        // 这时 smartAlbums 中保存的应该是各个智能相册对应的 PHAssetCollection
        for (NSInteger i = 0; i < ownAlbumsFetchResult.count; i++) {
            // 获取一个相册（PHAssetCollection）
            PHCollection *collection = ownAlbumsFetchResult[i];
            
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                
                if ([assetCollection.localizedTitle isEqualToString:@"Videos"]) {//过滤掉视频
                    continue;
                }
                //只加载图片
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
                
                if (fetchResult.count > 0)
                {
                    [resultArray addObject:assetCollection];
                }
            }
        }

        
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           block(resultArray);
                       });
    });
    
    
}


+ (void)fetchLatestAssetCompletionBlock:(void (^) (PHAsset *asset))block;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        // 获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        PHAsset *asset = [assetsFetchResults firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(asset);
        });
    });
    

}


@end
