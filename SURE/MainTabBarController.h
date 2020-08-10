//
//  MainTabBarController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

+ (MainTabBarController *)shareMainController;

+ (UINavigationController *)shareOwnerNavigationController;

- (void)loadNetworkData;

@end
