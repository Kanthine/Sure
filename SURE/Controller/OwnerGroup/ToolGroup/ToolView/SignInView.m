//
//  SignInView.m
//  SURE
//
//  Created by 王玉龙 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//
#define AnimationDuration 0.2
#define TopSpace 90.0

#import "SignInView.h"

#import <Masonry.h>

#import "ShareViewController.h"
#import "ShareView.h"

@interface SignInView()


/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation SignInView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {

        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        _coverButton = button;
    }
    
    return _coverButton;
}

- (UIView *)contentView
{
    if (_contentView == nil)
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        
        CGFloat width = ScreenWidth - 60;
        CGFloat height = width * 1051.0 / 800.0;
        
        view.frame = CGRectMake(30, - height, width, height);
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"owner_SignIn"]];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, width, height);
        [view addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 682.0 / 1051.0 * height, width - 80, 180.0 / 1051.0 * height)];
        lable.numberOfLines = 0;
        lable.text = @"签到获得 8 SURE币，分享可获得更多SURE币。";
        lable.textColor = [UIColor redColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:15];
        [view addSubview:lable];
        
        
        
        CGFloat buttonHeight = 660 / 1051.0 * height;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, ScreenWidth, buttonHeight);
        [view addSubview:button];

        CGFloat shareButtonHeight = 250 / 1051.0 * height;
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.backgroundColor = [UIColor clearColor];
        [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        shareButton.frame = CGRectMake(0, height - shareButtonHeight, ScreenWidth, shareButtonHeight);
        [view addSubview:shareButton];

        

        _contentView = view;
    }
    
    return _contentView;
}



// 出现
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame) + 20 + TopSpace);
         self.coverButton.alpha = 0.3;
     } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:AnimationDuration animations:^
          {
              self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame) - 10 + TopSpace);
          } completion:^(BOOL finished)
          {
              [UIView animateWithDuration:AnimationDuration animations:^
               {
                   self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.contentView.frame) + TopSpace);
               }];
          }];
     }];
}

// 消失
- (void)dismissPickerView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.contentView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(self.contentView.frame));
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished)
     {
         [self.contentView removeFromSuperview];
         [self.coverButton removeFromSuperview];
         [self removeFromSuperview];
     }];
}

- (void)shareButtonClick
{
    NSString* thumbURL =  @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *descr = @"SURE 的详细介绍";
    __block NSString *imageStr = @"";

    ShareView *shareView = [[ShareView alloc]initWithLinkUrl:thumbURL imageUrlStr:imageStr Descr:descr];
    [self addSubview:shareView];
    [shareView showPlatView];
}



@end
