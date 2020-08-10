//
//  SurePlusButtonView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define PlusButtonWidth 30

#import "SurePlusButtonView.h"
#import "SureMenuButtonView.h"

@interface SurePlusButtonView()

{
    BOOL _isShowJiaHaoButton;
    UIImageView *_plusImage;
    SureMenuButtonView *_tlMenuView;
    
}

@property (nonatomic, strong) NSTimer *rippleTimer;

@end

@implementation SurePlusButtonView



- (instancetype)initAndAddSuperView:(UIView *)superView
{
    self = [super init];
    
    if (self)
    {
        self.frame = CGRectMake(ScreenWidth - 80, ScreenHeight - 49 - 80, 80, 80);
        self.backgroundColor = [UIColor clearColor];
        [superView addSubview:self];
        
        
        
        UIButton *jiaHaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        jiaHaoButton.backgroundColor = [UIColor clearColor];
        jiaHaoButton.frame = self.bounds;
        [jiaHaoButton addTarget:self action:@selector(jiaHaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jiaHaoButton];
        _isShowJiaHaoButton = NO;
        
        
        _plusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sure_Plus_Pressed"]];
        _plusImage.backgroundColor = RGBA(140, 53, 197,1);
        _plusImage.layer.cornerRadius = PlusButtonWidth / 2.0;
        _plusImage.clipsToBounds = YES;
        _plusImage.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - PlusButtonWidth , CGRectGetWidth(self.frame) - 20 - PlusButtonWidth , PlusButtonWidth, PlusButtonWidth);
        [self addSubview:_plusImage];
        
        
        SureMenuButtonView *tlMenuView =[SureMenuButtonView standardMenuView];
        tlMenuView.centerPoint = CGPointMake(_plusImage.center.x, _plusImage.center.y - 64);
        tlMenuView.buttonWidth = PlusButtonWidth + 20;
        __weak typeof(self) weakSelf = self;
        tlMenuView.clickAddButton = ^(NSInteger tag)
        {
            
            _isShowJiaHaoButton = YES;
            [weakSelf jiaHaoButtonClick:jiaHaoButton];
            
            /* contentType 0相册  1相机  2视频 */
            weakSelf.surePlusMenuButtonClick(tag - 1);

        };
        _tlMenuView = tlMenuView;

        
        [self startRippleAnimation];
        
    }
    
    return self;
}

- (void)jiaHaoButtonClick:(UIButton *)button
{
    
    UIView *sureView = button.superview.superview;
    UIView *sureNavBarView = [sureView viewWithTag:9856];
    
    _tlMenuView.frame = CGRectMake(0, sureNavBarView.frame.size.height, ScreenWidth, ScreenHeight - sureNavBarView.frame.size.height - 49);
    _tlMenuView.centerPoint = CGPointMake(self.center.x, self.center.y - sureNavBarView.frame.size.height);
    
    
    if (_isShowJiaHaoButton)
    {
        [UIView animateWithDuration:0.2 animations:^
         {
             CGAffineTransform rotate = CGAffineTransformMakeRotation( 0 );
             [_plusImage setTransform:rotate];
         }];
        [_tlMenuView dismiss];
        
    }
    else
    {
        [sureView addSubview:_tlMenuView];
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 4 );
            [_plusImage setTransform:rotate];
        }];
        [_tlMenuView showItems];
    }
    
    _isShowJiaHaoButton = !_isShowJiaHaoButton;
}

#pragma mark - Animation

- (void)startRippleAnimation
{
    [self closeRippleAnimation];
    
    self.rippleTimer = [NSTimer timerWithTimeInterval:.5f target:self selector:@selector(doBasicAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
}

- (void)closeRippleAnimation
{
    if (_rippleTimer)
    {
        if ([_rippleTimer isValid])
        {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

- (void)doBasicAnimation
{
    CGFloat start_X = PlusButtonWidth * 1;
    CGFloat start_Y = PlusButtonWidth * 1;
    
    start_X = CGRectGetWidth(self.frame) - 20 - PlusButtonWidth;
    start_Y = start_X;
    
    CGFloat animationDuration = 1.5;
    
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.bounds = CGRectMake(0, 0, PlusButtonWidth * 3, PlusButtonWidth * 3);
    rippleLayer.position = _plusImage.center;
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(start_X, start_Y, PlusButtonWidth, PlusButtonWidth)];
    
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = RGBA(140, 53, 197,1).CGColor;//指定path的渲染颜色
    rippleLayer.lineWidth = 1.5;//线的宽度
    rippleLayer.fillColor = RGBA(140, 53, 197,1).CGColor;//设置填充颜色
    [self.layer insertSublayer:rippleLayer below:_plusImage.layer];
    
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(start_X, start_Y, PlusButtonWidth, PlusButtonWidth)];
    CGRect endRect = CGRectInset([self makeEndRectWithStart_X:start_Y Start_Y:start_X], -5, -5);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = animationDuration;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = animationDuration;
    
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:animationDuration];
}

- (CGRect)makeEndRectWithStart_X:(CGFloat)start_X  Start_Y:(CGFloat)start_Y
{
    CGRect endRect = CGRectMake(start_X, start_Y, PlusButtonWidth, PlusButtonWidth);
    endRect = CGRectInset(endRect, -10, -10);
    return endRect;
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)sureViewAppear
{
    [self startRippleAnimation];
}

- (void)sureViewDisAppear
{
    [self closeRippleAnimation];
    
    if (_isShowJiaHaoButton)
    {
        [self jiaHaoButtonClick:nil];
    }

}


@end
