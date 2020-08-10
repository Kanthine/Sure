//
//  UserInfoHttpManager.h
//  SURE
//
//  Created by 王玉龙 on 17/1/19.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoHttpManager : NSObject

/* 修改个人信息
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * nickname 用户昵称
 * headimg  用户头像地址
 * sex      用户性别 0，保密；1，男；2，女
 * birthday 用户生日 2016-02-30
 * minename 个性签名
 *
 */
- (void)updatePersonalInfoParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block;


/* 申请成为签约用户
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 */
- (void)applyPostPaidParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block;

/* 得到收货地址列表
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * cur_page 用户昵称
 * cur_size  用户头像地址
 *
 */
- (void)getShippingListCompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block;


/* 添加 、修改收货地址
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * consignee 收货人
 * country  国家
 * province ：省份
 * city 城市
 * district  区*
 * address ：具体街道地址
 * mobile 手机
 * address_name  地址名字 这里用作是否默认地址
 * address_id  收货地址id 做添加操作不需要填，修改的时候把收货地址id放进去
 */
- (void)addShippingAdressParameterDict:(NSDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block;


/* 删除收获地址
 *
 * parameterDict 登录时需要参数：
 * user_id ：用户id
 * address_id 收货地址id
 *
 */
- (void)deleteShippingAdressWithAddressId:(NSString *)addressIDString CompletionBlock:(void (^) (NSError *error))block;



@end
