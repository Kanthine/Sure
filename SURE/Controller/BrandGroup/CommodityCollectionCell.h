//
//  CommodityCollectionCell.h
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLable;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLable;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;

- (void)updateCommodityInfo:(ProductModel *)model;

@end
