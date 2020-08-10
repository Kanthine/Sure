//
//  IMHttpManager.m
//  SURE
//
//  Created by 王玉龙 on 17/1/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "IMHttpManager.h"

@interface IMHttpManager ()
@property (nonatomic, assign) NSInteger SmsVerifyCodeType;
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
@end

@implementation IMHttpManager

+(instancetype)sharedInstanced
{
    static dispatch_once_t onceToken;
    static IMHttpManager *httptool;
    dispatch_once(&onceToken, ^{
        httptool = [[self alloc] init];
    });
    return httptool;
}

- (void)queryMessageReadStatus:(NSInteger)type
                         msgId:(NSString*)msgId
                      pageSize:(NSInteger)pageSize
                        pageNo:(NSInteger)pageNo
                    completion:(void (^)(NSString *err,NSArray *array,NSInteger totalSize))completion {
    _mgr = [AFHTTPSessionManager manager];
    NSString *timerStr = [CommonTools stringFromDate:@"yyyyMMddHHmmss" WithDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *authorBase64 = [NSString stringWithFormat:@"%@:%@",[DemoGlobalClass sharedInstance].appKey,timerStr];
    authorBase64 = [[authorBase64 dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_mgr.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [_mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [_mgr.requestSerializer setValue:authorBase64 forHTTPHeaderField:@"Authorization"];
    [_mgr.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        return parameters;
    }];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    [bodyDict setValue:msgId forKey:@"msgId"];
    [bodyDict setValue:@(pageSize) forKey:@"pageSize"];
    [bodyDict setValue:@(pageNo) forKey:@"pageNo"];
    [bodyDict setValue:@(type) forKey:@"type"];
    [bodyDict setValue:[DemoGlobalClass sharedInstance].userName forKey:@"userName"];
    
    NSString *paramter = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSString *sig = [CommonTools MD5:[NSString stringWithFormat:@"%@%@%@",[DemoGlobalClass sharedInstance].appKey,[DemoGlobalClass sharedInstance].appToken,timerStr]];
    NSString *url = [NSString stringWithFormat:@"%@%@/IMPlus/MessageReceipt?sig=%@",URLHead,[DemoGlobalClass sharedInstance].appKey,sig];
    [self POST:url parameters:paramter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *statusCode = [responseObject objectForKey:@"statusCode"];
        NSArray *result = [responseObject objectForKey:@"result"];
        NSInteger totalSize = [[responseObject objectForKey:@"totalSize"] integerValue];
        NSMutableArray *readStatusArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            ECReadMessageMember *member = [[ECReadMessageMember alloc] init];
            member.userName = dict[@"useracc"];
            member.timetmp = dict[@"time"];
            [readStatusArray addObject:member];
        }
        NSLog(@"queryMessageReadStatus-statusCode:%@,readStatusArray:%@,totalSize:%ld",statusCode,readStatusArray,(long)totalSize);
        completion(statusCode,readStatusArray,totalSize);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion([NSString stringWithFormat:@"%ld",(long)error.code],nil,0);
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [_mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [_mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}
@end
