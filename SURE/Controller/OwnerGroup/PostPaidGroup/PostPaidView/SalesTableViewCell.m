//
//  SalesTableViewCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SalesTableViewCell.h"

@implementation SalesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCellData:(NSDictionary *)dict
{
//    self.nameLable.text = [dict objectForKey:@""];
    self.idLable.text = [dict objectForKey:@"ID"];
    self.statusLable.text = [dict objectForKey:@"status"];
    self.priceLable.text = [dict objectForKey:@"price"];
}


@end
