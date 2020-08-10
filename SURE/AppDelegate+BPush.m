//
//  AppDelegate+BPush.m
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AppDelegate+BPush.h"

#import "MessageDetailsVC.h"
#import "MainTabBarController.h"

static BOOL isBackGroundActivateApplication;

@implementation AppDelegate (BPush)

- (void)BPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // iOS10 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [application registerForRemoteNotifications];
                                  }
                              }];
#endif
    }
    else
    {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    
    [BPush registerChannel:launchOptions apiKey:@"G5qIdiHw6KzC7fMFLgyXDry8" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"test" useBehaviorTextInput:YES isDebug:NO];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo)
    {
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
    NSLog(@"launchOptions ======= %@ ",launchOptions);
    
    
    /* 测试本地通知 */
//    [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:2.0];
}

#pragma mark 处理推送消息

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"acitve ");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
        [self jumpToMessageDetaileViewControllerWithUserInfo:userInfo];

        NSLog(@"applacation is unactive ===== %@",userInfo);

    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
           {
               
           }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            [self jumpToMessageDetaileViewControllerWithUserInfo:userInfo];
        }];
        [alertView addAction:cancelAction];
        [alertView addAction:confirmAction];
        [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
    }
    
    NSLog(@"推送消息 ========= %@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"acitve or background");
        
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            
        }];
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
           {
               [self jumpToMessageDetaileViewControllerWithUserInfo:userInfo];
           }];
        [alertView addAction:cancelAction];
        [alertView addAction:confirmAction];
        [self.window.rootViewController presentViewController:alertView animated:YES completion:nil];
        
    }
    else
    {
        //杀死状态下，直接跳转到跳转页面。
        [self jumpToMessageDetaileViewControllerWithUserInfo:userInfo];
    }
    
    NSLog(@"didReceiveRemoteNotification ==== %@",userInfo);
}

#pragma mark 注册推送

/* 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    
    [BPush registerDeviceToken:deviceToken];
    
    /*
     绑定Push服务通道，必须在设置好Access Token或者API Key并且注册deviceToken后才可绑定。绑定结果通过BPushCallBack回调返回。
     */
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error)
     {
         //        [self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
         // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
         
         // 网络错误
         if (error)
         {
             return ;
         }
         if (result)
         {
             // 确认绑定成功
             if ([result[@"error_code"]intValue]!=0)
             {
                 return;
             }
             // 获取channel_id
             NSString *myChannel_id = [BPush getChannelId];
             NSLog(@"myChannel_id == %@",myChannel_id);
             
             //             [BPush listTagsWithCompleteHandler:^(id result, NSError *error)
             //              {
             //                 if (result)
             //                 {
             //                     NSLog(@"result ============== %@",result);
             //                 }
             //             }];
             //             [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
             //                 if (result) {
             //                     NSLog(@"设置tag成功");
             //                 }
             //             }];
         }
     }];
}

/* 当 DeviceToken获取失败时，系统会回调此方法 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark 本地推送

- (void)testLocalNotifi
{
    NSLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:1 withFirstAction:@"打开" withSecondAction:nil userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil useBehaviorTextInput:YES];
}

/* 本地通知 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)jumpToMessageDetaileViewControllerWithUserInfo:(NSDictionary *)userInfo
{
    MessageDetailsVC *messageVC = [[MessageDetailsVC alloc]initWithInfo:userInfo];
    messageVC.hidesBottomBarWhenPushed = YES;
    
    MainTabBarController *mainController = [MainTabBarController shareMainController];
    [mainController setSelectedIndex:4];
    UINavigationController *ownerNav = [MainTabBarController shareOwnerNavigationController];
    [ownerNav pushViewController:messageVC animated:YES];
}



@end
