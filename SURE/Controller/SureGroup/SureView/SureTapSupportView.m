//
//  SureTapSupportView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define HeaderImageWidth 20.0

#import "SureTapSupportView.h"
#import <Masonry.h>

@interface SureTapSupportView()

@property (nonatomic ,strong) UILabel *tapCountLable;
@property (nonatomic ,strong) UIImageView *tapImageView;
@property (nonatomic ,strong) UIView *tapHeaderView;

@end

@implementation SureTapSupportView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.tapImageView];
        [self addSubview:self.tapCountLable];
        [self addSubview:self.tapHeaderView];
        [self addSubview:self.pushSupportButton];
        
        __weak __typeof__(self) weakSelf = self;
        [self.tapImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.equalTo(weakSelf);
            make.left.mas_equalTo(@10);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
        
        [self.tapCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.equalTo(weakSelf.tapImageView.mas_right).with.offset(5);
             make.height.mas_equalTo(@15);
         }];

        [self.tapHeaderView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.equalTo(weakSelf.tapCountLable.mas_right).with.offset(5);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@HeaderImageWidth);
         }];
        
        [self.pushSupportButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UIImageView *)tapImageView
{
    if (_tapImageView == nil)
    {
        _tapImageView = [[UIImageView alloc]init];//15宽度
        _tapImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tapImageView.image = [UIImage imageNamed:@"sure_TapSupport_Black"];
        _tapImageView.clipsToBounds = YES;
    }
    
    return _tapImageView;
}

- (UILabel *)tapCountLable
{
    if (_tapCountLable == nil)
    {
        _tapCountLable = [[UILabel alloc]init];
        _tapCountLable.textAlignment = NSTextAlignmentCenter;
        _tapCountLable.font = [UIFont systemFontOfSize:14];
    }
    
    return _tapCountLable;
}

- (UIView *)tapHeaderView
{
    if (_tapHeaderView == nil)
    {
        _tapHeaderView = [[UIView alloc]init];
    }
    return _tapHeaderView;
}

- (UIButton *)pushSupportButton
{
    if (_pushSupportButton == nil)
    {
        _pushSupportButton = [[UIButton alloc] init];
        _pushSupportButton.backgroundColor = [UIColor clearColor];
    }
    
    return _pushSupportButton;
}

- (void)updateTapViewWithCount:(NSString *)tapCountString HeaderArray:(NSArray<NSString *> *)headerArray
{
    _tapCountLable.text = [NSString stringWithFormat:@"%@次点赞",tapCountString];
    
    [_tapHeaderView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [obj removeFromSuperview];
    }];
    
    
    [headerArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (idx > 5)
        {
            * stop = YES;
        }
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(( HeaderImageWidth + 5 ) * idx, 0, HeaderImageWidth, HeaderImageWidth)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        imageView.layer.cornerRadius = HeaderImageWidth /2.0;
        imageView.clipsToBounds = YES;
        [_tapHeaderView addSubview:imageView];
    }];
    
}

@end
