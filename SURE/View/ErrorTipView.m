//
//  ErrorTipView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ErrorTipView.h"

@implementation ErrorTipView

- (instancetype)initWithTipString:(NSString *)string frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pwdErrorTip"]];
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:imageView];
        
        
        UILabel *tipLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 25, CGRectGetWidth(frame), 25)];
        tipLable.text = string;
        tipLable.textColor = [UIColor redColor];
        tipLable.font = [UIFont systemFontOfSize:15];
        tipLable.textAlignment = NSTextAlignmentCenter;
        tipLable.backgroundColor = [UIColor clearColor];
        [self addSubview:tipLable];
        
    }
        
    return self;
}

- (void)showInView:(UIView *)superView ShowDuration:(CGFloat)interval
{
    [superView addSubview:self];
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(removeTipView) userInfo:nil repeats:NO];
}

- (void)removeTipView
{
    [self removeFromSuperview];
}

@end
