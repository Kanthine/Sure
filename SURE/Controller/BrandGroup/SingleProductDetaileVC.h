//
//  SingleProductDetaileVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define FlashImageHeight (ScreenWidth * 240.0 / 414.0)


#import "BaseViewController.h"

@interface SingleProductDetaileVC : BaseViewController


@property (nonatomic ,copy) NSString *goodIDString;


- (instancetype)initWithCommodityModel:(ProductModel *)singleProduct;


@end
