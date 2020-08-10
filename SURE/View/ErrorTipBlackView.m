//
//  ErrorTipBlackView.m
//  SURE
//
//  Created by 王玉龙 on 17/2/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ErrorTipBlackView.h"
#import "AppDelegate.h"

@interface ErrorTipBlackView()

@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) UILabel *tipLable;

@end

@implementation ErrorTipBlackView

+ (void)errorTip:(NSString *)errorString SuperView:(UIView *)superView
{
    ErrorTipBlackView *tipView = [[ErrorTipBlackView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) ErrorTip:errorString];
    
    if (superView)
    {
        [superView addSubview:tipView];
    }
    else
    {
        [APPDELEGETE.window addSubview:tipView];
    }
    
    [tipView performSelector:@selector(removeMySelfFromSuperview) withObject:nil afterDelay:2];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame ErrorTip:(NSString *)errorString
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tipLable];
        self.tipLable.text = errorString;
        
        
        CGSize tipTextSize = [self.tipLable.text boundingRectWithSize:CGSizeMake(ScreenWidth - 30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tipLable.font} context:nil].size;
        self.tipLable.frame = CGRectMake(0, 0, tipTextSize.width + 20, tipTextSize.height + 20);
        self.tipLable.center = self.center;
        
        [self addSubview:self.backButton];
        
    }
    
    return self;
}

- (UILabel *)tipLable
{
    if (_tipLable == nil)
    {
        _tipLable = [[UILabel alloc]init];
        _tipLable.clipsToBounds = YES;
        _tipLable.layer.cornerRadius = 5;
        _tipLable.textColor = [UIColor whiteColor];
        _tipLable.textAlignment = NSTextAlignmentCenter;
        _tipLable.font = [UIFont systemFontOfSize:15];
        _tipLable.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
        _tipLable.numberOfLines = 0;
    }
    
    return _tipLable;
}

- (UIButton *)backButton
{
    if (_backButton == nil)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(removeMySelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (void)removeMySelfFromSuperview
{
    [self removeFromSuperview];
}

@end
