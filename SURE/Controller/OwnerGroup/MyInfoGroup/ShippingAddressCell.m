//
//  ShippingAddressCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShippingAddressCell.h"



@implementation ShippingAddressCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)updateAdressDetaileInfoWithIndexPath:(NSIndexPath *)indexPath ShippingModel:(ShippingAddressModel *)addressModel
{
    NSLog(@"addressModel ====== %@",addressModel);
    
    
    if (addressModel == nil)
    {
        _nameLable.text = @"你还没有地址，请您点击此处添加收货地址";
        _phoneLable.text = @"";
        _addressLable.text = @"";
    }
    else
    {
        _nameLable.text = addressModel.nameString;
        _phoneLable.text = addressModel.phoneString;
        _addressLable.text = addressModel.provinceCityName;

    }
    
}



@end
