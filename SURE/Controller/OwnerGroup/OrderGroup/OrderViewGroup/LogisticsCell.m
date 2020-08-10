//
//  LogisticsCell.m
//  SURE
//
//  Created by 王玉龙 on 16/11/30.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "LogisticsCell.h"

#import "Masonry.h"

@interface LogisticsCell()


@end

@implementation LogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"LogisticsCell"];
    
    
    if (self)
    {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
        
        
        
        [self.contentView addSubview:self.middleLineView];
        [self.contentView addSubview:self.currentLineView];
        [self.contentView addSubview:self.linkLable];
        [self.contentView addSubview:self.timeLable];
        
        [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.width.mas_equalTo(@50);
         }];
        
        [self.currentLineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.width.mas_equalTo(@50);
         }];
        
        [self.linkLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(10);
             make.left.equalTo(_currentLineView.mas_right).with.offset(0);
             make.right.mas_equalTo(@10);
         }];

        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_linkLable.mas_bottom).with.offset(5);
             make.left.equalTo(_currentLineView.mas_right).with.offset(0);
             make.right.mas_equalTo(@10);
             make.bottom.mas_equalTo(@-10);
             make.height.mas_equalTo(16);
         }];
        
        
        UIView *grayView = UIView.new;
        grayView.backgroundColor = GrayColor;
        [self.contentView addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(@0);
             make.left.mas_equalTo(@50);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@0.5);
         }];
    }
    
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLogisticsCellData
{
    
}

- (UIView *)middleLineView
{
    if (_middleLineView == nil)
    {
        _middleLineView = UIView.new;
        _middleLineView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = UIView.new;
        topView.backgroundColor = GrayColor;
        [_middleLineView addSubview:topView];
        
        
        UIView *circleView = UIView.new;
        circleView.layer.cornerRadius = 3.0f;
        circleView.clipsToBounds = YES;
        circleView.backgroundColor = GrayColor;
        [_middleLineView addSubview:circleView];
        
        
        
        UIView *botomView = UIView.new;
        botomView.backgroundColor = GrayColor;
        [_middleLineView addSubview:botomView];
        
        //mas_equalTo是一个MACRO,比较的是值，equalTo比较的是view。
        [topView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_middleLineView).with.offset(0);
             make.centerX.equalTo(_middleLineView);
             make.height.mas_equalTo(@15);
             make.width.mas_equalTo(@1);
         }];
        
        
        [circleView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(topView.mas_bottom).with.offset(0);
             make.centerX.equalTo(_middleLineView);
             make.height.mas_equalTo(@6);
             make.width.mas_equalTo(@6);
         }];
        
        
        [botomView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(circleView.mas_bottom).with.offset(0);
             make.bottom.equalTo(_middleLineView).with.offset(0);
             make.centerX.equalTo(_middleLineView);
             make.width.mas_equalTo(@1);
         }];
        
    }
    
    return _middleLineView;
}

- (UIView *)currentLineView
{
    if (_currentLineView == nil)
    {
        _currentLineView = UIView.new;
        _currentLineView.backgroundColor = [UIColor whiteColor];

        
        
        UIView *circleView = UIView.new;
        circleView.layer.cornerRadius = 5.0f;
        circleView.clipsToBounds = YES;
        circleView.backgroundColor = TextColorPurple;
        [_currentLineView addSubview:circleView];
        
        
        
        UIView *botomView = UIView.new;
        botomView.backgroundColor = GrayColor;
        [_currentLineView addSubview:botomView];

        [circleView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_currentLineView).with.offset(15);
             make.centerX.equalTo(_currentLineView);
             make.height.mas_equalTo(@10);
             make.width.mas_equalTo(@10);
         }];
        
        
        [botomView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(circleView.mas_bottom).with.offset(0);
             make.bottom.equalTo(_currentLineView).with.offset(0);
             make.centerX.equalTo(_currentLineView);
             make.width.mas_equalTo(@1);
         }];
        
    }
    
    return _currentLineView;
}

- (KZLinkLabel *)linkLable
{
    if (_linkLable == nil)
    {
        _linkLable = [[KZLinkLabel alloc] init];
        _linkLable.automaticLinkDetectionEnabled = YES;
        _linkLable.font = [UIFont systemFontOfSize:14];
        _linkLable.backgroundColor = [UIColor whiteColor];
        _linkLable.numberOfLines = 10;
        _linkLable.lineBreakMode = NSLineBreakByTruncatingTail;
        _linkLable.linkColor = [UIColor blueColor];
        _linkLable.linkHighlightColor = [UIColor orangeColor];
    }
    
    
    return _linkLable;
}

- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        _timeLable = UILabel.new;
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.numberOfLines = 1;
    }
    
    return _timeLable;
}

@end
