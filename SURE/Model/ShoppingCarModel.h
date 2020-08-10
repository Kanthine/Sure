//
//  ShoppingCarModel.h
//  SURE
//
//  Created by 王玉龙 on 16/10/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingCarModel : NSObject

@property (nonatomic ,copy) NSString *sumPriceString;

@property (nonatomic,strong) NSMutableArray *brandListArray;


+ (ShoppingCarModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary;


- (ShoppingCarModel *)getSelectedCarModel;


- (BOOL)isEmptyShoppingCar;//YES 有商品

@end



@interface BrandInfoModel : NSObject

// 左侧按钮是否选中
@property (nonatomic,assign) BOOL isBrandSelected;

// 下面商品是否全部编辑状态
@property (nonatomic,assign) BOOL isEditingStatus;

@property (nonatomic ,copy) NSString *brandNameString;
@property (nonatomic ,copy) NSString *brandIDString;
@property (nonatomic ,copy) NSString *brandImageString;

@property (nonatomic,strong) NSMutableArray *commodityListArray;

+ (BrandInfoModel *)parserDataWithResultArray:(NSDictionary *)array;
+ (BrandInfoModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary;

@end


@interface CommodityInfoModel : NSObject

// 商品左侧按钮是否选中
@property (nonatomic,assign) BOOL isCommoditySelected;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic ,copy) NSString *nameString;
@property (nonatomic ,copy) NSString *goodIDString;
@property (nonatomic ,copy) NSString *oldPriceString;
@property (nonatomic ,copy) NSString *attributeStrig;
@property (nonatomic ,copy) NSString *imageString;
@property (nonatomic ,copy) NSString *carIDString;

@property (nonatomic ,strong) ProductAssociationModel *defaultAssociationModel;

//商品属性 数组
@property (nonatomic ,strong) NSMutableArray *associationArray;//负责关联
@property (nonatomic ,strong) NSMutableArray *attributeModelArray;//负责展示


+ (CommodityInfoModel *)parserDataWithResultDictionary:(NSDictionary *)dictionary;

@end

