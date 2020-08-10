//
//  MenuOrderButton.m
//  SURE
//
//  Created by 王玉龙 on 16/11/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "MenuOrderButton.h"

@interface MenuOrderButton()


@end

@implementation MenuOrderButton

- (instancetype)initWithFrame:(CGRect)frame ButtonTitle:(NSString *)titleString IsNeedOrder:(BOOL)isOrder
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        _isNeedOrder = isOrder;
        _orderString = @"";;//默认排序
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, CGRectGetHeight(self.frame))];
        titleLable.text = titleString;
        titleLable.tag = 1;
        titleLable.textColor = [UIColor lightGrayColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLable];
        
        CGRect textRect = [self boundingRectWithString:titleLable.text Font:titleLable.font];
        
        if (isOrder)
        {
            CGFloat x = (CGRectGetWidth(self.frame)  - textRect.size.width - 13 - 5 ) / 2.0;
            
            titleLable.textAlignment = NSTextAlignmentRight;
            titleLable.frame = CGRectMake(x, 0, textRect.size.width, CGRectGetHeight(self.frame));
            
            UIImageView *orderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x + textRect.size.width + 5 , 0, 10, 13)];
            orderImageView.center = CGPointMake(orderImageView.center.x, self.center.y);
            orderImageView.tag = 2;
            orderImageView.image = [UIImage imageNamed:@"menuButtonOrder_Default"];
            [self addSubview:orderImageView];
            
        }
        else
        {
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.frame = self.bounds;
        }
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        button.frame = self.bounds;
        [self addSubview:button];
    }
    
    return self;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (_index == 0)
    {
        _orderString = @"";
    }
    
}

- (void)buttonClick
{
    
    if (_isNeedOrder)
    {
        /*
         *  默认 --- 升  ---- 降
         */
        switch (_orderState)
        {
            case MenuOrderButtonStateDefault:
            {
                //升
                if (_orderString == nil)
                {
                    _orderString = @"";
                }
                else
                {
                    self.orderState = MenuOrderButtonStateUp;
                }
            }
                
                break;
            case MenuOrderButtonStateUp:
            {
                //降
                self.orderState = MenuOrderButtonStateDown;
            }
                break;
            case MenuOrderButtonStateDown:
            {
                //升
                self.orderState = MenuOrderButtonStateUp;
            }
                break;
            default:
                break;
        }
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchOrder:)])
        {
            [self.delegate switchOrder:self];
        }
        

    }
    else
    {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchOrder:)])
        {
            [self.delegate switchOrder:self];
        }
    }
    
    
    
    
    
    
}


//
- (void)setOrderState:(MenuOrderButtonState)orderState
{
    _orderState = orderState;
    
    UIImageView *orderImageView = [self viewWithTag:2];
    
    switch (_orderState)
    {
        case MenuOrderButtonStateDefault:
        {
            _orderString = @"";
            orderImageView.image = [UIImage imageNamed:@"menuButtonOrder_Default"];
            
        }
            break;
            
        case MenuOrderButtonStateUp:
        {
            _orderString = @"asc";
            orderImageView.image = [UIImage imageNamed:@"menuButtonOrder_Up"];
            
        }
            break;
        case MenuOrderButtonStateDown:
        {
            _orderString = @"desc";
            orderImageView.image = [UIImage imageNamed:@"menuButtonOrder_Down"];

        }
            break;
        default:
            break;
    }
    
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    UILabel *titleLable = [self viewWithTag:1];
    
    if (isSelected)
    {
        titleLable.textColor = RGBA(141, 31, 203,1);

    }
    else
    {
        titleLable.textColor = [UIColor lightGrayColor];

    }
}


- (CGRect)boundingRectWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect;
}


@end
