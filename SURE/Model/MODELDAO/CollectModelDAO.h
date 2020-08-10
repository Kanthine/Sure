//
//  CollectModelDAO.h
//  SURE
//
//  Created by 王玉龙 on 16/12/13.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CollectProductModelDAO : NSObject

/*
 *  增
 */
+ (void)insertCollectProductWithModel:(CollectProductModel *)productModel;

/*
 *  删
 */
+ (void)deletaCollectProductWithModel:(CollectProductModel *)productModel;

/*
 *  删
 */
+ (void)deletaAllCollectProduct;

/*
 *   查
 */
+ (NSArray *)queryCollectProductWithModel:(CollectProductModel *)productModel;

/*
 *  改
 */
+ (void)updateCollectProductWithModel:(CollectProductModel *)productModel;


/*
 *  删出本地JSon数据
 */

+ (void)deleteLocalityJsonDataWithModel:(CollectProductModel *)productModel;


@end
