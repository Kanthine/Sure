//
//  OrderDetaileProductView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define LableFountSize 13



#import <UIKit/UIKit.h>

@interface OrderDetaileProductView : UIView

- (instancetype)initWithFrame:(CGRect)frame ProductModel:(OrderProductModel *)model;

@property (nonatomic ,strong) UIButton *refundButton;

@end
