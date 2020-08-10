//
//  ChooseProductSpecificationVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/30.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,EnterType)
{
    EnterTypeAddShoppingCar = 0,//添加至购物车
    EnterTypeNoBuy,//立即购买
    EnterTypeShopingCarEdit,//购物车里编辑商品信息
};


typedef void(^callBack)();


@protocol ChooseProductSpecificationVCDelegate  <NSObject>

- (void)editedAttributeInfoClick:(ProductAssociationModel *)defaultAssociationModel Attribute:(NSString *)attributeString Count:(NSInteger)count;

@end


@interface ChooseProductSpecificationVC : BaseViewController

@property (nonatomic,assign) id <ChooseProductSpecificationVCDelegate> delegate;


@property (nonatomic ,strong) ProductModel *singleProduct;
@property (nonatomic ,strong) CommodityInfoModel *commodityInfo;

@property (nonatomic ,strong) ProductAssociationModel *defaultAssociationModel;

@property (nonatomic ,copy) NSString *countString;


@property (nonatomic,copy) callBack block;

@property (nonatomic ,copy) void(^ productSpecificationAddShoppingCar)();
@property (nonatomic ,copy) void(^ productSpecificationNoBuy)();


@property (nonatomic,assign) EnterType enterType;

- (instancetype)initWithEnterType:(EnterType)enterType DefaultAssociationModel:(ProductAssociationModel *)defaultAssociationModel;

@end
