//
//  AuthorizationManager.h
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizationManager : NSObject

/*
 * SURE 判断是否授权
 */
+ (BOOL)isAuthorization;

/*
 * 若是没有授权，则跳转至授权登录界面
 */
+ (void)getAuthorizationWithViewController:(UIViewController *)viewController;


/*
 * IM 若是没有登录，则登录
 */
+ (void)getIM_Authorization;

/*
 * IM 若是登录，则退出
 */
+ (void)cancelIM_Authorization;





@end
