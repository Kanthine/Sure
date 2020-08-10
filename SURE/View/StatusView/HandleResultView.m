//
//  HandleResultView.m
//  SURE
//
//  Created by 王玉龙 on 17/1/9.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "HandleResultView.h"

@implementation HandleResultView

static CGFloat const AnimationDuration = 0.2;

- (instancetype)initWithIsFinish:(BOOL)isFinish Title:(NSString *)title
{
    self = [super init];
    
    if (self)
    {
        CGFloat myWidth = 120.0;
        
        self.backgroundColor = RGBA(51, 51, 51, 0.95);
        self.frame = CGRectMake((ScreenWidth - myWidth) / 2.0, (ScreenHeight - myWidth) / 2.0, myWidth, myWidth);
        
        UIImage *image = nil;
        
        if (isFinish)
        {
            image = [UIImage imageNamed:@"finish_Correct"];
        }
        else
        {
            image = [UIImage imageNamed:@"finish_Error"];
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(35, 35, 50, 50);
        [self addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, myWidth, 20)];
        lable.text = title;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
    }
    
    return self;
}

- (void)showToSuperView:(UIView *)superView
{
    [superView addSubview:self];
    
    self.backgroundColor = RGBA(51, 51, 51, 0.0);
    
    self.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    
    [UIView animateWithDuration:AnimationDuration animations:^
    {
        self.backgroundColor = RGBA(51, 51, 51, 0.95);
        self.transform=CGAffineTransformMakeScale(1.0f, 1.0f);

        
    } completion:^(BOOL finished)
    {
        [self performSelector:@selector(dismissViewFromSuperView) withObject:nil afterDelay:1.3];
    }];
    
    
}

- (void)dismissViewFromSuperView
{
    [UIView animateWithDuration:AnimationDuration animations:^
     {
         self.backgroundColor = RGBA(51, 51, 51, 0.0);
         self.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
         
     } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
    
    
}


@end
