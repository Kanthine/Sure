//
//  ApplyRefundTableCell.m
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define ItemWidth (ScreenWidth - 50) / 4.0

#import "ApplyRefundTableCell.h"
#import <Masonry.h>

@interface ApplyRefundTableCell()


@property (nonatomic ,strong) UIView *reasonView;
@property (nonatomic ,strong) UIView *refundPriceView;
@property (nonatomic ,strong) UIView *refundStateView;

@end


@implementation ApplyRefundTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGBA(239, 239, 244, 1);
        
        
        
        [self.contentView addSubview:self.reasonView];
        [self.contentView addSubview:self.refundPriceView];
        [self.contentView addSubview:self.refundStateView];
        [self.contentView addSubview:self.photoView];

        
        CGFloat space = 10.0f;
        CGFloat photoHeight = ItemWidth + 45;
        self.reasonView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        self.refundPriceView.frame = CGRectMake(0, CGRectGetMaxY(self.reasonView.frame) + space, ScreenWidth, CGRectGetHeight(self.reasonView.frame));
        self.refundStateView.frame = CGRectMake(0, CGRectGetMaxY(self.refundPriceView.frame) + space, ScreenWidth, CGRectGetHeight(self.reasonView.frame));
        self.photoView.frame = CGRectMake(0, CGRectGetMaxY(self.refundStateView.frame) + space, ScreenWidth, photoHeight);
        
        

    }
    
    return self;
}


- (UILabel *)refundPriceLable
{
    if (_refundPriceLable == nil)
    {
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        
        
        _refundPriceLable = lable;
    }
    
    return _refundPriceLable;
}

- (UITextView *)stateTextView
{
    if (_stateTextView == nil)
    {
        _stateTextView = [[UITextView alloc]init];
        _stateTextView.layer.cornerRadius = 5;
        _stateTextView.backgroundColor = RGBA(250, 250, 255, 1);
        _stateTextView.clipsToBounds = YES;
    }
    
    return _stateTextView;
}

- (UIButton *)reasonButton
{
    if (_reasonButton == nil)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 27);
        button.adjustsImageWhenHighlighted = NO;
        button.backgroundColor = [UIColor clearColor];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:TextColor149 forState:UIControlStateNormal];
        [button setTitleColor:TextColorBlack forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _reasonButton = button;
    }
    
    return _reasonButton;
}







- (UIView *)reasonView
{
    if (_reasonView == nil)
    {
        _reasonView = [[UIView alloc]init];
        _reasonView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = @"退款原因";
        [_reasonView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@10);
             make.top.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
        
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_reasonView addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_reasonView);
             make.right.mas_equalTo(@-10);
             make.width.mas_equalTo(@9);
             make.height.mas_equalTo(@15);
         }];
        
        
        [_reasonView addSubview:self.reasonButton];
        [self.reasonButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.left.equalTo(lable.mas_right).with.offset(0);
         }];

    }
    
    return _reasonView;
}

- (UIView *)refundPriceView
{
    if (_refundPriceView == nil)
    {
        _refundPriceView = [[UIView alloc]init];
        _refundPriceView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = @"退款金额：￥";
        [_refundPriceView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@10);
             make.top.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];
        
        
        [_refundPriceView addSubview:self.refundPriceLable];
        [self.refundPriceLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(lable.mas_right).with.offset(0);
             make.top.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
         }];

    }
    
    return _refundPriceView;
}

- (UIView *)refundStateView
{
    if (_refundStateView == nil)
    {
        _refundStateView = [[UIView alloc]init];
        _refundStateView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = @"退款说明：";
        lable.tag = 1;
        CGFloat lableWidth = [lable.text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size.width;
        
        [_refundStateView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@10);
             make.top.mas_equalTo(@10);
             make.width.mas_equalTo(@(lableWidth));
         }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2;
        button.titleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
        button.adjustsImageWhenHighlighted = NO;
        button.backgroundColor = [UIColor clearColor];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"选填" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:TextColor149 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_refundStateView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(lable.mas_right).with.offset(1);
             make.top.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@40);
         }];

    }
    
    return _refundStateView;
}


- (UIView *)photoView
{
    if (_photoView == nil)
    {
        _photoView = [[UIView alloc]init];
        _photoView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lable = [[UILabel alloc]init];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = TextColorBlack;
        lable.textAlignment = NSTextAlignmentLeft;
        lable.text = @"上传凭证(选填)";
        [_photoView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@10);
             make.top.mas_equalTo(@10);
         }];

    }
    
    return _photoView;
}

- (void)updatePhotoContentViewWithArray:(NSMutableArray<UIImage *> *)imageArray
{
    [self.photoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (obj.tag >= 10)
        {
            [obj removeFromSuperview];
        }
    }];
    
    
    
    if (imageArray && imageArray.count > 0 )
    {
        [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.adjustsImageWhenHighlighted = NO;
             button.frame = CGRectMake(10 + (ItemWidth + 10) *idx, 35, ItemWidth, ItemWidth);
             [button setImage:obj forState:UIControlStateNormal];
             [_photoView addSubview:button];
             
         }];
        
        if (imageArray.count < 3)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            button.tag = 666;
            
            button.frame = CGRectMake(10 + (ItemWidth + 10) * imageArray.count, 35, ItemWidth, ItemWidth);
            [button setImage:[UIImage imageNamed:@"applyRefund"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_photoView addSubview:button];
        }
        
        
        
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.tag = 666;
        
        button.frame = CGRectMake(10, 35, ItemWidth, ItemWidth);
        [button setImage:[UIImage imageNamed:@"applyRefund"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photoView addSubview:button];

    }
    
    
    
}

- (void)stateButtonClick:(UIButton *)sender
{
    if (sender.selected == NO)
    {
        sender.selected = YES;
        sender.hidden = YES;
        UILabel *lable = [sender.superview viewWithTag:1];

        CGFloat space = 10.0f;

        CGFloat height = CGRectGetMaxY(lable.frame) + 20 + 80;
        
        self.stateTextView.frame = CGRectMake(10, CGRectGetMaxY(lable.frame) + 10, ScreenWidth - 20, 80);
        
        [sender.superview addSubview:self.stateTextView];


        CGFloat photoHeight = ItemWidth + 45;

        self.refundStateView.frame = CGRectMake(0, CGRectGetMaxY(self.refundPriceView.frame) + space, ScreenWidth, height);
        self.photoView.frame = CGRectMake(0, CGRectGetMaxY(self.refundStateView.frame) + space, ScreenWidth, photoHeight);
        

        
        CGFloat newheight = CGRectGetMaxY(self.refundPriceView.frame) + height + photoHeight + 30;

        
        self.applyRefundStateTextViewShowClick(newheight);
    }
    
}

- (void)addButtonClick:(UIButton *)sender
{
    self.applyRefundAddPhotoButtonClick();
}


@end
