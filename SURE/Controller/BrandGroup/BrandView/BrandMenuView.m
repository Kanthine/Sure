//
//  BrandMenuView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BrandMenuView.h"


#import "MenuOrderButton.h"

@interface BrandMenuView()
<MenuOrderButtonDelegate>


@end


@implementation BrandMenuView

//高 40
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray *segmentedTitleArray = [NSMutableArray arrayWithObjects:@"综合",@"价格",@"新品",@"SURE", nil];
        NSMutableArray *segmentedOrderArray = [NSMutableArray arrayWithObjects:@"click_count",@"shop_price",@"add_time",@"SURE", nil];
        CGFloat segmentedButtonWidth = ScreenWidth / segmentedOrderArray.count * 1.00;
        for (int i = 0; i < segmentedTitleArray.count; i ++)
        {
            BOOL isOrder = i == 1 ? YES : NO;//是否需要排序
            
            MenuOrderButton *button = [[MenuOrderButton alloc]initWithFrame:CGRectMake(segmentedButtonWidth * i, 0, segmentedButtonWidth, CGRectGetHeight(frame)) ButtonTitle:segmentedTitleArray[i] IsNeedOrder:isOrder];
            [self  addSubview:button];
            button.index = i;
            button.delegate = self;
            button.isSelected = i == 0 ? YES : NO;
            button.orderByString = segmentedOrderArray[i];
        }
        
        
        UILabel *grayLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        grayLable1.backgroundColor = GrayColor;
        [self addSubview:grayLable1];
        UILabel *grayLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        grayLable2.backgroundColor = GrayColor;
        [self addSubview:grayLable2];
        
        UILabel *currentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 2, segmentedButtonWidth, 2)];
        currentLable.tag = 9;
        currentLable.backgroundColor = RGBA(141, 31, 203,1);
        [self addSubview:currentLable];
    }
    
    return self;
}

- (void)switchOrder:(MenuOrderButton *)customButton
{
    
    if (customButton.isSelected == YES && customButton.isNeedOrder == NO)
    {
        //原本被选中，不需要排序
        [self menuButtonClick:NO OrderStr:customButton.orderByString Des:customButton.orderString];
    }
    else if (customButton.isSelected == YES && customButton.isNeedOrder == YES)
    {
        //原本被选中，需要排序
        [self menuButtonClick:YES OrderStr:customButton.orderByString Des:customButton.orderString];
    }
    else if (customButton.isSelected == NO && customButton.isNeedOrder == NO)
    {
        //原本不被选中，不需要排序
        
        [self updateUIWithIndex:customButton.index];
        
        [self menuButtonClick:YES OrderStr:customButton.orderByString Des:customButton.orderString];

    }
    else if (customButton.isSelected == NO && customButton.isNeedOrder == YES)
    {
        //原本不被选中，需要排序
        [self updateUIWithIndex:customButton.index];
        
        [self menuButtonClick:YES OrderStr:customButton.orderByString Des:customButton.orderString];
        
    }
}

- (void)menuButtonClick:(BOOL)isRequest OrderStr:(NSString *)orderByStr Des:(NSString *)desc
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(brandMenuViewButtonClick:OrderStr:Des:)])
//    {
//        [self.delegate brandMenuViewButtonClick:isRequest OrderStr:orderByStr Des:desc];
//    }
//    
    _brandMenuViewButtonClick(isRequest,orderByStr,desc);

}


- (void)updateUIWithIndex:(NSInteger )currentIndex
{
    MenuOrderButton *currentButton = nil;
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[MenuOrderButton class]])
        {
            MenuOrderButton*button = (MenuOrderButton *)view;
            
            if (button.index == currentIndex)
            {
                currentButton = button;
                button.isSelected = YES;
            }
            else
            {
                button.isSelected = NO;
            }
        }
    }

    
    
    CGFloat segmentedButtonWidth = ScreenWidth / 4.0;
    UILabel *currentLable = [self viewWithTag:9];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    CGRect frame = currentLable.frame;
    frame.origin.x =  segmentedButtonWidth * currentIndex;
    currentLable.frame = frame;
    [UIView commitAnimations];
}


@end
