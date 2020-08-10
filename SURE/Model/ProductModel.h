//
//  ProductModel.h
//  SURE
//
//  Created by 王玉龙 on 16/10/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrandDetaileModel;

@interface ProdutList : NSObject

+ (NSMutableArray *)parserDataWithResultArray:(NSArray *)resultArray;

@end

@interface ProductModel : NSObject

@property (nonatomic ,copy) NSString *productNameStr;
@property (nonatomic ,copy) NSString *productLogoUrlStr;
@property (nonatomic ,copy) NSString *goods_thumbString;
@property (nonatomic ,copy) NSString *original_img;
@property (nonatomic ,copy) NSString *productIDStr;
@property (nonatomic ,copy) NSString *productPriceStr;//现在价格 优惠价
@property (nonatomic ,copy) NSString *marketPriceStr;//高价

@property (nonatomic ,copy) NSString *productDetaileHTMLStr;

@property (nonatomic ,assign) BOOL isCollected;


@property (nonatomic ,copy) NSString *brandIDStr;
@property (nonatomic ,copy) NSString *brandLogoStr;
@property (nonatomic ,copy) NSString *brandNameStr;


@property (nonatomic ,strong) NSMutableArray *flashModelArray;

//商品属性 数组
@property (nonatomic ,strong) NSMutableArray *associationArray;//负责关联
@property (nonatomic ,strong) NSMutableArray *attributeModelArray;//负责展示

@property (nonatomic ,strong) BrandDetaileModel *brandModel;


+ (ProductModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary;

@end


@interface ProductDetaileFlashImage : NSObject

@property (nonatomic ,assign) BOOL isCanLink;
@property (nonatomic ,copy) NSString *imageUrlStr;
@property (nonatomic ,copy) NSString *imageLinkStr;


+ (NSMutableArray *)parserDataWithFlashArray:(NSArray *)imageArray;

@end



typedef enum : NSUInteger
{
    AttributeTypeSize,
    AttributeTypeColor,
} AttributeType;

@interface ProductAttributeModel : NSObject

@property (nonatomic ,assign) AttributeType attributeType;

@property (nonatomic ,assign) BOOL isCanLink;
@property (nonatomic ,copy) NSString *attr_price;
@property (nonatomic ,copy) NSString *goods_attr_id;
@property (nonatomic ,copy) NSString *attr_value;
@property (nonatomic ,copy) NSString *attr_id;
@property (nonatomic ,copy) NSString *attr_name;



@property (nonatomic ,strong) NSMutableArray *associationArray;

+ (NSMutableArray *)parserDataWithAttributeArray:(NSArray *)attributeArray ProductArray:(NSArray *)productArray;


@end


@interface ProductAssociationModel : NSObject


//@property (nonatomic ,copy) NSString *selectedCountString;

@property (nonatomic ,copy) NSString *product_id;
@property (nonatomic ,copy) NSString *goods_id;
@property (nonatomic ,copy) NSString *goods_attr;
@property (nonatomic ,copy) NSString *product_sn;
@property (nonatomic ,copy) NSString *product_number;

+ (ProductAssociationModel *)parserDataWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)parserDataWithProductArray:(NSArray *)productArray;


@end

