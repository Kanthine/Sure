//
//  OwnerToolsCell.h
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerToolsCell : UITableViewCell

@property (nonatomic ,copy) void(^ ownerToolsCellButtonClick)(NSInteger index);


@end
