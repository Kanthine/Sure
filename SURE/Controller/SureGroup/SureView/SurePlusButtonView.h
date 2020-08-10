//
//  SurePlusButtonView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurePlusButtonView : UIView

- (instancetype)initAndAddSuperView:(UIView *)superView;

- (void)sureViewAppear;

- (void)sureViewDisAppear;

@property (nonatomic ,copy) void(^ surePlusMenuButtonClick)(NSInteger contentType);


@end
