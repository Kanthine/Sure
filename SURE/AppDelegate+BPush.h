//
//  AppDelegate+BPush.h
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AppDelegate.h"

/* 百度云推送 */
#import "BPush.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



@interface AppDelegate (BPush)


- (void)BPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;



@end
