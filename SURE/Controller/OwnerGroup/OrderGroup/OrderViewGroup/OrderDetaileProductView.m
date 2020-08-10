//
//  OrderDetaileProductView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define OrderDetaileProductViewHeight 100


#import "OrderDetaileProductView.h"

@interface OrderDetaileProductView()


@property (nonatomic ,strong) UIImageView *productLogoImageView;
@property (nonatomic ,strong) UILabel *nameLable;
@property (nonatomic ,strong) UILabel *attributeLable;
@property (nonatomic ,strong) UILabel *oldPriceLable;
@property (nonatomic ,strong) UILabel *lineLable;
@property (nonatomic ,strong) UILabel *cutPriceLable;
@property (nonatomic ,strong) UILabel *countLable;

@end

@implementation OrderDetaileProductView

- (instancetype)initWithFrame:(CGRect)frame ProductModel:(OrderProductModel *)model
{
    self = [super initWithFrame:frame];
    
    if (self)
    {

        _productLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, OrderDetaileProductViewHeight - 20, OrderDetaileProductViewHeight - 20)];
        [self addSubview:_productLogoImageView];
        
        _cutPriceLable = [[UILabel alloc]init];
        _cutPriceLable.numberOfLines = 1;
        _cutPriceLable.textAlignment = NSTextAlignmentRight;
        _cutPriceLable.textColor = TextColorBlack;
        _cutPriceLable.font = [UIFont systemFontOfSize:LableFountSize];
        _cutPriceLable.text = [NSString stringWithFormat:@"￥ %@",model.goodsPrice];
        CGSize cutPriceSize = [_cutPriceLable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _cutPriceLable.font} context:nil].size;
        _cutPriceLable.frame = CGRectMake(ScreenWidth - cutPriceSize.width - 10, 10, cutPriceSize.width, cutPriceSize.height);
        [self addSubview:_cutPriceLable];
        
        
        
        
        _oldPriceLable = [[UILabel alloc]init];
        _oldPriceLable.numberOfLines = 1;
        _oldPriceLable.textAlignment = NSTextAlignmentRight;
        _oldPriceLable.font = [UIFont systemFontOfSize:LableFountSize];
        _oldPriceLable.textColor = TextColor149;
        _oldPriceLable.text = @"￥509.98";
        CGSize oldPriceSize = [_oldPriceLable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _oldPriceLable.font} context:nil].size;
        _oldPriceLable.frame = CGRectMake(ScreenWidth - oldPriceSize.width - 10, _cutPriceLable.frame.origin.y + CGRectGetHeight(_cutPriceLable.frame) + 8, oldPriceSize.width, oldPriceSize.height);
        [self addSubview:_oldPriceLable];
        
        _lineLable = [[UILabel alloc]initWithFrame:CGRectMake(3, CGRectGetHeight(_cutPriceLable.frame) / 2.0, oldPriceSize.width - 6, 1)];
        _lineLable.backgroundColor = GrayColor;
        [_oldPriceLable addSubview:_lineLable];
        
        
        //判断是否有优惠价
        
        _oldPriceLable.hidden = NO;
        
        
        _countLable = [[UILabel alloc]init];
        _countLable.numberOfLines = 1;
        _countLable.textColor = TextColorBlack;
        _countLable.textAlignment = NSTextAlignmentRight;
        _countLable.font = [UIFont systemFontOfSize:LableFountSize];
        _countLable.text = [NSString stringWithFormat:@"x %@",model.goodsNumber];
        [self addSubview:_countLable];
        
        if (_oldPriceLable.hidden)
        {
            _countLable.frame = CGRectMake(ScreenWidth - 60 , _cutPriceLable.frame.origin.y + CGRectGetHeight(_cutPriceLable.frame) + 8, 50, CGRectGetHeight(_cutPriceLable.frame));
        }
        else
        {
            _countLable.frame = CGRectMake(ScreenWidth - 60 , _oldPriceLable.frame.origin.y + CGRectGetHeight(_oldPriceLable.frame) + 8, 50, CGRectGetHeight(_cutPriceLable.frame));
        }
        

        [self addSubview:self.refundButton];
        
        
        
        
        CGFloat nameWidth;
        
        if (_oldPriceLable.hidden == YES || oldPriceSize.width <= cutPriceSize.width)
        {
            nameWidth = ScreenWidth - OrderDetaileProductViewHeight - cutPriceSize.width - 10;
        }
        else
        {
            nameWidth = ScreenWidth - OrderDetaileProductViewHeight - oldPriceSize.width - 10;
        }
        
        
        _nameLable = [[UILabel alloc]init];
        _nameLable.numberOfLines = 2;
        _nameLable.text = model.goodsName;
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.font = [UIFont systemFontOfSize:LableFountSize];
        _nameLable.textColor = TextColorBlack;
        
        CGFloat nameHeight = [_nameLable.text boundingRectWithSize:CGSizeMake(nameWidth, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _nameLable.font} context:nil].size.height;
        nameHeight  = nameHeight > 36 ? 36 : nameHeight;
        _nameLable.frame = CGRectMake(OrderDetaileProductViewHeight, 10, nameWidth, nameHeight);
        [self addSubview:_nameLable];
        
        
        _attributeLable = [[UILabel alloc]initWithFrame:CGRectMake(OrderDetaileProductViewHeight, _nameLable.frame.origin.y + CGRectGetHeight(_nameLable.frame) + 8, nameWidth, cutPriceSize.height)];
        _attributeLable.numberOfLines = 1;
        _attributeLable.textAlignment = NSTextAlignmentLeft;
        _attributeLable.font = [UIFont systemFontOfSize:LableFountSize];
        _attributeLable.textColor = TextColor149;
        _attributeLable.text = @"颜色尺寸：藏青色/XL";
        [self addSubview:_attributeLable];

        
        
        
        
        

        if ( (_refundButton.frame.origin.y + CGRectGetHeight(_refundButton.frame) + 10 ) > OrderDetaileProductViewHeight)
        {
            
            self.frame = CGRectMake(frame.origin.x, frame.origin.y, ScreenWidth, _refundButton.frame.origin.y + CGRectGetHeight(_refundButton.frame) + 10);
        }
        
        
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(self.frame) - 1, ScreenWidth - 20, 1)];
        grayLable.backgroundColor = GrayColor;
        [self addSubview:grayLable];
        
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@",ImageUrl,model.goodsImg];
        [_productLogoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    }
    
    
    return self;
}

- (UIButton *)refundButton
{
    if (_refundButton == nil)
    {
        //待发货 待收货 都可以退款
        UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [refundButton setTitle:@"退款" forState:UIControlStateNormal];
        refundButton.titleLabel.font = [UIFont systemFontOfSize:LableFountSize];
        [refundButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        refundButton.layer.cornerRadius = 2;
        refundButton.clipsToBounds = YES;
        refundButton.layer.borderWidth = 1;
        refundButton.layer.borderColor = TextColorPurple.CGColor;
        refundButton.frame = CGRectMake(ScreenWidth - 70 , _countLable.frame.origin.y + CGRectGetHeight(_countLable.frame) + 8, 60, 25);
        
        _refundButton = refundButton;
        
    }
    
    return _refundButton;
}

@end
