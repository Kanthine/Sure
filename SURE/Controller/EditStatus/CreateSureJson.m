//
//  CreateSureJson.m
//  SURE
//
//  Created by 王玉龙 on 16/12/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

NSString *const KeySureJsonImageLink = @"images";
NSString *const KeySureJsonLableName = @"lablename";
NSString *const KeySureJsonGoodsID = @"goodsid";
NSString *const KeySureJsonYcoordinate = @"lng";// Y坐标
NSString *const KeySureJsonXcoordinate= @"lat";//  X坐标


#import "CreateSureJson.h"
#import "EditImageModel.h"

#import "UploadImageTool.h"

@implementation CreateSureJson

+ (NSString *)creatJsonWithImageModelArray:(NSArray *)imageModelArray
{
    NSMutableArray *imageListArray = [NSMutableArray array];
    
    
    
    NSString *imageName1 = @"http://img1.imgtn.bdimg.com/it/u=1794894692,1423685501&fm=21&gp=0.jpg";

    NSMutableArray *imageArray = [NSMutableArray array];
    [imageModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        EditImageModel *imageModel = (EditImageModel *)obj;
        
        if (imageModel.isFiler)
        {
            [imageArray addObject:imageModel.filerImage];
        }
        else
        {
            [imageArray addObject:imageModel.originalImage];
        }
    }];
    
    [UploadImageTool upLoadImages:imageArray ProgressBlock:^(float progress)
    {
        NSLog(@"progress ===== %f",progress);
    } CompletionBlock:^(NSArray *urlArray, NSError *error)
     {
         //得到图片地址 数组
         
         
        NSLog(@"urlArray ===== %@",urlArray);
    }];
    
    
    [imageModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         EditImageModel *imageModel = (EditImageModel *)obj;
         
         
         if (imageModel.isFiler)
         {
             
         }
         else
         {
             
         }
         
         
         if (imageModel.isAddTag)
         {
             [imageModel.tagArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  NSString *xCoordinate = [obj objectForKey:WidthRateKey];
                  NSString *yCoordinate = [obj objectForKey:HeightRateKey];
                  NSString *title = [obj objectForKey:TagTitle];
                  
                  
                  NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
                  [imageDict setObject:title forKey:KeySureJsonLableName];
                  [imageDict setObject:@"2" forKey:KeySureJsonGoodsID];
                  [imageDict setObject:imageName1 forKey:KeySureJsonImageLink];
                  [imageDict setObject:xCoordinate forKey:KeySureJsonXcoordinate];
                  [imageDict setObject:yCoordinate forKey:KeySureJsonYcoordinate];
                  [imageListArray addObject:imageDict];
              }];
         }
         else
         {
             NSMutableDictionary *imageDict = [NSMutableDictionary dictionary];
             [imageDict setObject:@"" forKey:KeySureJsonLableName];
             [imageDict setObject:@"" forKey:KeySureJsonGoodsID];
             [imageDict setObject:imageName1 forKey:KeySureJsonImageLink];
             [imageDict setObject:@"" forKey:KeySureJsonXcoordinate];
             [imageDict setObject:@"" forKey:KeySureJsonYcoordinate];
             [imageListArray addObject:imageDict];
         }
         
         
         
     }];

    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:imageListArray forKey:@"imglist"];
    

    BOOL isYes = [NSJSONSerialization isValidJSONObject:jsonDict];
    
    if (isYes)
    {

        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:NULL];
        
        
        NSString *jsonString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString ========= %@",jsonString);
        
        return jsonString;
        
    }
    else
    {
        NSLog(@"JSON数据生成失败，请检查数据格式");
        return @"";
    }
}


@end
