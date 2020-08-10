//
//  OwnerHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define OwnerHeaderViewHeight 120.0

#import <UIKit/UIKit.h>

@interface OwnerHeaderView : UIView


@property (nonatomic ,weak) UIViewController *currentViewController;

@property (nonatomic ,copy) void(^ ownerHeaderViewPersonalButtonClick)();
@property (nonatomic ,copy) void(^ ownerHeaderViewSupportedButtonClick)();
@property (nonatomic ,copy) void(^ ownerHeaderViewFansCountButtonClick)();
@property (nonatomic ,copy) void(^ ownerHeaderViewOptionButtonClick)();

- (void)updateMyInfo;

@end
