//
//  AppDelegate.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AppDelegate.h"

#import <Bugtags/Bugtags.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UIImage+Extend.h"

#import "LoginViewController.h"

#import "MainTabBarController.h"
#import "IntroPageViewController.h"

#import "AdressListLocalization.h"

#import "DeviceDelegateHelper.h"

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#import "AppDelegate+BPush.h"



@interface AppDelegate ()
<WXApiDelegate>



@end



@implementation AppDelegate

//- (void)redirectNSLogToDocumentFolder
//{
//    
//#if LOG_OPEN
//    if(isatty(STDOUT_FILENO)){
//        return;
//    }
//    
//    UIDevice *device = [UIDevice currentDevice];
//    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
//        return;
//    }
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *fileName =[NSString stringWithFormat:@"%@.log", [self.dataformater stringFromDate:[NSDate date]]];
//    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
//#endif
//    
//}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    [AdressListLocalization getAdressList];
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage loadNavBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
//    [self redirectNSLogToDocumentFolder];
    
    [self updateSDWebImage];
    
    
    
    
    
    

    MainTabBarController *mainController = [MainTabBarController shareMainController];
    [mainController loadNetworkData];
    if ([IntroPageViewController isFirstLaunch])
    {
        IntroPageViewController *introPage = [[IntroPageViewController alloc]init];
        self.window.rootViewController = introPage;
    }
    else
    {
        if ([AuthorizationManager isAuthorization]
            )
        {
            //及时通讯登录
            [AuthorizationManager getIM_Authorization];
            
            self.window.rootViewController = mainController;
        }
        else
        {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            self.window.rootViewController = nav;
        }
    }
    
    
    
    
    
    
    //云通讯
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];

    [WXApi registerApp:@"wx7eb96462c6767690" withDescription:@"SURE"];
    [self perfectUMSocialManagerInfo];
    
    [Bugtags startWithAppKey:@"ebabe6f6846b61879830a10c170c0fd5" invocationEvent:BTGInvocationEventNone];

    
    //推送
    [self BPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    

    
//    NSString  *string = [UIPasteboard generalPasteboard].string;
//    NSString *pasteboardName = [UIPasteboard generalPasteboard].name;
//    //判断名字 再展示
    
//    if (string)
//    {
//        UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"SURE分享" message:string delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
////        [alert show];        
//         [UIPasteboard removePasteboardWithName:pasteboardName];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    
    
//    if ([AuthorizationManager isAuthorization])
//    {
//        //若是登录，则IM退出登录
//        [AuthorizationManager cancelIM_Authorization];
//    }
    
    
    
    [self saveContext];
}

#pragma Alipy - callback

//微信回调
- (void)onResp:(BaseResp *)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]])
    {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode)
        {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                
                NSLog(@"微信支付结果 === %@",strMsg);
                
                break;
        }
    }
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url =========== %@",url);
    NSLog(@"sourceApplication =========== %@",sourceApplication);
    NSLog(@"annotation =========== %@",annotation);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == YES)
    {
        return result;
    }
    
    // 其他如支付等SDK的回调
    NSString *urlString = [NSString stringWithFormat:@"%@",url];

    //支付宝回调
    if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"])
    {
        if ([url.host isEqualToString:@"safepay"])
        {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
             {
                 self.aliPayOrderResult(resultDic);
             }];
        }
        else if ([url.host isEqualToString:@"platformapi"])
        {
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)
             {
                 self.aliPayOrderResult(resultDic);
             }];
        }
        return YES;
        
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.xin"] &&[urlString rangeOfString:@"pay"].length > 0)
    {
        NSString* result = @"";
        NSArray* array = [url.query componentsSeparatedByString:@"&"];
        NSString* ret = [array lastObject];
        array = [ret componentsSeparatedByString:@"="];
        if ([[array lastObject] integerValue] == 0)
        {
            result = @"支付成功";
        }
        else
        {
            result = @"支付失败";
        }
        
        self.libWeChatPayResult(result);
        
        return 1;
    }
    else
    {
        
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (!result)
        {
            
        }
        return result;

    }
    

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handleOpenURL ====== %@",url.absoluteString);
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == YES)
    {
        return result;
    }
    
    //其他的SDK回调
    
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"alipay"])
    {
        return YES;
    }
    else
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return  NO;
    

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"options ============  %@",options);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == YES)
    {
        return result;
    }
    
    //其他的SDK回调
    
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
            self.aliPayOrderResult(resultDic);
        }];

    }
    return YES;
}


#pragma mark -  DidFinishLaunchingWithOptions

- (void)updateSDWebImage
{
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers)
    {
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
        
        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
        
        NSDate *lastModifiedDate = nil;
        
        if (fileAttr.count > 0) {
            if (fileAttr.count > 0)
            {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
            
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        
        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        
        return mutableHeaders;
    };
}


- (void)perfectUMSocialManagerInfo
{
    [[UMSocialManager defaultManager] openLog:YES];

    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5861d0788f4a9d0368000a93"];
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;

    UMSocialLogInfo(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);

    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7eb96462c6767690" appSecret:@"950fc570163a104c3ee0d0b114885c9d" redirectURL:@"http://sureapi.dt87.cn/pay/notify_url"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101377260"  appSecret:@"782be864da976995af5cc1ea0e5d02da" redirectURL:@"http://sureapi.dt87.cn/pay/notify_url"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"139372876"  appSecret:@"400af26563bd94c70b18bbf7848659f2" redirectURL:@"http://sureapi.dt87.cn/pay/notify_url/sina"];
}


#pragma mark - Core Data stack


//这个代码会在MainBundle资源库中找到一个名为”SURE“的模型资源，加载它，创建一个新的NSPersistentStoreCoordinator持久化协调者，并在defaultDirectoryURL 这个默认路径下创建一个同名的持久化仓库。在还没有执行loadPersistentStores方法前，NSPersistentContainer持久化容器的配置是可以改变的。


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "c.b.CoreDataTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//懒加载，第一次调用的时候才进行初始化
//对内存造成的影响小一点
- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SURE" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SURE.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    //防止后续升级的时候，数据字段不对应导致崩溃，可以指定一个选项
    NSDictionary *opt = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                          NSInferMappingModelAutomaticallyOption:@YES};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:opt error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

//把内存中的数据，保存到数据文件中
- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
