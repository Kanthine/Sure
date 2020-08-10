//
//  BrandTagViewController.h
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"


@protocol BrandTagViewControllerDelegate <NSObject>

@required

- (void)selectedBrandTagWithSign:(NSString *)brandString BrandID:(NSString *)brandIDStr GoodsID:(NSString *)goodIDString LocationPoint:(CGPoint)tapPoint;

@end

@interface BrandTagViewController : BaseViewController


@property (nonatomic ,weak) id <BrandTagViewControllerDelegate> delegate;
@property (nonatomic ,assign) CGPoint tapPoint;
@property (nonatomic ,strong) UIImageView *backImageView;

@end
