//
//  ShoppingCarModel.m
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

+ (ShoppingCarModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary
{
    
    id result = [dictionary objectForKey:@"result"];
    

    ShoppingCarModel *carModel = [[ShoppingCarModel alloc]init];
    carModel.brandListArray = [NSMutableArray array];
    
    
    NSArray *nameArray = @[@"京东",@"天猫旗舰店",@"美团外卖"];
    nameArray = @[@"SURE 自营"];
    NSArray *imageArray = @[@"app.png",
                            @"http://img5q.duitang.com/uploads/item/201408/07/20140807180405_T3JuH.thumb.224_0.png",
                            @"http://v1.qzone.cc/avatar/201407/07/21/42/53baa3ad3ece5453.jpg%21200x200.jpg"];
    for (int i = 0; i < nameArray.count; i ++)
    {
        
        BrandInfoModel *brand;
        if ([result isKindOfClass:[NSDictionary class]])
        {
            brand = [BrandInfoModel parserDataWithResultDictionary:result];
        }
        else if ([result isKindOfClass:[NSArray class]])
        {
            brand = [BrandInfoModel parserDataWithResultArray:result];
        }
        brand.brandNameString = nameArray[i];
        brand.brandImageString = imageArray[i];
                
        [carModel.brandListArray addObject:brand];
    }
    
        
    
    return carModel;
}

- (ShoppingCarModel *)getSelectedCarModel
{
    ShoppingCarModel *carModel = [[ShoppingCarModel alloc]init];
    carModel.brandListArray = [NSMutableArray array];
    
    
    
    for (BrandInfoModel *brand in self.brandListArray)
    {
        BrandInfoModel *newBrand = [[BrandInfoModel alloc]init];
        newBrand.isBrandSelected = brand.isBrandSelected;
        newBrand.isEditingStatus = brand.isEditingStatus;
        newBrand.brandNameString = brand.brandNameString;
        newBrand.brandIDString = brand.brandIDString;
        newBrand.brandImageString = brand.brandImageString;
        newBrand.commodityListArray = [NSMutableArray array];;
        
        if (brand.isBrandSelected)
        {
            newBrand.commodityListArray = brand.commodityListArray;
        }
        else
        {
            for (CommodityInfoModel *product in brand.commodityListArray)
            {
                if (product.isCommoditySelected)
                {
                    [newBrand.commodityListArray addObject:product];
                }
            }
            
        }
        
        
        if (newBrand.commodityListArray.count)
        {
            [carModel.brandListArray addObject:newBrand];
        }
        
    }
    
    return carModel;
}

- (BOOL)isEmptyShoppingCar
{
    if (self.brandListArray == nil || self.brandListArray.count == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    

}

@end




@implementation BrandInfoModel

+ (BrandInfoModel *)parserDataWithResultArray:(NSDictionary *)array
{
    BrandInfoModel *brandModel = [[BrandInfoModel alloc]init];
    
    brandModel.isBrandSelected = NO;
    brandModel.isEditingStatus = NO;
    brandModel.commodityListArray = [NSMutableArray array];
    
    for (NSDictionary  *dict in array)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            CommodityInfoModel *info = [CommodityInfoModel parserDataWithResultDictionary:dict];
            [brandModel.commodityListArray addObject:info];
        }
    }
    
    return brandModel;
}

+ (BrandInfoModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary
{
    BrandInfoModel *brandModel = [[BrandInfoModel alloc]init];
    
    brandModel.isBrandSelected = NO;
    brandModel.isEditingStatus = NO;
    
    brandModel.commodityListArray = [NSMutableArray array];
    
    
    NSArray *array = dictionary.allKeys;
    for (NSString  *keyString in array)
    {
        id dict = [dictionary objectForKey:keyString];
        
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            dict = (NSDictionary *)dict;
            
            CommodityInfoModel *info = [CommodityInfoModel parserDataWithResultDictionary:dict];
            
            [brandModel.commodityListArray addObject:info];
            
            NSLog(@"keyString ======= %@",keyString);

        }
        
    }

    return brandModel;
}

@end










@implementation CommodityInfoModel

+ (CommodityInfoModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary
{
    CommodityInfoModel *infoModel = [[CommodityInfoModel alloc]init];
    
    
    NSInteger count = [[dictionary objectForKey:@"goods_number"] integerValue];
    NSString *nameString = [dictionary objectForKey:@"goods_name"];
    NSString *goodIDString = [dictionary objectForKey:@"goods_id"];
    NSString *oldPriceString = [dictionary objectForKey:@"goods_price"];
    NSString *imageString = [dictionary objectForKey:@"goods_img"];
    imageString = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageString];
    NSString *carIDString = [dictionary objectForKey:@"rec_id"];
    
    
    infoModel.isCommoditySelected = NO;
    infoModel.count = count;
    infoModel.nameString = nameString;
    infoModel.goodIDString = goodIDString;
    infoModel.oldPriceString = oldPriceString;
    infoModel.imageString = imageString;
    infoModel.carIDString = carIDString;
    
    
    id goods_attr_Obj = [dictionary objectForKey:@"goods_attr"];
    id products_info_Obj = [dictionary objectForKey:@"products_info"];
    
    if ([goods_attr_Obj isKindOfClass:[NSArray class]] && [products_info_Obj isKindOfClass:[NSArray class]] )
    {
        NSArray *attributeModelArray = (NSArray *) goods_attr_Obj;
        NSArray *productModelArray = (NSArray *)products_info_Obj;
        if (attributeModelArray.count)
        {
            infoModel.attributeModelArray = [ProductAttributeModel parserDataWithAttributeArray:attributeModelArray ProductArray:productModelArray];
            infoModel.associationArray = [ProductAssociationModel parserDataWithProductArray:productModelArray];
        }
    }
    
    
    
    
    NSDictionary *productsDict = [dictionary objectForKey:@"products"];
    if ([productsDict isKindOfClass:[NSDictionary class]] && [goods_attr_Obj isKindOfClass:[NSArray class]])
    {
        infoModel.defaultAssociationModel = [ProductAssociationModel parserDataWithDictionary:productsDict];
        
        infoModel.attributeStrig = [infoModel getCommodityAttributeWithGoodsAttr:goods_attr_Obj];
        
    }

    

    return infoModel;
}

- (NSString *)getCommodityAttributeWithGoodsAttr:(NSArray *)goodsAttr
{
    NSArray *array = [self.defaultAssociationModel.goods_attr componentsSeparatedByString:@"|"];
    
    if (array == nil || array.count < 2)
    {
        return @"";
    }
    
    
    NSString *colorString = array[0];
    NSString *sizeString = array[1];
    
    NSPredicate *colorPredicate = [NSPredicate predicateWithFormat:@"goods_attr_id LIKE %@",colorString];
    NSPredicate *sizePredicate = [NSPredicate predicateWithFormat:@"goods_attr_id LIKE %@", sizeString];
    
    NSArray *colorArray = [goodsAttr filteredArrayUsingPredicate:colorPredicate];
    
    NSArray *sizeArray = [goodsAttr filteredArrayUsingPredicate:sizePredicate];
    
    
    NSString *string = nil;
    if (colorArray && colorArray.count > 0)
    {
        NSDictionary *colorDict = colorArray[0];
        NSDictionary *sizeDict = sizeArray[0];
        
        
        
        if ([[colorDict objectForKey:@"attr_id"] isEqualToString:@"15"] == NO)
        {
            NSDictionary *dict = colorDict;
            colorDict = sizeDict;
            sizeDict = dict;
        }
     
        string = [NSString stringWithFormat:@"分类：颜色: %@ 尺码: %@",[colorDict objectForKey:@"attr_value"],[sizeDict objectForKey:@"attr_value"]];

    }
    

    

    
    
    NSLog(@"%@",string);
    
    return string;
    
    
}

@end


