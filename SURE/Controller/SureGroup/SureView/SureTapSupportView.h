//
//  SureTapSupportView.h
//  SURE
//
//  Created by 王玉龙 on 16/10/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureTapSupportView : UIView

@property (nonatomic ,strong) UIButton *pushSupportButton;

- (void)updateTapViewWithCount:(NSString *)tapCountString HeaderArray:(NSArray<NSString *> *)headerArray;

@end
