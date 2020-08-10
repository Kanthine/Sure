//
//  MySureHeaderView.h
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MySureHeaderCountView.h"

@interface MySureHeaderView : UIView

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *signNameLable;
@property (strong ,nonatomic) MySureHeaderCountView *countView;

@property (strong, nonatomic) UIButton *optionButton;


- (instancetype)initWithFrame:(CGRect)frame IsMy:(BOOL)isMy;

- (CGFloat )updateUIGetHeight;


@end
