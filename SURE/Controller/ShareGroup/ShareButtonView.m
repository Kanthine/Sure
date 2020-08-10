//
//  ShareButtonView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ShareButtonView.h"

@implementation ShareButtonView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageTitle:(NSString *)imageTitleString
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat viewWidth = CGRectGetWidth(frame);
        
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        if ([imageTitleString isEqualToString:@"share_CopyLink"])
        {
            imageView.frame = CGRectMake(10, 10, viewWidth - 20, viewWidth - 20);
        }
        imageView.image = [UIImage imageNamed:imageTitleString];
        [self addSubview:imageView];
        
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-5, viewWidth + 5, viewWidth + 10, 20)];
        titleLable.text = title;
        titleLable.font = [UIFont systemFontOfSize:13];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = TextColor149;
        [self addSubview:titleLable];
        
        
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
        [self.delegate ownerCustomButtonClick:_platformType];
    }
}

@end
