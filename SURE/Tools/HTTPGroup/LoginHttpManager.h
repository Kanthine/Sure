//
//  LoginHttpManager.h
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataModels.h"


@interface LoginHttpManager : NSObject

/*
 * 获取验证码
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * user_id ：用户id 第三方登录/重置密码需要录入
 */
- (void)getVerificationCodeWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSString *verificationCodeString,NSError *error))block;

/*
 * 注册
 * parameterDict 登录时需要参数：
 * mobile_phone ： 手机号
 * salt ：验证码
 * password 密码
 * froms  苹果开发填写iOS 安卓开发填写Android
 */
- (void)regiserAccountWithParameter:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BOOL isSuccess,NSString *errorString))block;

/*
 * 登录
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password 密码
 */
- (void)loginWithAccount:(NSString *)numberString Password:(NSString *)pwdString CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block;//

/*
 * 第三方登录
 *
 * parameterDict 登录时需要参数：
 * aite_id ： 第三方UID
 * login_type ：登录类型 1为QQ 2为微信 3为新浪
 * nickname ： 用户名
 * headimg  ： 用户头像
 */
- (void)thirdPartyLoginWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block;

/*
 * 第三方登录 （第一次登录时  绑定手机号 ）
 *
 * parameterDict 登录时需要参数：
 * user_id ： 用户ID
 * mobile_phone ：手机号
 * salt ： 验证码
 */
- (void)bindingMobilePhoneWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (AccountInfo *user,NSError *error))block;

/*
 * 重置密码：
 *
 * parameterDict 登录时需要参数：
 * user_name ： 手机号
 * password ：密码
 * salt ： 验证码
 */
- (void)resetPasswordWithParameters:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BOOL isSuccess,NSError *error))block;


@end
