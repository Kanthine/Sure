//
//  SignView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SignView.h"

@implementation SignView
// 宽 80 高 45
- (instancetype) initWithFrame:(CGRect)frame Title:(NSString *)titleString
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        UIImage *image = [UIImage imageNamed:@"textSign"];// 25 ： 19
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 40, 25, 40) resizingMode:UIImageResizingModeStretch];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = image;
        [self addSubview:imageView];
        
        
        CGFloat lableHeight = CGRectGetHeight(frame) * 25.0 / 44.0;
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), lableHeight)];
        titleLable.text = titleString;
        titleLable.textColor = [UIColor whiteColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self addSubview:titleLable];
        
        CGFloat width = [self boundingWidthWithString:titleLable.text Font:titleLable.font];
        width = width + 10.0;
        if (width > 80.0)
        {
            CGRect lableFrame = titleLable.frame;
            lableFrame.size.width = width;
            titleLable.frame = lableFrame;
            
            
            CGRect imageFrame = imageView.frame;
            imageFrame.size.width = width;
            imageView.frame = imageFrame;
            
            CGRect selfFrame = self.frame;
            selfFrame.size.width = width;
            self.frame = selfFrame;            
        }
        
    }
    
    return self;
    
}

#pragma mark -  Other Method

- (CGFloat)boundingWidthWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect.size.width;
}


@end
