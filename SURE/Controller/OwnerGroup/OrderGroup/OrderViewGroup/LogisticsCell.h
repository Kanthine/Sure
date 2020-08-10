//
//  LogisticsCell.h
//  SURE
//
//  Created by 王玉龙 on 16/11/30.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZLinkLabel.h"



@interface LogisticsCell : UITableViewCell

@property (strong, nonatomic)  UIView *middleLineView;
@property (strong, nonatomic)  UIView *currentLineView;

@property (strong, nonatomic)  KZLinkLabel *linkLable;
@property (strong, nonatomic)  UILabel *timeLable;


- (void)updateLogisticsCellData;

@end
