//
//  KindListVC.h
//  SURE
//
//  Created by 王玉龙 on 16/10/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

@interface KindListVC : BaseViewController

- (instancetype)initWithModel:(KindModel *)model;

@property (nonatomic ,assign) BOOL isBrandTagChoose;

@property (nonatomic ,copy) void(^ didSelectKindListCommodity)(NSString *brandString,NSString *brandIDStr,NSString *goodIDString);

@end
