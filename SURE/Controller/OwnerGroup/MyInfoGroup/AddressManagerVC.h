//
//  AddressManagerVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    AddressManagerStateLook,//
    AddressManagerStateCar,//从购物车跳进来选择地址
} AddressManagerState;


@protocol AddressManagerDelegate <NSObject>

//购物车界面 ，选择地址后 传递至购物车
- (void)switchShippingAddressWithAddress:(ShippingAddressModel *)addressModel;

@end

@interface AddressManagerVC : UIViewController


@property (nonatomic ,assign) id <AddressManagerDelegate> delegate;
@property (nonatomic ,assign) AddressManagerState parentType;

- (void)requestNetworkGetData;

@end
//页面出现后 立即修改默认地址 出现bug  修改后被网络请求数据覆盖
