//
//  PostSureTool.m
//  SURE
//
//  Created by 王玉龙 on 16/12/26.
//  Copyright © 2016年 longlong. All rights reserved.
//

NSString *const KeyPostSureJsonImageURL = @"images";
NSString *const KeyPostSureJsonBrandTag = @"tagArray";
NSString *const KeyPostSureJsonLableName = @"lablename";
NSString *const KeyPostSureJsonGoodsID = @"goodsid";
NSString *const KeyPostSureJsonBrandID = @"brandId";
NSString *const KeyPostSureJsonYcoordinate = @"lng";// Y坐标
NSString *const KeyPostSureJsonXcoordinate= @"lat";//  X坐标


#import "PostSureTool.h"

#import "SurePhotoModel.h"
#import "UploadImageTool.h"

@implementation PostSureTool


+ (void)creatJsonWithImageModelArray:(NSArray<SurePhotoModel *> *)imageModelArray CompletionBlock:(void (^) (NSString *jsonString,NSArray *brandArray))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        /* 拿到图片数组 */
        NSMutableArray *imageArray = [self getImageArrayWithImageModelArray:imageModelArray];
        
        /* 拿到七牛云图片地址 */
        [self getQNImageLinkAddressWithImageArray:imageArray CompletionBlock:^(NSArray *imageArray)
        {
            /* 转为Json数据 */
            NSDictionary *jsonDict = [self creatSureJsonDataWithImageModelArray:imageModelArray ImageArray:imageArray];
            NSString *jsonString = jsonDict[@"jsonString"];
            NSArray *brandArray = jsonDict[@"brandArray"];

            dispatch_async(dispatch_get_main_queue(), ^
            {
                block(jsonString,brandArray);
            });
        }];
    });
}



/*
 * 返回的数组，包含两种类型：
 *UIImage ： 此为上传的图片
 *NSString： 此为上传的视频地址
 */
+ (NSMutableArray *)getImageArrayWithImageModelArray:(NSArray<SurePhotoModel *> *)imageModelArray
{
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageModelArray enumerateObjectsUsingBlock:^(SurePhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.modelType == SureModelTypePhoto)
         {
             if (obj.filerImage)
             {
                 [imageArray addObject:obj.filerImage];
             }
             else
             {
                 [imageArray addObject:obj.originalImage];
             }
         }
         else
         {
             [imageArray addObject:[obj.albumURL path]];
         }
         
     }];
    
    return imageArray;
}

+ (void)getQNImageLinkAddressWithImageArray:(NSArray *)imageArray CompletionBlock:(void (^) (NSArray *imageArray))block
{
    [UploadImageTool upLoadImages:imageArray ProgressBlock:^(float progress)
     {
         NSLog(@"progress ===== %f",progress);
     } CompletionBlock:^(NSArray *urlArray, NSError *error)
     {
         //得到图片地址 数组
         block(urlArray);
     }];
}

+ (NSDictionary *)creatSureJsonDataWithImageModelArray:(NSArray<SurePhotoModel *> *)imageModelArray ImageArray:(NSArray *)imageArray
{
    // 图片数组
    NSMutableArray *imageListArray = [NSMutableArray array];
    
    //品牌ID数组
    NSMutableArray *brandIDArray = [NSMutableArray array];
    
    
    
    [imageModelArray enumerateObjectsUsingBlock:^(SurePhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        SurePhotoModel *imageModel = obj;
         
         NSMutableArray *tagArray = [NSMutableArray array];
         
         if (imageModel.brandTagArray && imageModel.brandTagArray.count)
         {
             //带有品牌标签
             [imageModel.brandTagArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  NSString *xCoordinate = [obj objectForKey:ImageWidthRateKey];
                  NSString *yCoordinate = [obj objectForKey:ImageHeightRateKey];
                  NSString *title = [obj objectForKey:ImageBrandTitle];
                  NSString *goodID = [obj objectForKey:ImageGoodID];
                  NSString *brandID = [obj objectForKey:ImageBrandID];

                  if ([brandIDArray containsObject:brandID] == NO)
                  {
                      [brandIDArray addObject:brandID];
                  }
                  
                  
                  
                  NSMutableDictionary *tagDict = [NSMutableDictionary dictionary];
                  [tagDict setObject:title forKey:KeyPostSureJsonLableName];
                  [tagDict setObject:goodID forKey:KeyPostSureJsonGoodsID];
                  [tagDict setObject:brandID forKey:KeyPostSureJsonBrandID];
                  [tagDict setObject:xCoordinate forKey:KeyPostSureJsonXcoordinate];
                  [tagDict setObject:yCoordinate forKey:KeyPostSureJsonYcoordinate];
                  [tagArray addObject:tagDict];
              }];
             
         }

         
         
         if (imageArray[idx])
         {
             // 图片 带有标签属性
             NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
             [imageDict setObject:imageArray[idx] forKey:KeyPostSureJsonImageURL];
             [imageDict setObject:tagArray forKey:KeyPostSureJsonBrandTag];
             [imageListArray addObject:imageDict];
         }
    }];
    
    
    
    /* 最外层字典 */
//    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:imageListArray forKey:@"imglist"];
//    [jsonDict setObject:account.userId forKey:@"user_id"];

    
    NSLog(@"jsonDict ========  %@",jsonDict);

    
    
    BOOL isYes = [NSJSONSerialization isValidJSONObject:jsonDict];
    
    if (isYes)
    {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:NULL];
        
        
        NSString *jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString ========= %@",jsonString);
        
        
        return @{@"jsonString":jsonString,@"brandArray":brandIDArray};
        
    }
    else
    {
        NSLog(@"JSON数据生成失败，请检查数据格式");
        return @{@"jsonString":@"",@"brandArray":brandIDArray};
    }
}


@end
