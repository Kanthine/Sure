//
//  OwnerCustomButton.h
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OwnerCustomButtonDelegate <NSObject>

@required

- (void)ownerCustomButtonClick:(NSInteger)index;

@end

@interface OwnerCustomButton : UIView

@property (nonatomic ,weak) id <OwnerCustomButtonDelegate> delegate;

@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,strong) UILabel *titleLable;


- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageTitle:(NSString *)imageTitleString;

@end
