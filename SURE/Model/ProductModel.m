//
//  ProductModel.m
//  SURE
//
//  Created by 王玉龙 on 16/10/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ProductModel.h"
#import "BrandModel.h"

@implementation ProdutList

+ (NSMutableArray *)parserDataWithResultArray:(NSArray *)resultArray
{
    NSMutableArray *parserListArray = [NSMutableArray array];
    
    for (NSDictionary *dict in resultArray)
    {
        ProductModel *product = [ProductModel parserDataWithResultDictionary:dict];
        [parserListArray addObject:product];
    }
    
    return parserListArray;
}

@end


@implementation ProductModel

+ (ProductModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary
{
    ProductModel *product = [[ProductModel alloc]init];
    
    NSInteger goods_id = [[dictionary objectForKey:@"goods_id"] integerValue];
    NSString *goods_name = [dictionary objectForKey:@"goods_name"];
    
    NSString *goods_img = [dictionary objectForKey:@"goods_img"];
    goods_img = [NSString stringWithFormat:@"%@/%@",ImageUrl,goods_img];
    
    NSString *original_img = [dictionary objectForKey:@"original_img"];
    original_img = [NSString stringWithFormat:@"%@/%@",ImageUrl,original_img];

    
    NSString *goods_thumb = [dictionary objectForKey:@"goods_thumb"];
    goods_thumb = [NSString stringWithFormat:@"%@/%@",ImageUrl,goods_thumb];
    
    float price = [[dictionary objectForKey:@"shop_price"] floatValue];
    float marketPrice =  [[dictionary objectForKey:@"market_price"] floatValue];
    product.productIDStr = [NSString stringWithFormat:@"%ld",goods_id];
    product.productNameStr = goods_name;
    product.productLogoUrlStr = goods_img;
    product.goods_thumbString = goods_thumb;
    product.original_img = original_img;
    product.productPriceStr = [NSString stringWithFormat:@"%.2f",price];
    product.marketPriceStr = [NSString stringWithFormat:@"%.2f",marketPrice];
    product.productDetaileHTMLStr = [dictionary objectForKey:@"goods_desc"];
    
    
    NSString *isCollected = [dictionary objectForKey:@"is_like"];
    
    if ([isCollected isEqualToString:@"1"])
    {
        product.isCollected = YES;
    }
    else
    {
         product.isCollected = NO;
    }
    
    
    
    NSArray *array = (NSArray *)[dictionary objectForKey:@"img_list"];
    if (array.count )
    {
        product.flashModelArray = [ProductDetaileFlashImage parserDataWithFlashArray:array];
    }
    
    
    NSArray *attributeModelArray = (NSArray *)[dictionary objectForKey:@"goods_attr"];
    NSArray *productModelArray = (NSArray *)[dictionary objectForKey:@"products_info"];
    if (productModelArray.count )
    {
        product.attributeModelArray = [ProductAttributeModel parserDataWithAttributeArray:attributeModelArray ProductArray:productModelArray];
        product.associationArray = [ProductAssociationModel parserDataWithProductArray:productModelArray];
    }
    
    
    NSDictionary *storeDict = [dictionary objectForKey:@"supplierinfo"];
    if (storeDict)
    {
        
        NSString *headerImage = [storeDict objectForKey:@"brand_img"];
        headerImage = [NSString stringWithFormat:@"%@%@",ImageUrl,headerImage];
        
        
        
        product.brandIDStr = [storeDict objectForKey:@"supplier_id"];
        product.brandNameStr = [storeDict objectForKey:@"bank_name"];
        product.brandLogoStr = headerImage;
        
        
        
        product.brandModel = [BrandDetaileModel parserDataWithResultDictionary:storeDict];
    }
    
    return product;
}


@end

@implementation ProductDetaileFlashImage

+ (NSMutableArray *)parserDataWithFlashArray:(NSArray *)imageArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    for (int i = 0; i < imageArray.count; i ++)
    {
        
        NSDictionary *imageDict = imageArray[i];
        
        NSString *imageUrl = [imageDict objectForKey:@"img_original"];
        imageUrl = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageUrl];
        ProductDetaileFlashImage *flashImage = [[ProductDetaileFlashImage alloc]init];
        flashImage.isCanLink = NO;
        flashImage.imageUrlStr = imageUrl;
        [parserArray addObject:flashImage];
        
    }
    
    return parserArray;
}

/*
 {
 "goods_attr_id" = 0;
 "goods_id" = 293;
 "img_desc" = "";
 "img_id" = 582;
 "img_original" = "images/201611/source_img/293_P_1478240443888.jpg";
 "img_sort" = 0;
 "img_url" = "images/201611/goods_img/293_P_1478240443959.jpg";
 "is_attr_image" = 0;
 "thumb_url" = "images/201611
 */


@end





@implementation ProductAttributeModel

+ (NSMutableArray *)parserDataWithAttributeArray:(NSArray *)attributeArray ProductArray:(NSArray *)productArray
{
    
    NSMutableArray *sizeArray = [NSMutableArray array];
    NSMutableArray *colorArray = [NSMutableArray array];
    
    //attr_id" : "15" 颜色
    //attr_id" : "16" 尺寸
    
    
    for (int i = 0; i < attributeArray.count; i ++)
    {
        NSDictionary *attributeDict = attributeArray[i];
        
        NSString *attr_price = [attributeDict objectForKey:@"attr_price"];
        NSString *goods_attr_id = [attributeDict objectForKey:@"goods_attr_id"];
        NSString *attr_value = [attributeDict objectForKey:@"attr_value"];
        NSString *attr_id = [attributeDict objectForKey:@"attr_id"];
        NSString *attr_name = [attributeDict objectForKey:@"attr_name"];
        
        ProductAttributeModel *attributeModel = [[ProductAttributeModel alloc]init];
        attributeModel.attr_price = attr_price;
        attributeModel.goods_attr_id = goods_attr_id;
        attributeModel.attr_value = attr_value;
        attributeModel.attr_id = attr_id;
        attributeModel.attr_name = attr_name;
        
        

        
        
        
        /*
        5.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
        例： @"name CONTAIN[cd] 'ang'" //包含某个字符串
        @"name BEGINSWITH[c] 'sh'" //以某个字符串开头
        @"name ENDSWITH[d] 'ang'" //以某个字符串结束
        注:[c]不区分大小写 , [d]不区分发音符号即没有重音符号 , [cd]既不区分大小写，也不区分发音符号
        */
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"goods_attr CONTAINS %@", goods_attr_id]; //predicate只能是对象
        NSArray *array = [productArray filteredArrayUsingPredicate:predicate];
        
        attributeModel.associationArray = [NSMutableArray array];
        
        
        
        for(NSDictionary *dict in array)
        {
            NSString *attri = [dict objectForKey:@"goods_attr"];
            NSArray *sepArray = [attri componentsSeparatedByString:@"|"];
            for (NSString *str in sepArray)
            {
                if ([str isEqualToString:goods_attr_id] == NO)
                {
                    [attributeModel.associationArray addObject:str];
                }
            }
        }

        if ([attr_name isEqualToString:@"尺码"] || [attr_id isEqualToString:@"16"])
        {
            attributeModel.attributeType = AttributeTypeSize;
            [sizeArray addObject:attributeModel];
        }
        else
        {
            attributeModel.attributeType = AttributeTypeColor;
            [colorArray addObject:attributeModel];
        }
        
    }
    
    NSMutableArray *parserArray = [NSMutableArray array];
    // 规定 0 为颜色 1 为尺码
    
    
    if (colorArray && colorArray.count > 0)
    {
        [parserArray addObject: @{@"颜色":colorArray}];
    }
    
    if (sizeArray && sizeArray.count > 0)
    {
        [parserArray addObject: @{@"尺寸":sizeArray}];
    }
    

    return parserArray;
}


/*
 "products" : [
 {
 "product_id" : "66",
 "goods_id" : "105",
 "goods_attr" : "373|369",
 "product_sn" : "ECS000105g_p66",
 "product_number" : "100"
 },
 
goods_attr
 {
 "attr_price" : "",
 "goods_attr_id" : "369",
 "attr_value" : "S",
 "attr_id" : "16",
 "attr_name" : "尺码"
 }
 */

@end


@implementation ProductAssociationModel

+ (ProductAssociationModel *)parserDataWithDictionary:(NSDictionary *)dictionary
{
    NSString *product_id = [dictionary objectForKey:@"product_id"];
    NSString *goods_id = [dictionary objectForKey:@"goods_id"];
    NSString *goods_attr = [dictionary objectForKey:@"goods_attr"];
    NSString *product_sn = [dictionary objectForKey:@"product_sn"];
    NSString *product_number = [dictionary objectForKey:@"product_number"];
    
    
    ProductAssociationModel *attributeModel = [[ProductAssociationModel alloc]init];
    attributeModel.product_id = product_id;
    attributeModel.goods_id = goods_id;
    attributeModel.goods_attr = goods_attr;
    attributeModel.product_sn = product_sn;
    attributeModel.product_number = product_number;
    
    return attributeModel;
}

+ (NSMutableArray *)parserDataWithProductArray:(NSArray *)productArray
{
    NSMutableArray *parserArray = [NSMutableArray array];
    
    
    for (int i = 0; i < productArray.count; i ++)
    {
        NSDictionary *attributeDict = productArray[i];
        
        ProductAssociationModel *attributeModel = [ProductAssociationModel parserDataWithDictionary:attributeDict];

        [parserArray addObject:attributeModel];
    }
    
    return parserArray;
}



@end
