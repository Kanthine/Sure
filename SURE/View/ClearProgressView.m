//
//  ClearProgressView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define LOAD_WIDTH self.frame.size.width
#define LOAD_HEIGHT self.frame.size.height


#import "ClearProgressView.h"

@interface ClearProgressView ()

{
    NSTimer *_timer;
}

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ClearProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    if([super init])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if([super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}

/** 初始化数据*/
- (void)initData
{
    self.animationDuration = 1.0f;
    self.progressWidth = 3.0;
    self.progressColors = @[[UIColor darkGrayColor]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupLoadProgress];
}

#pragma mark -- 进度条
dispatch_source_t _timers;

- (void)setupLoadProgress
{
    //断言 当前面的表达式为假值时 打印后面的内容 但是程序还是会崩溃
    NSAssert(self.progressWidth > 0.0, @"进度条宽度必须大于0");
    NSAssert(self.progressColors.count > 0, @"重置的颜色数组不能为空");
    
    [self.layer removeAllAnimations];
    [self addAnimation];
    
    if(!_timer && self.progressColors.count > 1)
    {
        
        //GCD 计时器
        uint64_t interval = 1.0 * NSEC_PER_SEC;
        dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
        _timers = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timers, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        __weak ClearProgressView *blockSelf = self;
        dispatch_source_set_event_handler(_timers, ^()
       {
             [blockSelf changeProgressColor];
        });
         dispatch_resume(_timers);
        
        //NSThread 计时器
//        [NSThread detachNewThreadSelector:@selector(startTimer) toTarget:self withObject:nil];

//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeProgressColor:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeProgressColor:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)addAnimation
{
    //旋转z轴 使每次重合的位置不同
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @0.0;
    rotationAni.toValue = @(2 * M_PI);
    rotationAni.duration = 3;
    rotationAni.repeatCount = MAXFLOAT;
    [self.layer addAnimation:rotationAni forKey:@"roration"];
    
    //strokeEnd 正向画出路径
    CABasicAnimation *endAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue = @0.0;
    endAni.toValue = @1.0;
    endAni.duration = self.animationDuration;
    endAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //strokeStart 反向清除路径
    CABasicAnimation *startAni = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAni.fromValue = @0.0;
    startAni.toValue = @1.0;
    startAni.duration = self.animationDuration;
    startAni.beginTime = 1.0;
    startAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[endAni, startAni];
    group.repeatCount = MAXFLOAT;
    group.fillMode = kCAFillModeForwards;
    group.duration = 2*self.animationDuration;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.progressWidth, self.progressWidth, LOAD_WIDTH-self.progressWidth*2, LOAD_HEIGHT-self.progressWidth*2)];
    self.shapeLayer.path = path.CGPath;
    
    [self.shapeLayer addAnimation:group forKey:@"group"];
    [self.layer addSublayer:self.shapeLayer];
}

/**
 *  随机改变进度条的颜色
 */
- (void)changeProgressColor:(NSTimer *)timer
{
    CGColorRef color = [self.progressColors[arc4random()%self.progressColors.count] CGColor];
    self.shapeLayer.strokeColor = color;
}

- (void)changeProgressColor
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        CGColorRef color = [self.progressColors[arc4random()%self.progressColors.count] CGColor];
        self.shapeLayer.strokeColor = color;
    });
}

#pragma mark -- 进入前台或活跃状态

- (void)addNotificationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- getter

- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = self.progressWidth;
        _shapeLayer.strokeColor = ((UIColor *)self.progressColors[0]).CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeStart = 0.0;
        _shapeLayer.strokeEnd = 1.0;
    }
    return _shapeLayer;
}

@end
