//
//  OwnerOrderCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerOrderCell : UITableViewCell

@property (nonatomic ,copy) void(^ ownerOrderCellButtonClick)(NSInteger index);

@end