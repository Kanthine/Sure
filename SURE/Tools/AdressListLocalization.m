//
//  AdressListLocalization.m
//  SURE
//
//  Created by 王玉龙 on 16/11/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AdressListLocalization.h"

#import <AFNetworking.h>

@implementation AdressListLocalization

+ (void)getAdressList
{
    NSString *urlString = [NSString stringWithFormat:@"%@/get_region_list",DOMAIN_Public];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameterDict = @{@"cur_page":@"1",@"cur_size":@"10000"};
    
    [manager POST:urlString parameters:parameterDict progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if ([[originalDict objectForKey:@"error_flag"] integerValue] == 0)
         {
             NSArray *resultArray = [[originalDict objectForKey:@"data"] objectForKey:@"result"];
             
             
             
             [AdressListLocalization parserDataWithAddressListArray:resultArray];
         }
         else
         {
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         
     }];
    
}


+ (void)parserDataWithAddressListArray:(NSArray *)addressListArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {        
        
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"region_type LIKE %@",@"1"];
        NSArray *firstArray = [addressListArray filteredArrayUsingPredicate:firstPredicate];
        
        
        NSMutableArray *provinceArray = [NSMutableArray array];
        
        [firstArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSDictionary *firstDict = (NSDictionary *)obj;//其中一个一级省份
             
             
             NSString *parentID = [firstDict objectForKey:@"region_id"];
             NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"parent_id LIKE %@",parentID];
             NSArray *secondArray = [addressListArray filteredArrayUsingPredicate:secondPredicate];
             
             
             
             
             NSMutableArray *cityArray = [NSMutableArray array];
             
             
             [secondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  NSDictionary *secondDict = (NSDictionary *)obj; //其中一个 二级 城市
                  NSString *parentID = [secondDict objectForKey:@"region_id"];
                  NSPredicate *threePredicate = [NSPredicate predicateWithFormat:@"parent_id LIKE %@",parentID];
                  
                  
                  
                  NSArray *threeArray = [addressListArray filteredArrayUsingPredicate:threePredicate];//三级  区域 数组
                  
                  
                  
                  NSMutableDictionary *areaDict = [NSMutableDictionary dictionary];
                  [secondDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                   {
                       NSString *valueString = [secondDict objectForKey:obj];
                       [areaDict setObject:valueString forKey:obj];
                   }];
                  [areaDict setObject:threeArray forKey:@"childArray"];
                  
                  [cityArray addObject:areaDict];
                  
              }];
             
             
             
             
             NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
             [firstDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  NSString *valueString = [firstDict objectForKey:obj];
                  [cityDict setObject:valueString forKey:obj];
              }];
             [cityDict setObject:cityArray forKey:@"childArray"];
             
             
             
             
             
             [provinceArray addObject:cityDict];
             
             
             
         }];
        
        
        
        
        [provinceArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             NSDictionary *a = (NSDictionary *)obj1;
             NSDictionary *b = (NSDictionary *)obj2;
             
             int aNum = [[a objectForKey:@"region_id"] intValue];
             int bNum = [[b objectForKey:@"region_id"] intValue];
             if (aNum > bNum)
             {
                 return NSOrderedDescending;
             }
             else if (aNum < bNum)
             {
                 return NSOrderedAscending;
             }
             else {
                 return NSOrderedSame;
             }
         }];
        
        
        [AdressListLocalization saveDateWityArray:provinceArray];
    
    });
}

+ (void)saveDateWityArray:(NSMutableArray *)saveArray
{
    [saveArray writeToFile:[AdressListLocalization getCityListPath] atomically:YES];
}

+ (NSString *)getCityListPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = [path stringByAppendingPathComponent:@"CityList.plist"];
    
    NSLog(@"fileName == %@",fileName);
    
    return fileName;
}


@end
