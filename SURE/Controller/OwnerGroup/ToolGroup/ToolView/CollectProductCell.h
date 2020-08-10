//
//  CollectProductCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectProductVC;

@interface CollectProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;


@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (nonatomic ,strong) CollectProductVC *currentVC;

- (void)updateCellInfoWithProductModel:(CollectProductModel *)product;



@end
