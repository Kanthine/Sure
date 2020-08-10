//
//  AlbumImageCropView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AlbumImageCropView.h"

@interface AlbumImageCropView ()

<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *coverImageView;

@end

/*
 *图片裁剪类
 */

@implementation AlbumImageCropView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.scrollView];
        [self addSubview:self.coverImageView];
    }
    
    return self;
}

- (UIImageView *)coverImageView
{
    if (_coverImageView == nil)
    {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _coverImageView.image = [UIImage imageNamed:@"photoCover"];
    }
    return _coverImageView;
}

- (void)setImageView:(UIImageView *)imageView
{
    if ([_imageView isEqual:imageView] == NO)
    {
        _imageView = imageView;
        
        
        NSLog(@"size === %@",[NSValue valueWithCGSize:imageView.image.size]);
        
        
    }
    
    
    
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        
        
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 5.0f;
        _scrollView.bouncesZoom = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenWidth);
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        [_scrollView addSubview:self.imageView];
        
    }
    
    return _scrollView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView");
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if(scrollView.zoomScale==1)
    {
        
        CGSize imageSize = self.imageView.image.size;
        
        float img_height = imageSize.height * ScreenWidth / imageSize.width;
//        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenWidth);
        
    }
    else
    {
        CGSize contentSize = scrollView.contentSize;
        float width = [[UIScreen mainScreen] bounds].size.width;
        float height = [[UIScreen mainScreen] bounds].size.height;
        CGSize imageSize = self.imageView.image.size;
        
        float img_height = imageSize.height * ScreenWidth /scrollView.contentSize.width;
        //        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width,scrollView.contentSize.width / ScreenWidth * (img_height)+(height-60-self.midsize.height));
    }
    
}

- (UIImage *)finishCroppingImage
{
    float zoomScale = 1.0 / [_scrollView zoomScale];
    
    CGRect rect;
    rect.origin.x = [_scrollView contentOffset].x * zoomScale;
    rect.origin.y = [_scrollView contentOffset].y * zoomScale;
    rect.size.width = [_scrollView bounds].size.width * zoomScale;
    rect.size.height = [_scrollView bounds].size.height * zoomScale;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([[_imageView image] CGImage], rect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    
    return croppedImage;
}


@end
