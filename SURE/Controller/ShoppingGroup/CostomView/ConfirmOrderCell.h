//
//  ConfirmOrderCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *kindLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;

- (void)updateConfirmOrderWithProduct:(CommodityInfoModel *)product;

@end
