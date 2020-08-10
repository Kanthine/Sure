//
//  HttpManager.h
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DataModels.h"

//缓存数据、没有网络时从本地获取数据
@interface HttpManager : NSObject

/*
 * 首页品牌列表
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 *
 */
- (void)getBrandListDataWithParametersDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray<BrandDetaileModel *> *brandModelArray ,NSError *error))block;
/*
* 品牌详情页
*
* cur_page ：当前页数
* cur_size ：每页数据量
*
*/
- (void)getBrandDetaileWithParametersDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (BrandDetaileModel *brandModel ,NSError *error))block;
/*
 * 品牌详情页 商品列表
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 * order_by ：分类 综合（click_count）销量（buymax）价格（shop_price）新品（add_time）
 * desc     ：排序 倒序desc/正序asc*
 * supplier_id ： 品牌Id
 */
- (void)getBrandCommodityListWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray *productListArray ,NSError *error))block;

- (void)getSingleProductDataWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (ProductModel *product,NSError *error))block;//获取商品详情



/*
 * SURE列表:品牌页面的SURE，商品详情页的who's SURE
 *
 * cur_page ：当前页数
 * cur_size ：每页数据量
 * sure_id  ：sure id
 * goods_id ：商品Id
 * brand_id ：品牌Id
 * sure_type：数据类型 当前sure的人：user； 品牌的sure：brand；当前商品的sure：goods；
 */

- (void)getBrandOrCommoditySureListWithParameterDict:(NSDictionary *)parametersDict CompletionBlock:(void (^) (NSMutableArray *sureListArray ,NSError *error))block;
#pragma mark - 购物车


- (void)addProductToShoppingCarWithParameterDict:(NSMutableDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;//添加购物车

- (void)getShoppingCarListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (ShoppingCarModel *carModel ,NSError *error))block;//获取购物车列表

- (void)deleteShoppingCarProfuctWithCarID:(NSString *)carIDString CompletionBlock:(void (^) (NSError *error))block;//删除购物车商品，可多件删除

- (void)updateShoppingCarProfuctParameterDict:(NSMutableDictionary *)parameterDict  CompletionBlock:(void (^) (NSError *error))block;//修改购物车 商品信息


#pragma mark - 订单

- (void)submitOrderParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block;

/*
 * 根据订单ID信息获取支付信息
 * parameterDict 所需参数
 * order_id ：订单ID
 */
- (void)getOrderPayInfoWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block;

/*
 * 支付完成后 通知后台服务器
 * parameterDict 所需参数
 * order_id ：订单ID
 */
- (void)payFinishedWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSDictionary *payDict ,NSError *error))block;


- (void)getOrderListParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block;//获取订单列表

/*
* 优惠券列表
*
* parameterDict ：所需参数
* user_id      ：用户ID
* cur_page    ：页码
* cur_size    ：每页数量
*/
- (void)getCouponListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block;

/*
 * 添加关注
 *
 * parameterDict ：所需参数
 * user_id      ：用户ID
 * parent_id    ：被关注ID
 * follow_type  ：关注类型 ：1 是用户；2 是店铺；3 商品；4 sure点赞
 *
 */
- (void)attentionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;

/*
 * 取消关注
 *
 * parameterDict ：所需参数
 * user_id      ：用户ID
 * parent_id    ：被关注ID
 * follow_type  ：关注类型 ：1 是用户；2 是店铺；3 商品；4 sure点赞
 *
 */
- (void)cancelAttentionWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;

/*
 * 关注列表
 *
 * parameterDict ：所需参数
 * user_id      ：用户ID
 * parent_id    ：被关注ID
 * follow_type  ：关注类型 ：1 是用户；2 是店铺；3 商品；4 sure点赞
 *
 */
- (void)attentionListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray ,NSError *error))block;//关注列表

/*
 * SURE列表
 *
 * parameterDict ：所需参数
 * user_id      ：当前用户ID
 * parent_id    ：查看某个人SURE 的被查看人ID
 * cur_page     ：页数
 * cur_size     ：每页个数
 *
 */
- (void)sureListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<SUREModel *> *listArray ,NSError *error))block;//SURE列表

- (void)sureMainListWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<AccountInfo *> *userListArray ,NSMutableArray<SUREModel *> *listArray ,NSMutableArray<BrandDetaileModel *>  *brandListArray ,NSInteger brandIndex,NSError *error))block;//SURE列表

- (void)postSureWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;//发布 SURE

/*
 * 删除自己发布的SURE状态
 *
 * parameterDict ：所需参数
 * id ： SURE状态的ID
 *
 */
- (void)deleteSureStatusWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;

/*
 * 查看别人详情页面
 *
 * parameterDict ：所需参数
 * parent_id ： 要查看的人的UID
 * user_id   ： 当前用户ID
 * sure_type ： 查看类型 ：SURE：sure_list ；赞过的sure：sure；赞过的品牌：brand
 */
- (void)personalSureStatusWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (OtherDetaileModel *userDetaileModel,NSError *error))block;


/*
 * 单独获取他人赞过的SURE ，或者 tag 过的品牌
 *
 * parameterDict ：所需参数
 * parent_id ： 要查看的人的UID
 * sure_type ： 查看类型 ：赞过的sure：sure ； 赞过的品牌：brand
 * cur_page 当前页面
 * cur_size 每页多少个
 */
- (void)personalSureDataWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray *listArray,NSError *error))block;

/*
 * 举报
 *
 * parameterDict ：所需参数
 * uid ： 用户ID
 * fdid ： 被举报ID
 * report_t 举报类型
 * report_text 举报文本
 */
- (void)reportObjectWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSError *error))block;


/*
 * 推荐主页
 *
 * parameterDict ：所需参数
 * cur_page ： 页数
 * cur_size ： 数量
 */
- (void)getRecommendWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<NSDictionary *> *topBannerArray,NSMutableArray<NSDictionary *> *listArray, NSError *error))block;


/*
 * 分类主页
 *
 * parameterDict ：所需参数
 * cur_page ： 页数
 * cur_size ： 数量
 * parent_id 父节点
 */
- (void)getCommodityKindWithParameterDict:(NSDictionary *)parameterDict CompletionBlock:(void (^) (NSMutableArray<KindModel *> *listArray, NSError *error))block;

/*
 * 分类数据
 */
- (void)getAllKindCompletionBlock:(void (^) (NSMutableArray<KindModel *> *listArray, NSError *error))block;
@end
