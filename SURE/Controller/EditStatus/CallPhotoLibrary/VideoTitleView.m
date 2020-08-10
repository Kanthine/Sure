//
//  VideoTitleView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "VideoTitleView.h"

#define kThumbnailLength    (ScreenWidth - 5 * 2 )/ 4.0   //78.0f

@implementation VideoTitleView

-(void)drawRect:(CGRect)rect
{
    CGFloat colors [] =
    {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.8,
        0.0, 0.0, 0.0, 1.0
    };
    
    CGFloat locations [] = {0.0, 0.75, 1.0};
    
    CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    
    CGFloat height          = rect.size.height;
    CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height);
    CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    
    CGSize titleSize        = [self.text sizeWithFont:self.font];
    [self.textColor set];
    [self.text drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , (height - 12) / 2)
                  forWidth:kThumbnailLength
                  withFont:self.font
                  fontSize:12
             lineBreakMode:NSLineBreakByTruncatingTail
        baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    UIImage *videoIcon=[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZYQAssetPicker.Bundle/Images/AssetsPickerVideo@2x.png"]];
    
    [videoIcon drawAtPoint:CGPointMake(2, (height - videoIcon.size.height) / 2)];
}

@end
