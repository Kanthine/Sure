//
//  VideoPregressBar.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "VideoPregressBar.h"

#import "FilePathManager.h"

#define BAR_H 10
#define BAR_MARGIN 2

#define INDICATOR_W 16
#define INDICATOR_H 14

#define TIMER_INTERVAL 1.0f

@interface VideoPregressBar ()

@property (strong, nonatomic) NSMutableArray *progressViewArray;

@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) UIImageView *progressIndicator;

@property (strong, nonatomic) NSTimer *shiningTimer;

@end

@implementation VideoPregressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = RGBA(11, 11, 11,1);
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, BAR_MARGIN, ScreenWidth, BAR_H)];
    _barView.backgroundColor = RGBA(38, 38, 38,1);
    [self addSubview:_barView];
    
    //最短分割线
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, BAR_H)];
    intervalView.backgroundColor = [UIColor blackColor];
    [_barView addSubview:intervalView];
    
    //indicator
    self.progressIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_W, INDICATOR_H)];
    _progressIndicator.backgroundColor = [UIColor clearColor];
    _progressIndicator.image = [UIImage imageNamed:@"record_progressbar_front.png"];
    _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
    [self addSubview:_progressIndicator];
}

- (UIView *)getProgressView
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, BAR_H)];
    progressView.backgroundColor = RGBA(68, 214, 254,1);
    progressView.autoresizesSubviews = YES;
    
    return progressView;
}

- (void)refreshIndicatorPosition
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        _progressIndicator.center = CGPointMake(0, self.frame.size.height / 2);
        return;
    }
    
    _progressIndicator.center = CGPointMake(MIN(lastProgressView.frame.origin.x + lastProgressView.frame.size.width, self.frame.size.width - _progressIndicator.frame.size.width / 2 + 2), self.frame.size.height / 2);
}

- (void)onTimer:(NSTimer *)timer
{
    [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
        _progressIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TIMER_INTERVAL / 2 animations:^{
            _progressIndicator.alpha = 1;
        }];
    }];
}

#pragma mark - method
- (void)startShining
{
    self.shiningTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)stopShining
{
    [_shiningTimer invalidate];
    self.shiningTimer = nil;
    _progressIndicator.alpha = 1;
}

- (void)addProgressView
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= 1;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + 1;
    }
    
    UIView *newProgressView = [self getProgressView];
    [VideoPregressBar setView:newProgressView toOriginX:newProgressX];
    
    [_barView addSubview:newProgressView];
    
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastProgressToWidth:(CGFloat)width
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [VideoPregressBar setView:lastProgressView toSizeWidth:width];
    [self refreshIndicatorPosition];
}

- (void)setLastProgressToStyle:(VideoPregressBarStyle)style
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    switch (style) {
        case VideoPregressBarStyleDelete:
        {
            lastProgressView.backgroundColor = RGBA(224, 66, 39,1);
            _progressIndicator.hidden = YES;
        }
            break;
        case VideoPregressBarStyleNormal:
        {
            lastProgressView.backgroundColor = RGBA(68, 214, 254,1);
            _progressIndicator.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)deleteLastProgress
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
    _progressIndicator.hidden = NO;
    
    [self refreshIndicatorPosition];
}

+ (VideoPregressBar *)getInstance
{
    VideoPregressBar *progressBar = [[VideoPregressBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BAR_H + BAR_MARGIN * 2)];
    return progressBar;
}

+ (void)setView:(UIView *)view toSizeWidth:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginX:(CGFloat)x
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOriginY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

+ (void)setView:(UIView *)view toOrigin:(CGPoint)origin
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}


@end
