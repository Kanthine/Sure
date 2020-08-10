//
//  AuthorizationManager.m
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "AuthorizationManager.h"
#import "LoginViewController.h"

#import "ECDevice.h"

@implementation AuthorizationManager


/*
 * 判断是否授权
 */
+ (BOOL)isAuthorization
{
    AccountInfo *user = [AccountInfo standardAccountInfo];
    
    NSString *token = user.uToken;
    NSString *userID = user.userId;
    
    if (token == nil || [token isEqualToString:@""])
    {
        return NO;
    }
    if (userID == nil || [userID isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

/*
 * 若是没有授权，则跳转至授权登录界面
 */
+ (void)getAuthorizationWithViewController:(UIViewController *)viewController
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.isNeedDismiss = YES;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [viewController presentViewController:nav animated:YES completion:nil];
}


/*
 * IM 若是没有登录，则登录
 */
+ (void)getIM_Authorization
{
    if ([self isAuthorization] == NO)
    {
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
    loginInfo.username = account.userId;
    loginInfo.userPassword = account.userId;
    loginInfo.appKey = [DemoGlobalClass sharedInstance].appKey;//注册应用时得到的App key
    loginInfo.appToken = [DemoGlobalClass sharedInstance].appToken;//注册应用时得到的App token
    loginInfo.authType = LoginAuthType_NormalAuth;//认证模式
    loginInfo.mode = LoginMode_InputPassword;//登录模式
    
    
    [[DeviceDBHelper sharedInstance] openDataBasePath:account.userId];
    [DemoGlobalClass sharedInstance].isHiddenLoginError = NO;
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error)
    {
        //登录后发出链接的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
        
        //登陆成功
        if (error.errorCode == ECErrorType_NoError)
        {
            [DemoGlobalClass sharedInstance].userName = account.nickname;
            [DemoGlobalClass sharedInstance].userPassword = account.password;
        }
        else
        {
            NSLog(@"IM 登录失败 ======== %ld",(long)error.errorCode);
        }
        
    }];
}


/*
 * IM 若是登录，则退出
 */
+ (void)cancelIM_Authorization
{
    [[ECDevice sharedInstance] logout:^(ECError *error)
    {
        [DemoGlobalClass sharedInstance].userName = nil;
        [DemoGlobalClass sharedInstance].isLogin = NO;
        
        //为了页面的跳转，使用了该错误码，用户在使用过程中，可以自定义消息，或错误码值
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:10]];
    }];
}


@end
