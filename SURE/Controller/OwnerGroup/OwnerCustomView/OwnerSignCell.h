//
//  OwnerSignCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerSignCell : UITableViewCell

@property (nonatomic ,copy) void(^ ownerSignCellButtonClick)(NSInteger index);

@end
