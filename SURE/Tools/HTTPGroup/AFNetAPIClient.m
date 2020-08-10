//
//  AFNetAPIClient.m
//  SURE
//
//  Created by 王玉龙 on 16/12/6.
//  Copyright © 2016年 longlong. All rights reserved.
//



#import "AFNetAPIClient.h"
#import "FilePathManager.h"
#import <Reachability.h>
#import <CoreTelephony/CTCellularData.h>
/*
 NSURLSessionConfiguration
 
 http://www.cnblogs.com/wayne23/p/5427667.html
 */

@interface AFNetAPIClient()
@property (nonatomic ,strong) CTCellularData *cellularData;
@property (nonatomic ,strong) Reachability *hostReach;
@end

@implementation AFNetAPIClient

+ (AFNetAPIClient *)sharedClient
{
    static AFNetAPIClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//                      [config setHTTPAdditionalHeaders:@{@"User-Agent" : @"JHDJ iOS 1.0"}];
                      
                      NSURLCache* cache = [[NSURLCache alloc]initWithMemoryCapacity:10*1024*1024 diskCapacity:50*1024*1024 diskPath:nil];
                      [config setURLCache:cache];
                      
                      
                      //初始化 AFHTTPSessionManager
                      NSURL * baseURL = [NSURL URLWithString:DOMAINBASE];
                      _sharedClient = [[self alloc]initWithBaseURL:baseURL sessionConfiguration:config];
                      _sharedClient.operationQueue.maxConcurrentOperationCount = 3;// 设置允许同时最大并发数量，过大容易出问题

                      
                      
                      // 设置请求序列化器
//                      _sharedClient.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;// 默认缓存策略
                      [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                      _sharedClient.requestSerializer.timeoutInterval = TimeOutInterval;
                      [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];


                      
                      // 设置响应序列化器，解析Json对象
                      AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
                      responseSerializer.removesKeysWithNullValues = YES; // 清除返回数据的 NSNull
                      responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html",nil]; // 设置接受数据的格式
                      responseSerializer.readingOptions = NSJSONReadingAllowFragments;
//                      responseSerializer.acceptableContentTypes = [NSSet setWithObjects:  @"application/x-javascript", @"application/json", @"text/json", @"text/javascript", @"text/html", nil]; // 设置接受数据的格式
                     _sharedClient.responseSerializer = responseSerializer;
                      
                      // 设置安全策略
                     _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];;
                      
                      _sharedClient.cellularData = [[CTCellularData alloc]init];

                    _sharedClient.hostReach = [Reachability reachabilityForInternetConnection];
                    [_sharedClient.hostReach startNotifier];
                  });
    
    return _sharedClient;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(nonnull NSCachedURLResponse *)proposedResponse completionHandler:(nonnull void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    
    NSURLResponse *response = proposedResponse.response;
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
    NSDictionary *headers = HTTPResponse.allHeaderFields;
    
    if (headers[@"Cache-Control"])
    {
        NSMutableDictionary *modifiedHeaders = headers.mutableCopy;
        modifiedHeaders[@"Cache-Control"] = @"max-age=60";
        NSHTTPURLResponse *modifiedHTTPResponse = [[NSHTTPURLResponse alloc]
                                                   initWithURL:HTTPResponse.URL
                                                   statusCode:HTTPResponse.statusCode
                                                   HTTPVersion:@"HTTP/1.1"
                                                   headerFields:modifiedHeaders];
        
        proposedResponse = [[NSCachedURLResponse alloc] initWithResponse:modifiedHTTPResponse
                                                                    data:proposedResponse.data
                                                                userInfo:proposedResponse.userInfo
                                                           storagePolicy:proposedResponse.storagePolicy];
    }

    
    [super URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];

}


/*
 * get 请求
 * url 请求地址
 * parameters 请求参数 为nil
 *
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForGetUrl:(NSString*)url parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject,NSError *error))completion
{
    //首先判断是否有网络：
    //没有网络时 ，查看本地有无缓存，若有，加载本地缓存
    //有网络时，从网络获取资源 并且缓存之本地
    
    if([AFNetAPIClient isLinkNetSuccess] == NO)
    {
        [self loadDiskCacheWithUrl:url parameters:parameters completion:^(id diskResponseObject, NSError *loadError)
         {
             completion(diskResponseObject,loadError);
         }];
        
        return nil;
    }
    
    
    
    NSURLSessionDataTask* task = [self GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) // 若解析数据格式异常，返回错误
                           {
                               NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
                               completion(nil,error);
                           }
                           else if([[responseObject objectForKey:@"error_flag"] intValue] == 0)// 若解析数据正常，判断API返回的code，
                           {
                               [AFNetDiskCache cacheResponseObject:responseObject request:url parameters:parameters];
                               
                               completion(responseObject,nil);
                           }
                           else
                           {
                               NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
                               completion(nil,error);
                           }
                           
                           
                       });
        
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [self requestFaileCompletion:^(id diskResponseObject, NSError *loadError)
         {
             completion(diskResponseObject,loadError);
         }];
    } ];
    
    return task;
}


/*
 * post 请求
 * url 请求地址
 * parameters 请求参数 为nil
 *
 * cacheType 缓存类型
 *
 * responseObject 请求结果
 * error 若请求失败则返回错误，否则返回nil
 */
-(NSURLSessionDataTask *)requestForPostUrl:(NSString*)url parameters:(NSDictionary *)parameters CacheType:(AFNetDiskCacheType)cacheType completion:(void (^)(BOOL isCacheData,id responseObject,NSError *error))completion;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    // 缓存只是针对第一页列表 以后的数据不做缓存
    if ([parameters.allKeys containsObject:@"cur_page"] && cacheType == AFNetDiskCacheTypeUseCacheThenUseLoad)
    {
        if ([parameters[@"cur_page"] isEqualToString:@"1"])
        {
            cacheType = AFNetDiskCacheTypeUseCacheThenUseLoad;
        }
        else
        {
            cacheType = AFNetDiskCacheTypeIgnoringCache;
        }
    }
        
    
    
    
    if ([url containsString:PrivateInterface])
    {
        // 私有接口
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [parameters.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            [dict setObject:parameters[obj] forKey:obj];
        }];
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([dict.allKeys containsObject:@"user_id"] == NO)
        {
            [dict setObject:account.userId forKey:@"user_id"];
        }
        
        if ([dict.allKeys containsObject:@"u_token"] == NO)
        {
            [dict setObject:account.uToken forKey:@"u_token"];
        }
        
//        parameters = dict;
//        NSLog(@"私有接口 ======== %@",parameters);
        
    }
    
    /*
     * 如果没有网络，并且本地有缓存数据，则加载本地数据
     */
    if([AFNetAPIClient isLinkNetSuccess] == NO)
    {
        [self loadDiskCacheWithUrl:url parameters:parameters completion:^(id diskResponseObject, NSError *loadError)
         {
             completion(YES,diskResponseObject,loadError);
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return nil;
    }
    
    
    /*
     * 本地有缓存数据，则拿到缓存数据并使用，并且再次更新本地缓存数据
     */
    if (cacheType == AFNetDiskCacheTypeUseCacheThenLoad && [AFNetDiskCache cacheIsExitWithURL:url parameters:parameters])
    {
        [self loadDiskCacheWithUrl:url parameters:parameters completion:^(id diskResponseObject, NSError *loadError)
         {
             completion(YES,diskResponseObject,loadError);
         }];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (cacheType == AFNetDiskCacheTypeUseLoadThenCache)//请求数据 缓存数据
    {
        
    }
    else if (cacheType == AFNetDiskCacheTypeIgnoringCache)// 不缓存
    {
        
    }
    else if (cacheType == AFNetDiskCacheTypeUseCacheThenUseLoad && [AFNetDiskCache cacheIsExitWithURL:url parameters:parameters])
    {
        /*
         * 本地有缓存数据，则拿到缓存数据并使用，并且再次更新本地缓存数据,并且更新界面
         */
        [self loadDiskCacheWithUrl:url parameters:parameters completion:^(id diskResponseObject, NSError *loadError)
         {
             completion(YES,diskResponseObject,loadError);
         }];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    
    
    /*
     * 有网络的情况下，使用网络加载数据
     */
    NSURLSessionDataTask* task = [self POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

//        NSLog(@"task.response ==== %@",task.response);
        
        //currentThread     {number = 1, name = main}
        
//        NSLog(@"responseObject   %@",responseObject);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
            if (cacheType == AFNetDiskCacheTypeUseCacheThenLoad)
            {
                /* 
                 * 有缓存就使用缓存，然后请求数据
                 * 在此处缓存数据时，先判断本地是否已经缓存，若缓存有数据，则再次缓存
                 */
                if ([AFNetDiskCache cacheIsExitWithURL:url parameters:parameters])
                {
                    // 不是第一次缓存
                    if([[responseObject objectForKey:@"error_flag"] intValue] == 0)
                    {
                        /*
                         * 得到正确结果
                         * 缓存数据，并且返回更新界面
                         */
                        [AFNetDiskCache cacheResponseObject:responseObject request:url parameters:parameters];
                    }
                }
                else
                {
                    // 第一次缓存
                    if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]))
                    {
                        /*
                         * 错误一：若解析数据格式异常，返回错误
                         */
                        NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
                        completion(NO,nil,error);
                    }
                    else if([[responseObject objectForKey:@"error_flag"] intValue] == 0)
                    {
                        /*
                         * 得到正确结果
                         * 缓存数据，并且返回更新界面
                         */
                        [AFNetDiskCache cacheResponseObject:responseObject request:url parameters:parameters];
                        completion(NO,responseObject,nil);
                    }
                    else
                    {
                        /*
                         * 错误二：操作错误提示，如密码错误等
                         */
                        NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
                        completion(NO,nil,error);
                    }
                }
                
        }
        else if (cacheType == AFNetDiskCacheTypeUseLoadThenCache)
        {
            /* 请求数据 缓存数据 不使用缓存 */
           if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]))
           {
               /* 若解析数据格式异常，返回错误 */
               NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
               completion(NO,nil,error);
           }
           else if([[responseObject objectForKey:@"error_flag"] intValue] == 0)
           {
               /* 若解析数据正常，判断API返回的code */
               [AFNetDiskCache cacheResponseObject:responseObject request:url parameters:parameters];
               completion(NO,responseObject,nil);
           }
           else
           {
               NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
               completion(NO,nil,error);
           }

        }
        else if (cacheType == AFNetDiskCacheTypeIgnoringCache)// 不缓存
        {
           if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) // 若解析数据格式异常，返回错误
           {
               NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
               completion(NO,nil,error);
           }
           else if([[responseObject objectForKey:@"error_flag"] intValue] == 0)// 若解析数据正常，判断API返回的code，
           {
               completion(NO,responseObject,nil);
           }
           else
           {
               NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
               completion(NO,nil,error);
           }
        }
        else if (cacheType == AFNetDiskCacheTypeUseCacheThenUseLoad)
        {
            /* 有缓存就使用缓存，然后请求数据在更新UI */

           if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]])) // 若解析数据格式异常，返回错误
           {
               NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
               completion(NO,nil,error);
           }
           else if([[responseObject objectForKey:@"error_flag"] intValue] == 0)// 若解析数据正常，判断API返回的code，
           {
               [AFNetDiskCache cacheResponseObject:responseObject request:url parameters:parameters];
               completion(NO,responseObject,nil);
           }
           else
           {
               NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
               completion(NO,nil,error);
           }

        }

        
        
        });

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        completion(NO,nil,error);
        NSLog(@"task.response ==== %@ error ========= %@",task.response,error);
//       [self requestFaileCompletion:^(id diskResponseObject, NSError *loadError)
//        {
//            completion(NO,diskResponseObject,loadError);
//       }];
    }];
    
    return task;
}

//加载本地数据
- (void)loadDiskCacheWithUrl:(NSString*)url parameters:(NSDictionary *)parameters completion:(void (^)(id diskResponseObject, NSError *loadError))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
//                       if ([AFNetDiskCache isExpireWithRequest:url parameters:parameters])
//                       {
                           id response = [AFNetDiskCache  cahceResponseWithURL:url parameters:parameters];
                           
//                           NSLog(@"response ==== %@",response);
                       
                           if (!response || (![response isKindOfClass:[NSDictionary class]] && ![response isKindOfClass:[NSArray class]]))
                           {
                               NSError *error = [NSError errorWithDomain:@"数据有问题" code:100 userInfo:nil];
                               completion(nil,error);
                           }
                           else
                           {
                               completion(response,nil);
                           }
//                       }
//                       else
//                       {
//                           NSError *error = [NSError errorWithDomain:@"没有网络" code:100 userInfo:nil];
//                           completion(nil,error);
//                       }
                   });

}

- (void)requestFaileCompletion:(void (^)(id diskResponseObject, NSError *loadError))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
                       NSError *error = nil;
                       if (manager.isReachable)
                       {
                           error = [NSError errorWithDomain:@"找不到网络" code:100 userInfo:nil];
                       }
                       else
                       {
                           error = [NSError errorWithDomain:@"链接超时" code:100 userInfo:nil];
                       }
                       
                       completion(nil,error);
                   });
}

+ (BOOL)isLinkNetSuccess
{
    //应用启动后，检测应用中是否有联网权限
    [self sharedClient].cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state)
    {
    //当联网权限的状态发生改变时，会在上述方法中捕捉到改变后的状态，可根据更新后的状态执行相应的操作。
        //获取联网状态
        switch (state)
        {
            case kCTCellularDataRestricted:
                NSLog(@"Restricrted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        };
    };
    
    //查询应用是否有联网功能
    CTCellularDataRestrictedState state = [self sharedClient].cellularData.restrictedState;
    switch (state)
    {
        case kCTCellularDataRestricted://受限制网络
            NSLog(@"Restricrted");
            break;
        case kCTCellularDataNotRestricted://不受限制网络
            NSLog(@"Not Restricted");
            break;
        case kCTCellularDataRestrictedStateUnknown://未知网络
            NSLog(@"Unknown");
            break;
        default:
            break;
    }
    
    BOOL netStatus= NO;

    switch ([self sharedClient].hostReach.currentReachabilityStatus)
    {
        case NotReachable:
            netStatus= NO;
            NSLog(@"没有网络");
            break;
        case ReachableViaWiFi:
            NSLog(@"无线网络");
            netStatus= YES;
            break;
        case ReachableViaWWAN:
#pragma mark - 在窝蜂网络时，判断是否有权限
            
            NSLog(@"窝蜂网络");
            netStatus= YES;
            break;
        default:
            break;
    }
    
    return netStatus;
    

    
    
    /*
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    //网络只有在startMonitoring完成后才可以使用检查网络状态
     
     AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager] ;
     [manager startMonitoring];
     [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
     switch (status)
     {
     case AFNetworkReachabilityStatusUnknown://未知网络
     NSLog(@"未知网络");
     break;
     case AFNetworkReachabilityStatusNotReachable://没有网络
     NSLog(@"没有网络");
     break;
     case AFNetworkReachabilityStatusReachableViaWiFi://无线
     NSLog(@"无线");
     break;
     case AFNetworkReachabilityStatusReachableViaWWAN://手机网络
     NSLog(@"手机网络");
     break;
     
     default:
     break;
     }
     }];
     //只能在监听完善之后才可以调用
     BOOL isOK = [manager isReachable];
     BOOL isWifiOK = [manager isReachableViaWiFi];
     BOOL is3GOK = [manager isReachableViaWWAN];
     
     NSLog(@"isOK %d ------is3GOK- %d",isOK,is3GOK);
    
    if (isOK == NO)
    {
        return NO;
    }
    
    return YES;
     */
}

@end









///*
// * 首先 判断返回数据是否正确
// * 如错误，则返回错误原因，并且不做任何缓存
// * 若正确，则根据缓存类型，做相应的数据缓存
// */
//
//if (!responseObject || (![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSArray class]]))
//{
//    /*
//     * 错误一： 若解析数据格式异常，返回错误
//     */
//    
//    NSError *error = [NSError errorWithDomain:@"数据不正确" code:100 userInfo:nil];
//    completion(NO,nil,error);
//}
//else if ([[responseObject objectForKey:@"error_flag"] intValue] == 0)
//{
//    /*
//     * 数据返回成功，得到正确结果
//     *
//     * 根据缓存类型，决定是否返回数据
//     */
//    
//    
//    
//    
//    
//    
//    
//}
//else
//{
//    
//    /*
//     * 错误二：请求参数或者别的原因致使服务器返回错误原因
//     */
//    
//    NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"result_msg"] code:[[responseObject objectForKey:@"result_code"] integerValue] userInfo:nil];
//    completion(NO,nil,error);
//}


