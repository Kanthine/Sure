//
//  ShippingAddressFooterView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingAddressFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic ,assign) NSInteger section;


@end
