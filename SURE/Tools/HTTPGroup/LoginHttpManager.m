//
//  LoginHttpManager.m
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "LoginHttpManager.h"

#import "AFNetAPIClient.h"

@interface LoginHttpManager()

@property (nonatomic ,strong) AFNetAPIClient *netClient;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@property (nonatomic ,strong) NSURLSessionTask *brandCommodityListTask;
@property (nonatomic ,strong) NSURLSessionTask *orderListTask;


@end


@implementation LoginHttpManager

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
 * 获取验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * user_id ：用户id 第三方登录/重置密码需要录入
 */
- (void)getVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^)(NSString *, NSError *))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,GetVerificationCode];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
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
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                
                                NSLog(@"%@",responseObject);
                                
                                NSString *codeString = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"salt"]];
                                block(codeString,nil);
                            });
         }
         
     }];
}

/*
 * 注册
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * salt ：验证码
 * password 密码
 * froms  苹果开发填写iOS 安卓开发填写Android
 */
- (void)regiserAccountWithParameter:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BOOL isSuccess,NSString *errorString))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,RegisterUser];
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if (error || ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] integerValue] != 1))
                            {
                                block(NO,error.domain);
                            }
                            else
                            {
                                block(YES,nil);
                            }
                        });
     }];
}

/*
 * 登录
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password 密码
 */
- (void)loginWithAccount:(NSString *)numberString Password:(NSString *)pwdString CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,LoginUser];
    
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    [parametersDict setObject:numberString forKey:@"user_name"];
    [parametersDict setObject:pwdString forKey:@"password"];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
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
             NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             AccountInfo *user = [AccountInfo modelObjectWithDictionary:reseltDict];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(user,nil);
                            });
         }
     }];
}

/*
 * 第三方登录
 *
 * parameterDict 登录时需要参数：
 * aite_id ： 第三方UID
 * login_type ：登录类型 1为QQ 2为微信 3为新浪
 * nickname ： 用户名
 * headimg  ： 用户头像
 */
- (void)thirdPartyLoginWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ThirdPartyLogin];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
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
             NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             AccountInfo *user = [AccountInfo modelObjectWithDictionary:reseltDict];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(user,nil);
                            });
         }
     }];
    
}

/*
 * 第三方登录 （第一次登录时  绑定手机号 ）
 *
 * parameterDict 登录时需要参数：
 * user_id ： 用户ID
 * mobile_phone ：手机号
 * salt ： 验证码
 */
- (void)bindingMobilePhoneWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,BindingMobilePhone];
    
    [self.netClient requestForPostUrl:urlString parameters:parameterDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
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
             NSDictionary *reseltDict = [[responseObject objectForKey:@"data"] objectForKey:@"result"];
             
             AccountInfo *user = [AccountInfo modelObjectWithDictionary:reseltDict];
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                block(user,nil);
                            });
         }
     }];
    
}

/*
 * 重置密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password ：密码
 * salt ： 验证码
 */
- (void)resetPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BOOL isSuccess,NSError *error))block//重置密码
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",PublicInterface,ResetPassword];
    
    
    [self.netClient requestForPostUrl:urlString parameters:parametersDict CacheType:AFNetDiskCacheTypeIgnoringCache completion:^(BOOL isCacheData,id responseObject,NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
        {
            if (error)
            {
                block(NO,error);
            }
            else
            {
                block(YES,nil);
            }
        });
     }];
}


@end
