//
//  PayOrderVC.h
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderVC : UIViewController

- (instancetype)initWithPayInfo:(NSDictionary *)payInfo
;
@end


//SPayViewController* pay = [[SPayViewController alloc]initWithNibName:@"SPayViewController" bundle:nil];
//pay.order_amount = order_amount;
//pay.order_id = order_id;
//pay.order_sn = order_sn;
//pay.order_price = orderPriceString;
//pay.isNowProduct = YES;
//[self.navigationController pushViewController:pay animated:YES];
