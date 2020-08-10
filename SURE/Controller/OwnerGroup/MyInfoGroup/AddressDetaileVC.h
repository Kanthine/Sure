//
//  AddressDetaileVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
    AddressDetaileStateAdd,//添加地址
    AddressDetaileStateEdit,//编辑地址
} AddressDetaileState;


@interface AddressDetaileVC : UIViewController

/*
 * 是否必须设置默认地址
 *
 * 注：编辑地址时不理会默认地址的设置，只有添加地址时判定是否要设置默认地址
 */
@property (nonatomic ,assign) BOOL isNecessarySetDefaultAddress;
@property (nonatomic ,assign) AddressDetaileState detaileState;

@property (nonatomic ,strong) ShippingAddressModel *adressModel;

@end

//传值 传当前的位置
