//
//  ValidateClass.h
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateClass : NSObject
/*
 * 验证手机号
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel;

/*
 * 验证密码是否为 4-8位 且包含字母和数字
 */
+(BOOL)judgePassWordLegal:(NSString *)password;

@end
