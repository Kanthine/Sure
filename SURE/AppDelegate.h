//
//  AppDelegate.h
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic,strong)void (^aliPayOrderResult)(NSDictionary*);   //支付宝
@property (nonatomic,strong)void (^libWeChatPayResult)(NSString*); //微信


#pragma mark - CoreData

//上下文，只关注数据的增删改查
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型：只管理数据类型（实体，相当于数据库中的表）
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//数据持久化的协调器：主要负责管理数据库文件
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

//com.konglong.SURE


/*
 https://my.oschina.net/shede333/blog/304560    设置状态栏 文字颜色
 http://www.cocoachina.com/ios/20150202/11084.html  可执行文件 干货
 http://sureapi.dt87.cn/sure_api/shop
 
 189098234
 189098123
 [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
 if (error.errorCode == ECErrorType_NoError) {
 [DemoGlobalClass sharedInstance].userName = userName;
 [DemoGlobalClass sharedInstance].userPassword = password;
 }
 }];

 
 /Users/longlong/Desktop/SURE/SURE/Framework/Alipay/Util/openssl_wrapper.m:11:9: In file included from /Users/longlong/Desktop/SURE/SURE/Framework/Alipay/Util/openssl_wrapper.m:11:
 
 */



/*
NSPersistentContainer是一个新类，它简化了创建一个心的CoreData堆。它维持了你项目中的NSManagedObjectModel ，NSPersistentStoreCoordinator 和其他资源的引用。在添加一个持久化存储的时候，NSPersistentContainer使用了一个新类NSPersistentStoreDescription来描述配置信息，并传到NSPersistentStoreCoordinator。NSPersistentStoreCoordinator默认可以自动对一个NSSQLiteStoreType进行迁移。在Xcode中新建iOS项目中，使用CoreData现在在AppDelegate中使用
*/
