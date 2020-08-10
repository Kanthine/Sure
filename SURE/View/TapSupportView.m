//
//  TapSupportView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "TapSupportView.h"

@interface TapSupportView()

{
    UILabel *_countLable;
}

@end

@implementation TapSupportView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBasicUI];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBasicUI];
    }
    
    return self;
}

- (void)setBasicUI
{
    
    _headerImageArray = [NSMutableArray arrayWithObjects:@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader",@"ownerHeader", nil];
    
    CGFloat height = CGRectGetHeight(self.frame);

    height = 30;

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, height, height);
    [button addTarget:self action:@selector(tapSupportButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    
    _countLable = [[UILabel alloc]initWithFrame:CGRectMake( height , 0, 17, height)];
    _countLable.center = CGPointMake(_countLable.center.x, button.center.y);
    _countLable.text = [NSString stringWithFormat:@"%ld",_headerImageArray.count];
    _countLable.textAlignment = NSTextAlignmentCenter;
    _countLable.font = [UIFont systemFontOfSize:17];
    _countLable.layer.cornerRadius = 2;
    CGRect rect = [self boundingRectWithString:_countLable.text Font:_countLable.font];
    _countLable.frame = CGRectMake(_countLable.frame.origin.x, _countLable.frame.origin.y, rect.size.width, height);
    [self addSubview:_countLable];

    
    NSInteger headerCount = _headerImageArray.count <= 4 ? _headerImageArray.count : 4;
    _supportSum = _headerImageArray.count;
    
    CGFloat imageSpace = 5;
    CGFloat imageWidth = 20;
    for (int i = 0; i < headerCount; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(height + 15 + imageSpace +( imageWidth + imageSpace ) * i, (height - imageWidth) / 2.0, imageWidth, imageWidth)];
        imageView.center = CGPointMake(imageView.center.x, button.center.y);
        imageView.image = [UIImage imageNamed:_headerImageArray[i]];
        imageView.layer.cornerRadius = imageWidth /2.0;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    
    if (_isSupport)
    {
        [button setImage:[UIImage imageNamed:@"TapSupported"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"TapSupportNo"] forState:UIControlStateNormal];
    }

}

- (void)tapSupportButtonclick:(UIButton *)button
{
    if (_isSupport)
    {
        _supportSum ++;
        [button setImage:[UIImage imageNamed:@"TapSupported"] forState:UIControlStateNormal];
    }
    else
    {
        _supportSum --;
        [button setImage:[UIImage imageNamed:@"TapSupportNo"] forState:UIControlStateNormal];
        
    }
    
    _countLable.text = [NSString stringWithFormat:@"%ld",_supportSum];
    CGRect rect = [self boundingRectWithString:_countLable.text Font:_countLable.font];
    _countLable.frame = CGRectMake(_countLable.frame.origin.x, _countLable.frame.origin.y, rect.size.width, 30);
    _isSupport = !_isSupport;
}


#pragma mark -  Other Method

- (CGRect)boundingRectWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth , 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect;
}


@end
