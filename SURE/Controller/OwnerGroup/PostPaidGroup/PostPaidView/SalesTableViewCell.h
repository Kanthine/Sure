//
//  SalesTableViewCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *idLable;
@property (weak, nonatomic) IBOutlet UILabel *statusLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

- (void)refreshCellData:(NSDictionary *)dict;

@end
