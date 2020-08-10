//
//  ShippingAddressCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *phoneLable;

@property (weak, nonatomic) IBOutlet UILabel *addressLable;

- (void)updateAdressDetaileInfoWithIndexPath:(NSIndexPath *)indexPath ShippingModel:(ShippingAddressModel *)addressModel;

@end
