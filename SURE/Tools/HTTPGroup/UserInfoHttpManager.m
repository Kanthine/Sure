//
//  UserInfoHttpManager.m
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "UserInfoHttpManager.h"

#import "AFNetAPIClient.h"

@interface UserInfoHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic ,strong) NSURLSessionTask *brandCommodityListTask;
@property (nonatomic ,strong) NSURLSessionTask *orderListTask;


@end

@implementation UserInfoHttpManager

- (void)dealloc
{
    NSLog(@"LoginHttpManager dealloc");
    
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

- (AFNetAPIClient *)netClient
{
    if (_netClient == nil)
    {
        _netClient = [AFNetAPIClient sharedClient];
    }
    
    return _netClient;
}






- (void)updatePersonalInfoParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block//修改个人信息
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,UpdateUserInfo];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}

/* 申请成为签约用户
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 */
- (void)applyPostPaidParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,ApplyPostPaid];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
        {
            block(error);
        });
     }];
}


- (void)getShippingListCompletionBlock:(void (^)(NSMutableArray *listArray ,NSError *error))block//得到收获地址列表
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ShippingAdressList];
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *parameterDict = @{@"user_id":account.userId,@"cur_size":@"40",@"cur_page":@"1"};
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"addShippingAdress === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         if (error)
         {
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(nil,error);
                            });
         }
         else
         {
             NSArray *resultArray = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             NSMutableArray *parserArray = [ShippingAddressModel parserDataWithShippingAddressArray:resultArray];
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(parserArray,nil);
                            });
         }
     }];
}

- (void)addShippingAdressParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block//添加/修改收货地址
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,AddShippingAdress];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"addShippingAdress === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
         
     }];
}

- (void)deleteShippingAdressWithAddressId:(NSString *)addressIDString CompletionBlock:(void (^) (NSError *error))block//删除收获地址
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PrivateInterface,DeleteShippingAdress];
    
    
    AccountInfo *user = [AccountInfo standardAccountInfo];
    NSString *userID = user.userId;
    NSDictionary *parameterDict = @{@"user_id":userID,@"address_id":addressIDString};
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         NSLog(@"deleteShippingAdress === %@",[ConsoleOutPutChinese outPutChineseWithObj:responseObject]);
         
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            block(error);
                        });
     }];
}

@end
