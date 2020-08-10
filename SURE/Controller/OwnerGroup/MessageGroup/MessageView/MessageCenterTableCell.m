//
//  MessageCenterTableCell.m
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "MessageCenterTableCell.h"
#import <Masonry.h>
@interface MessageCenterTableCell ()

@property (nonatomic ,strong) UIImageView *logoImageView;
@property (nonatomic ,strong) UILabel *mainLable;
@property (nonatomic ,strong) UILabel *desLable;
@property (nonatomic ,strong) UILabel *timeLable;

@end

@implementation MessageCenterTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.mainLable];
        [self.contentView addSubview:self.timeLable];
        [self.contentView addSubview:self.desLable];
        
        
        
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(@10);
             make.width.mas_equalTo(@60);
             make.height.mas_equalTo(@60);
         }];
        
        [self.mainLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.equalTo(_logoImageView.mas_right).with.offset(10);
             make.height.mas_equalTo(@20);
         }];
        
        
        [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.equalTo(_mainLable.mas_right).with.offset(10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(@20);
         }];
        
        [self.desLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_mainLable.mas_bottom).with.offset(10);
             make.left.equalTo(_logoImageView.mas_right).with.offset(10);
             make.height.mas_equalTo(@20);
             make.right.mas_equalTo(@-10);
         }];
        

        
    }
    
    return self;
}

- (UIImageView *)logoImageView
{
    if (_logoImageView == nil)
    {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
    }
    
    return _logoImageView;
}

- (UILabel *)mainLable
{
    if (_mainLable == nil)
    {
        _mainLable = [[UILabel alloc]init];
        _mainLable.font = [UIFont systemFontOfSize:15];
        _mainLable.textColor = [UIColor blackColor];
        _mainLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _mainLable;
}

- (UILabel *)desLable
{
    if (_desLable == nil)
    {
        _desLable = [[UILabel alloc]init];
        _desLable.font = [UIFont systemFontOfSize:14];
        _desLable.textColor = TextColor149;
        _desLable.textAlignment = NSTextAlignmentRight;
    }
    
    return _desLable;
}


- (UILabel *)timeLable
{
    if (_timeLable == nil)
    {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont systemFontOfSize:14];
        _timeLable.textColor = TextColor149;
        _timeLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLable;
}

- (void)updateMessageCenterTableCell
{
    NSString *logonStr = @"";
    
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logonStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.mainLable.text = @"交易物流消息";
    self.timeLable.text = @"17/01/15";
    self.desLable.text = @"您的订单1767207480申请换货,给你带来不便敬...";

    
}

@end
