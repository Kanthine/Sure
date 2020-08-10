//
//  MySureHeaderCountView.m
//  SURE
//
//  Created by 王玉龙 on 17/1/3.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "MySureHeaderCountView.h"

#import <Masonry.h>

@interface MySureHeaderCountView()



@end


@implementation MySureHeaderCountView


- (instancetype)init
{
    self = [super init];
    
    
    if (self)
    {        
        
        UILabel *tipTapedCountLable = [[UILabel alloc]init];
        tipTapedCountLable.textColor = RGBA(120, 0, 191, 1);
        tipTapedCountLable.font = [UIFont systemFontOfSize:14];
        tipTapedCountLable.textAlignment = NSTextAlignmentLeft;
        tipTapedCountLable.text = @"被赞数";
        [self addSubview:tipTapedCountLable];
        CGFloat tipLableWidth = [tipTapedCountLable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : tipTapedCountLable.font} context:nil].size.width;
        tipLableWidth = tipLableWidth + 5.0;
        
        UILabel *tipFansCountLable = [[UILabel alloc]init];
        tipFansCountLable.textColor = RGBA(120, 0, 191, 1);
        tipFansCountLable.font = [UIFont systemFontOfSize:14];
        tipFansCountLable.textAlignment = NSTextAlignmentCenter;
        tipFansCountLable.text = @"粉丝数";
        [self addSubview:tipFansCountLable];
        
        UILabel *tipOptionCountLable = [[UILabel alloc]init];
        tipOptionCountLable.textColor = RGBA(120, 0, 191, 1);
        tipOptionCountLable.font = [UIFont systemFontOfSize:14];
        tipOptionCountLable.textAlignment = NSTextAlignmentRight;
        tipOptionCountLable.text = @"关注";
        [self addSubview:tipOptionCountLable];
        
        

        
        
        [self addSubview:self.tapedCountLable];
        [self addSubview:self.fansCountLable];
        [self addSubview:self.optionCountLable];
        
        
        
        [self addSubview:self.tapedButton];
        [self addSubview:self.fansButton];
        [self addSubview:self.optionButton];

        
        // 约束
        
        __weak __typeof__(self) weakSelf = self;
        [tipTapedCountLable mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.mas_equalTo(@0);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@(tipLableWidth));
            make.bottom.mas_equalTo(@0);
        }];
        [tipFansCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(tipTapedCountLable);
             make.centerX.equalTo(weakSelf);
             make.height.mas_equalTo(@20);
             make.width.mas_equalTo(@(tipLableWidth));
         }];
        [tipOptionCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(tipTapedCountLable);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@20);
         }];
        
        
        [self.tapedCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.centerX.equalTo(tipTapedCountLable);
             make.height.mas_equalTo(@20);
             make.width.mas_equalTo(@(tipLableWidth));
         }];
        [self.fansCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf.tapedCountLable);
             make.centerX.equalTo(tipFansCountLable);
             make.height.mas_equalTo(@20);
         }];
        [self.optionCountLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf.tapedCountLable);
             make.centerX.equalTo(tipOptionCountLable);
             make.height.mas_equalTo(@20);
         }];
        
        
        
        [self.tapedButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
        [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
//             make.left.equalTo(weakSelf.tapedButton).right.with.offset(0);
             make.left.equalTo(weakSelf.tapedButton.mas_right).with.offset(0);
             make.bottom.mas_equalTo(@0);
             make.width.equalTo(weakSelf.tapedButton.mas_width);
         }];
        [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
//             make.left.equalTo(weakSelf.fansButton).right.with.offset(0);

             make.left.equalTo(weakSelf.fansButton.mas_right).with.offset(0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.width.equalTo(weakSelf.fansButton.mas_width);
         }];
    }
    
    
    return self;
}



- (UILabel *)tapedCountLable
{
    if (_tapedCountLable == nil)
    {
        _tapedCountLable = [[UILabel alloc]init];
        _tapedCountLable.textColor = RGBA(120, 0, 191, 1);
        _tapedCountLable.font = [UIFont systemFontOfSize:14];
        _tapedCountLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tapedCountLable;
}

- (UILabel *)fansCountLable
{
    if (_fansCountLable == nil)
    {
        _fansCountLable = [[UILabel alloc]init];
        _fansCountLable.textColor = RGBA(120, 0, 191, 1);
        _fansCountLable.font = [UIFont systemFontOfSize:14];
        _fansCountLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _fansCountLable;
}

- (UILabel *)optionCountLable
{
    if (_optionCountLable == nil)
    {
        _optionCountLable = [[UILabel alloc]init];
        _optionCountLable.textColor = RGBA(120, 0, 191, 1);
        _optionCountLable.font = [UIFont systemFontOfSize:14];
        _optionCountLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _optionCountLable;
}

- (UIButton *)tapedButton
{
    if (_tapedButton == nil)
    {
        _tapedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapedButton.adjustsImageWhenDisabled = NO;
        _tapedButton.adjustsImageWhenHighlighted = NO;
    }
    
    return _tapedButton;
}

- (UIButton *)fansButton
{
    if (_fansButton == nil)
    {
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansButton.adjustsImageWhenDisabled = NO;
        _fansButton.adjustsImageWhenHighlighted = NO;
    }
    
    return _fansButton;
}

- (UIButton *)optionButton
{
    if (_optionButton == nil)
    {
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionButton.adjustsImageWhenDisabled = NO;
        _optionButton.adjustsImageWhenHighlighted = NO;
    }
    
    return _optionButton;
}


@end
