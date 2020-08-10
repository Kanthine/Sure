//
//  LoginThirdPartyCoverView.m
//  SURE
//
//  Created by 王玉龙 on 17/1/4.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "LoginThirdPartyCoverView.h"

@interface LoginThirdPartyCoverView()

@property (nonatomic ,strong) UIImageView *backImageView;
@property (nonatomic ,strong) UIImageView *iconImageView;

@end


@implementation LoginThirdPartyCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        
        [self addSubview:self.backImageView];
        [self addSubview:self.iconImageView];
    }
    
    return self;
}


- (void)showInView:(UIView *)superView
{
    [self addSubview:superView];
    [self startAnimation];
}

- (void)dismissFromSuperView
{
    [self stopanimation];
    
    [self removeFromSuperview];
}

- (UIImageView *)backImageView
{
    if (_backImageView == nil)
    {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
        _backImageView.alpha = .7f;
        _backImageView.center = self.center;
        _backImageView.image = [UIImage imageNamed:@"iconBack"];
    }
    
    return _backImageView;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 21)];
        _iconImageView.center = self.center;
        _iconImageView.alpha = .7f;
        _iconImageView.image = [UIImage imageNamed:@"iconTop"];

    }
    
    return _iconImageView;
}


- (void)startAnimation
{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = @(0.0f);
    animation.toValue   = @(M_PI * 2.0);
    animation.duration  = 1.2f;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 500;
    [_iconImageView.layer addAnimation:animation forKey:@"loginRotationAnimation"];
}

- (void)stopanimation
{
    [_iconImageView.layer removeAnimationForKey:@"loginRotationAnimation"];
}

@end
