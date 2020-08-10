//
//  LeftBackItem.m
//  SURE
//
//  Created by 王玉龙 on 16/11/25.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "LeftBackItem.h"

@interface LeftBackItem ()

@property (nonatomic ,strong) UIButton *backButton;

@end

@implementation LeftBackItem

- (instancetype)initWithTarget:(UIViewController *)target Selector:(SEL)method
{
    
    self = [super initWithCustomView:self.backButton];
    
    if (self)
    {
        target.navigationController.interactivePopGestureRecognizer.delegate = target;

        [_backButton addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
    
}

- (UIButton *)backButton
{
    if (_backButton == nil)
    {
        _backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 50)];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_backButton setImage:[UIImage imageNamed:@"navBar_LeftButton"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Pressed"] forState:UIControlStateHighlighted];
    }
    
    
    return _backButton;
}



- (void)setNormalImage:(UIImage *)normalImage
{
    [_backButton setImage:normalImage forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    [_backButton setImage:highlightedImage forState:UIControlStateHighlighted];
}

@end
