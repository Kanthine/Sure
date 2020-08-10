//
//  OwnerHeaderView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "OwnerHeaderView.h"

#import <Masonry.h>

#import "PersonalCenterVC.h"

@interface OwnerHeaderButtonView : UIView

@end


@interface OwnerHeaderButtonView()

@property (nonatomic ,strong) UIButton *tapSupportButton;
@property (nonatomic ,strong) UIButton *fansButton;
@property (nonatomic ,strong) UIButton *optionButton;


@property (nonatomic ,strong) UILabel *tapSupportLabel;
@property (nonatomic ,strong) UILabel *fansLabel;
@property (nonatomic ,strong) UILabel *optionLabel;


@end

@implementation OwnerHeaderButtonView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setButtonSuperView];
    }
    
    return self;
}

- (void)setButtonSuperView
{
    [self addSubview:self.tapSupportLabel];
    [self addSubview:self.fansLabel];
    [self addSubview:self.optionLabel];
    
    [self.tapSupportLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(@0);
         make.bottom.mas_equalTo(@0);
         make.height.mas_equalTo(@16);
     }];
    
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(_tapSupportLabel.mas_right).with.offset(0);
         make.bottom.mas_equalTo(@0);
         make.width.equalTo(_tapSupportLabel.mas_width);
         make.height.mas_equalTo(@16);
     }];
    
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(_fansLabel.mas_right).with.offset(0);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
         make.width.equalTo(_fansLabel.mas_width);
         make.height.mas_equalTo(@16);
     }];
    

    
    
    
    
    [self addSubview:self.tapSupportButton];
    [self addSubview:self.fansButton];
    [self addSubview:self.optionButton];
    
    [self.tapSupportButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.mas_equalTo(@5);
         make.bottom.mas_equalTo(@0);
     }];

    
    [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.equalTo(_tapSupportButton.mas_right).with.offset(0);
         make.bottom.mas_equalTo(@0);
         make.width.equalTo(_tapSupportButton.mas_width);
     }];

    [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.equalTo(_fansButton.mas_right).with.offset(0);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@-2);
         make.width.equalTo(_fansButton.mas_width);
     }];
    
}

- (UIButton *)tapSupportButton
{
    if (_tapSupportButton == nil)
    {
        _tapSupportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tapSupportButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _tapSupportButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_tapSupportButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _tapSupportButton.titleLabel.font = [UIFont fontWithName:BoldFontName size:15];
        
    }
    
    return _tapSupportButton;
}

- (UIButton *)fansButton
{
    if (_fansButton == nil)
    {
        _fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _fansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_fansButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _fansButton.titleLabel.font = [UIFont fontWithName:BoldFontName size:15];
        
    }
    
    return _fansButton;
}

- (UIButton *)optionButton
{
    if (_optionButton == nil)
    {
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _optionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_optionButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _optionButton.titleLabel.font = [UIFont fontWithName:BoldFontName size:15];
    }
    return _optionButton;
}

- (UILabel *)tapSupportLabel
{
    if (_tapSupportLabel == nil)
    {
        _tapSupportLabel = [[UILabel alloc]init];
        _tapSupportLabel.font = [UIFont systemFontOfSize:13];
        _tapSupportLabel.textColor = TextColorPurple;
        _tapSupportLabel.textAlignment = NSTextAlignmentLeft;
        _tapSupportLabel.text = @"被赞数";
    }
    
    return _tapSupportLabel;
}

- (UILabel *)fansLabel
{
    if (_fansLabel == nil)
    {
        _fansLabel = [[UILabel alloc]init];
        _fansLabel.font = [UIFont systemFontOfSize:13];
        _fansLabel.textColor = TextColorPurple;
        _fansLabel.textAlignment = NSTextAlignmentCenter;
        _fansLabel.text = @"粉丝数";
    }
    
    return _fansLabel;
}


- (UILabel *)optionLabel
{
    if (_optionLabel == nil)
    {
        _optionLabel = [[UILabel alloc]init];
        _optionLabel.font = [UIFont systemFontOfSize:13];
        _optionLabel.textColor = TextColorPurple;
        _optionLabel.textAlignment = NSTextAlignmentRight;
        _optionLabel.text = @"关注";
    }
    
    return _optionLabel;
}


@end





@interface OwnerHeaderView()

@property (nonatomic, nonnull ,strong) UIView *backView;

@property (nonatomic ,strong) UIButton *headerImageButton;
@property (nonatomic ,strong) CALayer *headerImageLayer;

@property (strong, nonatomic) UILabel *ownerNameLable;
@property (strong, nonatomic) UILabel *buyMoneyLable;
@property (nonatomic ,strong) UILabel *personalizedSignatureLable;
@property (nonatomic ,strong) OwnerHeaderButtonView *buttonView;

@end


@implementation OwnerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        

        [self addSubview:self.backView];
        [self addSubview:self.headerImageButton];
        [self addSubview:self.ownerNameLable];
        [self addSubview:self.buyMoneyLable];
        [self addSubview:self.buttonView];
        [self addSubview:self.personalizedSignatureLable];
        self.headerImageButton.layer.cornerRadius = 43;
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
        [self.layer insertSublayer:self.headerImageLayer below:self.headerImageButton.layer];
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void)updateConstraints
{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@43);
         make.left.mas_equalTo(@0);
         make.bottom.mas_equalTo(@0);
         make.right.mas_equalTo(@0);
     }];
    
    [self.headerImageButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(@0);
         make.left.mas_equalTo(@10);
         make.width.mas_equalTo(@86);
         make.height.mas_equalTo(@86);
     }];

    
    [self.ownerNameLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.equalTo(_backView.mas_top).with.offset(-2);
         make.left.equalTo(_headerImageButton.mas_right).with.offset(5);
         make.height.mas_equalTo(@18);
     }];
    
    [self.buyMoneyLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.equalTo(_backView.mas_top).with.offset(-2);
         make.left.equalTo(_ownerNameLable.mas_right).with.offset(5);
         make.height.mas_equalTo(@18);
         make.right.mas_equalTo(@-10);
     }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_backView.mas_top).with.offset(5);
         make.height.mas_equalTo(@43);
         make.right.mas_equalTo(@-10);
         make.width.mas_equalTo(@200);
     }];
    
    
    [self.personalizedSignatureLable mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(_headerImageButton.mas_bottom).with.offset(10);
         make.left.mas_equalTo(@10);
         make.right.mas_equalTo(@-10);
     }];

    
    [super updateConstraints];
}

- (UIView *)backView
{
    if (_backView == nil)
    {
        _backView = UIView.new;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    
    return _backView;
}

- (UIButton *)headerImageButton
{
    if (_headerImageButton == nil)
    {
        _headerImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerImageButton.clipsToBounds = YES;
        [_headerImageButton addTarget:self action:@selector(personalCenterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _headerImageButton;
}

- (CALayer *)headerImageLayer
{
    if (_headerImageLayer == nil)
    {
        _headerImageLayer=[CALayer layer];
        _headerImageLayer.frame = CGRectMake(10, 0, 86, 86);
        _headerImageLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _headerImageLayer.cornerRadius = 43;
        
        _headerImageLayer.masksToBounds=NO;
        
        _headerImageLayer.shadowColor=[UIColor blackColor].CGColor;
        
        _headerImageLayer.shadowOffset=CGSizeMake(3,3);
        
        _headerImageLayer.shadowOpacity = .7f;
        
        _headerImageLayer.shadowRadius=3;
        
    }
    return _headerImageLayer;
}

- (UILabel *)ownerNameLable
{
    if (_ownerNameLable == nil)
    {
        _ownerNameLable = [[UILabel alloc]init];
        _ownerNameLable.font = [UIFont systemFontOfSize:15];
        _ownerNameLable.textColor = [UIColor whiteColor];
        _ownerNameLable.textAlignment = NSTextAlignmentLeft;
        
        _ownerNameLable.shadowColor = [UIColor blackColor];
        _ownerNameLable.shadowOffset = CGSizeMake(1, 1);
        
    }
    
    return _ownerNameLable;
}

- (UILabel *)buyMoneyLable
{
    if (_buyMoneyLable == nil)
    {
        _buyMoneyLable = [[UILabel alloc]init];
        _buyMoneyLable.font = [UIFont systemFontOfSize:14];
        _buyMoneyLable.textColor = [UIColor whiteColor];
        _buyMoneyLable.textAlignment = NSTextAlignmentRight;
        
        _buyMoneyLable.shadowColor = [UIColor blackColor];
        _buyMoneyLable.shadowOffset = CGSizeMake(1, 1);
        
    }
    
    return _buyMoneyLable;
}

- (UILabel *)personalizedSignatureLable
{
    if (_personalizedSignatureLable == nil)
    {
        _personalizedSignatureLable = [[UILabel alloc]init];
        _personalizedSignatureLable.font = [UIFont systemFontOfSize:14];
        _personalizedSignatureLable.textColor = TextColorBlack;
        _personalizedSignatureLable.textAlignment = NSTextAlignmentLeft;
        
        _personalizedSignatureLable.numberOfLines = 0;
    }
    
    return _personalizedSignatureLable;
}

- (OwnerHeaderButtonView *)buttonView
{
    if (_buttonView == nil)
    {
        _buttonView = [[OwnerHeaderButtonView alloc]init];
        _buttonView.backgroundColor = [UIColor whiteColor];
        
        [_buttonView.tapSupportButton addTarget:self action:@selector(likedDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView.fansButton addTarget:self action:@selector(fansDetaileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _buttonView;
}

- (void)personalCenterButtonClick:(UIButton *)sender
{
    if ([AuthorizationManager isAuthorization])
    {
        PersonalCenterVC *personalVC = [[PersonalCenterVC alloc]init];
        personalVC.hidesBottomBarWhenPushed = YES;
        [self.currentViewController.navigationController pushViewController:personalVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self.currentViewController];
    }
//    _ownerHeaderViewPersonalButtonClick();
}

- (void)likedDetaileButtonClick:(UIButton *)sender
{
    _ownerHeaderViewSupportedButtonClick();
}

- (void)fansDetaileButtonClick:(UIButton *)sender
{
    _ownerHeaderViewFansCountButtonClick();
}

- (void)optionButtonClick:(UIButton *)sender
{
    _ownerHeaderViewOptionButtonClick();
}

- (void)updateMyInfo
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    self.personalizedSignatureLable.text  = [NSString stringWithFormat:@"个性签名：%@",account.realName];
    [self.headerImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:account.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.headerImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:account.headimg] forState:UIControlStateHighlighted placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    self.ownerNameLable.text = account.nickname;

    
    self.buyMoneyLable.text = @"累计购物:￥3009.96";
    [self.buttonView.tapSupportButton setTitle:@"200" forState:UIControlStateNormal];
    [self.buttonView.fansButton setTitle:@"150" forState:UIControlStateNormal];
    [self.buttonView.optionButton setTitle:@"100" forState:UIControlStateNormal];
}

@end
