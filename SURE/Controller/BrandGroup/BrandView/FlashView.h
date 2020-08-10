//
//  FlashView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,FlashViewModelType)
{
    FlashViewModelTypeBrand = 0,
    FlashViewModelTypeProduct
};

@interface FlashView : UIView

@property(nonatomic ,strong)UIViewController *currentViewController;

@property(nonatomic,strong)NSArray *flashModelArray;

@property (nonatomic ,assign) FlashViewModelType flashType;

-(instancetype)initWithFrame:(CGRect)frame;

@end
