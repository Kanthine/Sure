//
//  RequestURL.h
//  SURE
//
//  Created by 王玉龙 on 16/12/6.
//  Copyright © 2016年 longlong. All rights reserved.
//

//http://sureapi.dt87.cn/sure_api/shop 接口文档

/*
 * 所有的私有接口：post请求需添加两个参数
 * user_id：用户ID
 * u_token token值
 *
 */

#ifndef RequestURL_h
#define RequestURL_h

#define TimeOutInterval 19.0f  //网络请求时间

#define DOMAINBASE @"http://sureapi.dt87.cn"
#define PublicInterface @"/api/sureapi/sure_common"
#define PrivateInterface @"/api/sureapi/sure_security"

#define DOMAIN_Public @"http://sureapi.dt87.cn/api/sureapi/sure_common"
#define DOMAIN_Private @"http://sureapi.dt87.cn/api/sureapi/sure_security"
#define ImageUrl @"http://sure.dt87.cn"


#pragma mark - Public

#define HomePageBrandListURL @"get_supplier_list"//首页品牌列表
#define BrandDetaileCommodityList @"get_goods_list"//品牌详情商品列表
#define BrandDetaile @"get_supplier_view"//品牌详情

#define CommodityDetaileURL @"get_goods_view"//商品详情

#define AllKindList @"get_category_list_all"//所有分类
#define KindList @"get_category_list"//分类
#define RecommendList @"get_ad_list" //推荐

#define GetVerificationCode @"get_code"//获取验证码
#define RegisterUser     @"register"//注册
#define LoginUser        @"login" //登录
#define ThirdPartyLogin  @"third_login"//第三方登录
#define BindingMobilePhone  @"bind_phone"//绑定手机号
#define ResetPassword    @"reset_new_passwd"  //重置密码

#define ShippingAdressList @"get_user_address_list"//收获地址

#define CouponList @"get_user_bonus_list"//优惠券列表

#define AttentionList   @"user_follow_list" //关注列表

#define SureList @"get_sure_list" //获取SURE列表
#define BrandSureList @"user_sure_item_list" //商品或品牌SURE列表

#define SurePersonal @"sure_view" //查看个人详情
#define SurePersonalData @"other_sure_list" //个人详情数据

#define ApplyPostPaid @"update_user_isqianyue" //申请成为签约用户


#pragma mark - Private

#define UpdateUserInfo @"update_user_info" //修改个人信息

#define AddShippingAdress @"add_user_address" //增加收货地址
#define DeleteShippingAdress @"del_user_address"//删除收获地址


#define ShoppingCarList @"get_cart_list"//购物车列表
#define ShoppingCarAdd @"cart_info_add" //添加商品至购物车
#define ShoppingCarDelete @"cart_delete" //购物车删除
#define ShoppingCarUpdate @"cart_update" //修改购物车商品信息

//订单
#define SubmitOrder @"order_add"//添加订单
#define PaySuccess  @"update_pay_status"//支付成功
#define OrderPayInfo @"get_order_string_bysn"//订单支付信息
#define OrderList @"get_order_info_list"//获取订单列表

#define TapSupport @"add_sure_goods_list"//点赞
#define CancelTapSupport @"del_sure_goods_list"//取消点赞
#define Attention @"add_user_follow_list" //关注
#define CancelAttention @"del_user_follow_list"  //取消关注

#define SendSure @"add_sure_list" //发布SURE消息
#define DeleteSure @"del_sure" //删除SURE消息

#define ReportObject @"add_sure_report" //举报


#endif /* RequestURL_h */
