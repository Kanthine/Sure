//
//  BrandModel.m
//  SURE
//
//  Created by 王玉龙 on 16/10/28.
//  Copyright © 2016年 longlong. All rights reserved.
//



#import "BrandModel.h"
#import "NSString+Initials.h"

@implementation BrandListModel

+ (NSMutableArray<BrandDetaileModel *> *)parserDataWithResultArray:(NSArray *)resultArray
{
    NSMutableArray *parserListArray = [NSMutableArray array];
    
    for (NSDictionary *dict in resultArray)
    {
        BrandDetaileModel *brand = [BrandDetaileModel parserDataWithResultDictionary:dict];
        [parserListArray addObject:brand];
    }
    
    return parserListArray;
}

/*
 * 根据首字母排序
 *
 * 排序后得到一个数组 包含字典
 * NSDictionary ：
 * key Initials   首字母
 * key brandList  模型数组
 */
+ (NSMutableArray<NSDictionary *> *)bassInitialsSortWithArray:(NSMutableArray<BrandDetaileModel *> * )listArray
{
    NSMutableArray *muArray = [NSMutableArray array];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"brandNameStr" ascending:YES];
    [listArray sortUsingDescriptors:@[sortDescriptor]];
    
    
    NSMutableArray *initialsArray = [NSMutableArray array];
    
    

    [listArray enumerateObjectsUsingBlock:^(BrandDetaileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([initialsArray containsObject:obj.brandInitials] == NO)
         {
             [initialsArray addObject:obj.brandInitials];
         }
         
         
    }];
    
    [initialsArray enumerateObjectsUsingBlock:^(id  _Nonnull string, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSMutableArray *mutaArr = [NSMutableArray array];
         
         
         [listArray enumerateObjectsUsingBlock:^(BrandDetaileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
          {
              if ([string isEqualToString:obj.brandInitials] )
              {
                  [mutaArr addObject:obj];
              }
          }];
         
         
         NSDictionary *dict = @{@"Initials":string,@"brandList":mutaArr};
         [muArray addObject:dict];
     }];
    
    
    NSSortDescriptor *sortInitialsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Initials" ascending:YES];
    [muArray sortUsingDescriptors:@[sortInitialsDescriptor]];
    

    
    
    
    return muArray;
}

@end


@implementation BrandDetaileModel

+ (BrandDetaileModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary
{
    
    
    BrandDetaileModel *brand = [[BrandDetaileModel alloc]init];
    
    NSDictionary *streeetDict = [dictionary objectForKey:@"street_info"];
    if (streeetDict != nil)
    {
        NSString *listLogo = [streeetDict objectForKey:@"logo"] ;
        listLogo = [NSString stringWithFormat:@"%@%@",ImageUrl,listLogo];
        
        brand.listLogoUrlStr = listLogo;
        brand.listNameStr = [streeetDict objectForKey:@"supplier_name"] ;
    }
    
    NSArray *flashArray = [dictionary objectForKey:@"flash"];
    if ([flashArray isKindOfClass:[NSArray class] ])
    {
        brand.flashModelArray = [BrandDetaileFlashImage parserDataWithFlashArray:flashArray];
    }
    
    NSInteger brand_id = [[dictionary objectForKey:@"supplier_id"] integerValue];
    NSString *storeName = [dictionary objectForKey:@"supplier_name"];
    NSString *headerImage = [dictionary objectForKey:@"brand_img"];
    headerImage = [NSString stringWithFormat:@"%@%@",ImageUrl,headerImage];
    
    
    NSString *introduceImage = [dictionary objectForKey:@"head_img"];
    
    if (![introduceImage isKindOfClass:[NSNull class]])
    {
        introduceImage = [introduceImage stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

//    NSLog(@"dictionary ========== %@",dictionary);
    
    introduceImage = [NSString stringWithFormat:@"%@/%@",ImageUrl,introduceImage];
    
    NSString *is_like = @"0";
    if ([dictionary.allKeys containsObject:@"is_like"])
    {
        is_like = [dictionary objectForKey:@"is_like"];
    }
    else if ([dictionary.allKeys containsObject:@"islike"])
    {
        is_like = [dictionary objectForKey:@"islike"];
    }
    
    
    if ([is_like isEqualToString:@"1"])
    {
        brand.isAttention = YES;
    }
    else
    {
        brand.isAttention = NO;
    }
    
    NSString *intruString = [dictionary objectForKey:@"shop_notice"];
    
    brand.brandIntroduceString = intruString;
    brand.brandIntroduceLogoUrlString = introduceImage;
    brand.brandIDStr = [NSString stringWithFormat:@"%ld",brand_id];
    brand.brandNameStr = storeName;
    brand.brandLogoUrlStr = headerImage;
    
    brand.brandInitials = [brand.brandNameStr acquireInitials];
    
    return brand;
    
}

@end


@implementation BrandDetaileFlashImage

+ (NSMutableArray *)parserDataWithFlashArray:(NSArray *)imageArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    for (int i = 0; i < imageArray.count; i ++)
    {
        
        NSDictionary *imageDict = imageArray[i];
        
        NSString *imageUrl = [imageDict objectForKey:@"src"];
        imageUrl = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageUrl];
        BrandDetaileFlashImage *flashImage = [[BrandDetaileFlashImage alloc]init];
        flashImage.isCanLink = NO;
        flashImage.imageUrlStr = imageUrl;
        [parserArray addObject:flashImage];
        
    }
    
    return parserArray;
}



@end


