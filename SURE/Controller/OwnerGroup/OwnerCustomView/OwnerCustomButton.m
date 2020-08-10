//
//  OwnerCustomButton.m
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define ImageWidth 25.0

#import "OwnerCustomButton.h"

@implementation OwnerCustomButton

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageTitle:(NSString *)imageTitleString
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat viewWidth = CGRectGetWidth(frame);
//        CGFloat viewHeight = CGRectGetHeight(frame);

        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((viewWidth - ImageWidth ) / 2.0, 0, ImageWidth, ImageWidth)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imageTitleString];
        [self addSubview:imageView];
        
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, ImageWidth, viewWidth, 20)];

        _titleLable.text = title;
        _titleLable.font = [UIFont systemFontOfSize:13];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = TextColorBlack;
        [self addSubview:_titleLable];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)buttonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ownerCustomButtonClick:) ])
    {
        [self.delegate ownerCustomButtonClick:_index];
    }
}

@end
