//
//  MenuOrderButton.h
//  SURE
//
//  Created by 王玉龙 on 16/11/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, MenuOrderButtonState)
{
    MenuOrderButtonStateDefault = 0,//默认
    MenuOrderButtonStateUp,//上
    MenuOrderButtonStateDown,//下
};

@class MenuOrderButton;
@protocol MenuOrderButtonDelegate <NSObject>

@required

- (void)switchOrder:(MenuOrderButton *)customButton;


@end


@interface MenuOrderButton : UIView

@property (nonatomic, assign ,readonly) MenuOrderButtonState orderState;
@property (nonatomic ,assign) BOOL isSelected;
@property (nonatomic ,assign) id <MenuOrderButtonDelegate> delegate;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,copy ,readonly) NSString *orderString;//排序
@property (nonatomic ,assign ,readonly) BOOL isNeedOrder;//是否需要排序
@property (nonatomic ,copy ) NSString *orderByString;//分类名字

- (instancetype)initWithFrame:(CGRect)frame ButtonTitle:(NSString *)titleString IsNeedOrder:(BOOL)isOrder;

@end
