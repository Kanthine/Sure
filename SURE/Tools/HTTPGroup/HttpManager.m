//
//  HttpManager.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "HttpManager.h"


#import "AFNetAPIClient.h"

@interface HttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic ,strong) NSURLSessionTask *brandCommodityListTask;
@property (nonatomic ,strong) NSURLSessionTask *orderListTask;


@end


@implementation HttpManager

//取消任务 减号方法 创建对象 dealloc 释放 停止请求
//加载缓存
- (void)dealloc
{
    NSLog(@"HttpManager dealloc");
    
    [_netClient.operationQueue cancelAllOperations];
    
    [self cancelAllRequest];
}

- (void)cancelAllRequest
{
    if (self.sessionTask)
    {
        NSLog(@"取消数据请求 %@ %@\n",self,self.sessionTask);
        [self.sessionTask cancel];
        self.sessionTask = nil;
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}






/*
 * 首页品牌列表 :缓存数据
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 *
 */
- (void)getBrandListDataWithParametersDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray<BrandDetaileModel *> *brandModelArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,HomePageBrandListURL];

    
    _sessionTask = [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         //currentThread 分线程
         if (error == nil )
         {
             NSArray *reseltArray = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *brandArray = [BrandListModel parserDataWithResultArray:reseltArray];
             
             dispatch_async(dispatch_get_main_queue(), ^
            {
                block (brandArray ,nil);
            });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
            {
                block (nil ,error);
            });
         }
         

    }];
}


/*
* 品牌详情页
*
* cur_page ：当前页数
* cur_size ：每页数据量
*
*/
- (void)getBrandDetaileWithParametersDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BrandDetaileModel *brandModel ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BrandDetaile];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
       {
           if (error)
           {
               dispatch_async(dispatch_get_main_queue(), ^
                              {
                                  block (nil ,error);
                              });
           }
           else
           {
               NSDictionary *resDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
               
               BrandDetaileModel *brand = [BrandDetaileModel parserDataWithResultDictionary:resDict];
               dispatch_async(dispatch_get_main_queue(), ^
                              {
                                  block(brand,nil);
                              });
           }
       }];
}


/*
 * 品牌详情页 商品列表
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 * order_by ：分类 综合（click_count）销量（buymax）价格（shop_price）新品（add_time）
 * desc     ：排序 倒序desc/正序asc*
 * supplier_id ： 品牌Id
 */
- (void)getBrandCommodityListWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray *productListArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BrandDetaileCommodityList];

    
    if (_brandCommodityListTask.state == NSURLSessionTaskStateRunning)
    {
        [_brandCommodityListTask cancel];
    }
    
    
    
    _brandCommodityListTask = [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });

        }
        else
        {
           NSArray *resultArray = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
           
           NSMutableArray *productListArray = [ProdutList parserDataWithResultArray:resultArray];
           
           dispatch_async(dispatch_get_main_queue(), ^
                          {
                              block(productListArray,nil);
                          });
        }
    }];
}


/*
 * SURE列表:品牌页面的SURE，商品详情页的who's SURE
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 * sure_id  ：sure id
 * goods_id ：商品Id
 * brand_id ：品牌Id
 * sure_type：数据类型 当前sure的人：user； 品牌的sure：brand；当前商品的sure：goods；
 */
- (void)getBrandOrCommoditySureListWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray *sureListArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BrandSureList];
            
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"sureListWithParameterDict === %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
         if (error == nil)
         {
             NSArray *resultArray =  [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArray = [NSMutableArray array];
             
             
             [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {   
                  [listArray addObject:[SUREModel modelObjectWithDictionary:obj]];
              }];
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray,error);
                            });
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         
         
         
     }];

}

#pragma mark  单品详情

- (void)getSingleProductDataWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (ProductModel *product,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,CommodityDetaileURL];
    
    NSLog(@"urlString ===== %@",urlString);

    _sessionTask = [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });
        }
        else
        {

           NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
           ProductModel *product = [ProductModel parserDataWithResultDictionary:reseltDict];
           
           dispatch_async(dispatch_get_main_queue(), ^
                          {
                              block (product ,nil);
                          });

        }
    }];
}

#pragma mark - 购物车 添加 列表 删除 修改

- (void)addProductToShoppingCarWithParameterDict:(NSMutableDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ShoppingCarAdd];
    

    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        NSLog(@"addProductToShoppingCar === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           block (error);
                       });

    }];
}

- (void)getShoppingCarListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (ShoppingCarModel *carModel ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ShoppingCarList];

    
    _sessionTask = [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });
        }
        else
        {
            
            ShoppingCarModel *carModel = [ShoppingCarModel parserDataWithResultDictionary:[responseObject objectForKey:@"data"]];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block(carModel,nil);
                           });
        }
    }];
}

- (void)deleteShoppingCarProfuctWithCarID:(NSString *)carIDString CompletionBlock:(void (^) (NSError *error))block//删除购物车商品，可多件删除
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ShoppingCarDelete];
    
    
    AccountInfo *user = [AccountInfo standardAccountInfo];
    NSString *userID = user.userId;
    NSDictionary *parameterDict = @{@"user_id":userID,@"cart_id":carIDString};
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        NSLog(@"deleteShoppingCarProfuctWithCarID === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            block(error);
        });
    }];
}

- (void)updateShoppingCarProfuctParameterDict:(NSMutableDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block//修改购物车商品信息 数量 属性
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ShoppingCarUpdate];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        NSLog(@"updateShoppingCarProfuctParameterDict === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           block(error);
                       });
    }];
}



#pragma mark - 订单

- (void)submitOrderParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,SubmitOrder];
    
    _sessionTask = [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseLoadThenCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
                    {
                        
                        
                        NSLog(@"订单信息 ===== %@",responseObject);
                        
                        
                        if (error)
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               NSDictionary *dict = [responseObject objectForKey:@"data"];
                               block(dict,nil);
                           });
                            
                        }
                    }];

}

- (void)getOrderPayInfoWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,OrderPayInfo];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseLoadThenCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        
        
        NSLog(@"订单信息 ===== %@",responseObject);
        
        
        if (error)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               NSDictionary *dict = [responseObject objectForKey:@"data"];
                               block(dict,nil);
                           });
            
        }
    }];

}

- (void)payFinishedWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,PaySuccess];
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseLoadThenCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"订单信息 ===== %@",responseObject);
         
         
         if (error)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block (nil ,error);
                            });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                NSDictionary *dict = [responseObject objectForKey:@"data"];
                                block(dict,nil);
                            });
             
         }
     }];

}
//获取订单列表
- (void)getOrderListParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",DOMAIN_Private,OrderList];
    
    /* 订单之间切换太过频繁 容易加载多个会话，需要先停止当前会话 */
    if (_orderListTask.state == NSURLSessionTaskStateRunning)
    {
        [_orderListTask cancel];
    }
    
    
    
    
    _orderListTask = [self.netClient requestForPostUrl:urlString parameters:parameterDict  CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        
        NSLog(@"订单列表=== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block (nil ,error);
                           });
        }
        else
        {
            NSArray *resultArray = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
            
            NSMutableArray *parserArray = [OrderModel parserDataWithOrderListArray:resultArray];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block(parserArray ,nil);
                           });

        }
    }];
}


#pragma mark -

/*
 * 优惠券列表
 *
 * parameterDict ：所需参数
 * user_id      ：用户ID
 * cur_page    ：页码
 * cur_size    ：每页数量
 */
- (void)getCouponListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,CouponList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
    {
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               block(nil,error);
                           });
        }
        else
        {
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
           NSMutableArray *listArray = [CouponModel parserDataWithArray:array];
           dispatch_async(dispatch_get_main_queue(), ^
                          {
                              block(listArray,nil);
                          });
           
        }
        
    }];
}

- (void)tapSupportWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block//点赞
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,TapSupport];

    /*
     user_id 点赞ID
     parent_id 被点赞用户ID
     */
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"tapSupportWithParameterDict === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}

- (void)cancelTapSupportWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block//取消点赞
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,CancelTapSupport];
    
    /*
     user_id 点赞ID
     parent_id 被取消点赞用户ID
     */
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"cancelTapSupportWithParameterDict === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}

- (void)attentionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block//关注
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,Attention];
    /*
     user_id 自己的ID
     parent_id 被关注用户ID
     follow_type 1为用户 2为店铺 3为商品 4为点赞
     */

    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"attentionWithParameterDict === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];

}

- (void)cancelAttentionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block//取消关注
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,CancelAttention];
    
    
    /*
     user_id 自己的ID
     parent_id 被关注用户ID
     follow_type 1为用户 2为店铺
     */
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"cancelAttentionWithParameterDict === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];

}


/*
 * 关注列表
 *
 * parameterDict ：所需参数
 * user_id      ：用户ID
 * parent_id    ：被关注ID
 * follow_type  ：关注类型 ：1 是用户；2 是店铺；3 商品；4 sure点赞
 *
 */
- (void)attentionListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block//关注列表
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AttentionList];
    
    /*
     user_id 自己的ID
     parent_id 被关注用户ID
     加载缓存
     */
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"关注列表 =====%@",responseObject);
         
         
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArr = nil;
             if (array && array.count)
             {
                 if ([[parameterDict objectForKey:@"follow_type"] isEqualToString:@"3"])//收藏商品
                 {
                     listArr = [CollectProductModel parserDataWithArray:array];
                 }
                 else if ([[parameterDict objectForKey:@"follow_type"] isEqualToString:@"2"])//收藏品牌
                 {
                     listArr = [CollectBrandModel parserDataWithArray:array];
                 }
                 else if ([[parameterDict objectForKey:@"follow_type"] isEqualToString:@"1"])//关注个人
                 {
                     
                 }
                 else if ([[parameterDict objectForKey:@"follow_type"] isEqualToString:@"4"])//SURE点赞
                 {
                     listArr = [TapUserModel parserTapUserListWithArray:array];
                 }
             }
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArr,nil);
                            });
             
         }
         
         
    }];
}

- (void)sureListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<SUREModel *> *listArray ,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,SureList];
    
    /*
     cur_page 当前页面
     cur_size 一个页面多少数据
     parent_id 针对某人的SURE
     */
    
    AFNetDiskCacheType chcheType ;
    if ([parameterDict[@"cur_page"] isEqualToString:@"1"])
    {
        chcheType = AFNetDiskCacheTypeUseCacheThenUseLoad;
    }
    else
    {
        chcheType = AFNetDiskCacheTypeIgnoringCache;
    }
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:chcheType completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"sureListWithParameterDict === %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
         if (error == nil)
         {
             NSArray *resultArray =  [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArray = [NSMutableArray array];
             
             
             [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 SUREModel *model = [SUREModel modelObjectWithDictionary:obj];
                 [listArray addObject:model];
             }];
             
             
             
             

             dispatch_async(dispatch_get_main_queue(), ^
            {
                block(listArray,error);
            });
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                {
                    block(nil,error);
                });
         }
     }];
}

- (void)sureMainListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<AccountInfo *> *userListArray ,NSMutableArray<SUREModel *> *listArray ,NSMutableArray<BrandDetaileModel *> *brandListArray ,NSInteger brandIndex,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,SureList];
    
    /*
     cur_page 当前页面
     cur_size 一个页面多少数据
     parent_id 针对某人的SURE
     */
    
    AFNetDiskCacheType chcheType ;
    if ([parameterDict[@"cur_page"] isEqualToString:@"1"])
    {
        chcheType = AFNetDiskCacheTypeUseCacheThenUseLoad;
    }
    else
    {
        chcheType = AFNetDiskCacheTypeIgnoringCache;
    }
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:chcheType completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         NSLog(@"sureListWithParameterDict === %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         
         if (error == nil)
         {
             NSArray *resultArray =  [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArray = [NSMutableArray array];
             
             NSMutableArray *brandListArray = [NSMutableArray array];
             __block NSInteger brandIndex = 3;
             [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  SUREModel *model = [SUREModel modelObjectWithDictionary:obj];
                  
                  NSDictionary *dict = obj;
                  
                  if ([dict.allKeys containsObject:@"good_supplier"])
                  {
                      brandIndex = idx + 1;
                      
                      NSArray *brand = dict[@"good_supplier"];
                      [brand enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                       {
                           BrandDetaileModel *model = [BrandDetaileModel parserDataWithResultDictionary:obj];
                           
                           
                           [brandListArray addObject:model];
                       }];
                      
                      
                  }
                  
                  
                  [listArray addObject:model];
              }];
             
             
             
             NSArray *resultUserArray =  [[responseObject objectForKey:@"data"] objectForKey:@"result_user"];
             
             NSMutableArray *userListArray = [NSMutableArray array];
             [resultUserArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  
                  AccountInfo *account = [[AccountInfo alloc]init];
                  [account parserDataWithDictionary:obj];
                  [userListArray addObject:account];
              }];
             
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(userListArray,listArray,brandListArray,brandIndex,error);
                            });
             
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,nil,nil,0,error);
                            });
         }
         
         
         
     }];

}

- (void)postSureWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,SendSure];
    
    /*
     uid 用户ID
     sure_body 文字
     imglist json数据
     */

    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"postSureWithParameterDict === %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];

}

- (void)deleteSureStatusWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,DeleteSure];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}


- (void)personalSureStatusWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (OtherDetaileModel *userDetaileModel,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,SurePersonal];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil ,error);
                            });
         }
         else
         {
             NSLog(@"个人详情界面 ============= %@",responseObject);
             
             NSDictionary *dict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             OtherDetaileModel *userModel = [OtherDetaileModel parserOtherDetaileModelWithDict:dict];
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                
                                block(userModel ,nil);
                            });
         }
         

     }];
}

/*
 * 单独获取他人赞过的SURE ，或者 tag 过的品牌
 *
 * parameterDict ：所需参数
 * parent_id ： 要查看的人的UID
 * sure_type ： 查看类型 ：赞过的sure：sure ； 赞过的品牌：brand
 * cur_page 当前页面
 * cur_size 每页多少个
 */
- (void)personalSureDataWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,SurePersonalData];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     { 
         
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil ,error);
                            });
         }
         else
         {
             NSLog(@"个人详情数据 ============= %@",responseObject);
             
             
             
             if ([parameterDict[@"sure_type"] isEqualToString:@"sure"])
             {
                 //赞过的SURE
                 
                 NSArray *resultArray = [[[responseObject objectForKey:@"data"] objectForKey:@"result"]  objectForKey:@"like_sure_list"];
                 NSMutableArray *listArray = [NSMutableArray array];
                 
                 
                 [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                  {
                      [listArray addObject:[SUREModel modelObjectWithDictionary:obj]];
                  }];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    block(listArray,error);
                                });
                 
                 
                 
             }
             else if ([parameterDict[@"sure_type"] isEqualToString:@"brand"])
             {
                 //tag 过的品牌
                 
                 
                 
                 
             }
         }
         
         
     }];

}


/*
 * 举报
 *
 * parameterDict ：所需参数
 * uid ： 用户ID
 * fdid ： 被举报ID
 * report_t 举报类型
 * report_text 举报文本
 */
- (void)reportObjectWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ReportObject];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         if (error)
         {
             
             NSLog(@"举报失败============= %@",error);

             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(error);
                            });
         }
         else
         {
             NSLog(@"举报成功============= %@",responseObject);
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil);
                            });
         }
         
         
     }];
}

/*
 * 推荐主页
 *
 * parameterDict ：所需参数
 * cur_page ： 页数
 * cur_size ： 数量
 */
- (void)getRecommendWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *topBannerArray,NSMutableArray<NSDictionary *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,RecommendList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         if (error)
         {
             
             NSLog(@"推荐============= %@",error);
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,nil, error);
                            });
         }
         else
         {
             NSLog(@"推荐============= %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
             
             NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArray = [NSMutableArray array];
             [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  [listArray addObject:obj];
              }];
             
             
             NSArray *bananerArray = [[responseObject objectForKey:@"data"] objectForKey:@"main_banner"];
             NSMutableArray *bananerListArray = [NSMutableArray array];
             [bananerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  [bananerListArray addObject:obj];
              }];
             
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(bananerListArray,listArray, error);
                            });
         }
         
         
     }];

}

/*
 * 分类主页
 *
 * parameterDict ：所需参数
 * cur_page ： 页数
 * cur_size ： 数量
 * parent_id 父节点
 */
- (void)getCommodityKindWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<KindModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,KindList];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         if (error)
         {
             
             NSLog(@"分类============= %@",error);
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil, error);
                            });
         }
         else
         {
             NSLog(@"分类============= === %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);

             NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *listArray = [NSMutableArray array];
             [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 KindModel *kindModel = [KindModel modelObjectWithDictionary:obj];
                 [listArray addObject:kindModel];
             }];
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray, error);
                            });
         }
         
         
     }];
}

- (void)getAllKindCompletionBlock:(void (^) (NSMutableArray<KindModel *> *listArray, NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,AllKindList];
    
    
    [self.netClient requestForPostUrl:urlString parameters:@{} CacheType:AFNetDiskCacheTypeUseCacheThenUseLoad completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         
         if (error)
         {
             
             NSLog(@"所有的分类============= %@",error);
             
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil, error);
                            });
         }
         else
         {
             NSLog(@"所有的分类==== %@",[ConsoleOutPutChinese outPutJsonWithObj:responseObject]);
             
             NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             NSMutableArray *listArray = [KindModel modelListWithArray:array];
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(listArray, error);
                            });
         }
         
         
     }];

}

@end
