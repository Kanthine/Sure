//
//  SureMenuButtonView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureMenuButtonView : UIView

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic ,assign) CGFloat buttonWidth;

- (void)showItems;

- (void)dismiss;

- (void)dismissAtNow;

@property (nonatomic, copy) void (^clickAddButton)(NSInteger index);

+ (instancetype)standardMenuView;

@end
