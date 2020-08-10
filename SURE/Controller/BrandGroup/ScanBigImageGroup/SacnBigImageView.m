//
//  SacnBigImageView.m
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "SacnBigImageView.h"


#import "ScanBigPageScrollView.h"

#import "ScanBigPhotoScrollView.h"

@interface  SacnBigImageView()

<ScanBigPageScrollViewDelegate, UIScrollViewDelegate>

{
    
    UIPageControl *_pageControl;
    
     ScanBigPageScrollView*_pagingScrollView;
    
    NSMutableArray<NSString *> *_imageArray;
}

@end

@implementation SacnBigImageView

- (void)dealloc
{
    _imageArray = nil;
    _pageControl = nil;
    _pagingScrollView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray <NSString *> *)imageArray CurrentIndex:(NSInteger)currentIndex
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UILabel *backLable = [[UILabel alloc]initWithFrame:self.bounds];
        backLable.backgroundColor = [UIColor blackColor];
        backLable.alpha = .7f;
        [self addSubview:backLable];
        
        _imageArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i ++)
        {
            [_imageArray addObject:imageArray[i]];
        }
        
        
        CGFloat height = (ScreenHeight - ScreenWidth) / 2 - 64;
        
        _pagingScrollView = [[ScanBigPageScrollView alloc]initWithFrame:CGRectMake(0, - height, ScreenWidth, ScreenHeight)];
        _pagingScrollView.backgroundColor = [UIColor clearColor];
        _pagingScrollView.pagingViewDelegate =self;
        [self addSubview:_pagingScrollView];
        
        [_pagingScrollView displayPagingViewAtIndex:currentIndex];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        _pagingScrollView.frame = self.bounds;
        _pagingScrollView.backgroundColor = [UIColor clearColor];
        [UIView commitAnimations];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                       {
                           _pagingScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
                       });
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 10 * imageArray.count, 20)];
        _pageControl.center = CGPointMake(self.center.x , ScreenHeight - 50);
        _pageControl.numberOfPages = imageArray.count;
        _pageControl.currentPage = currentIndex;
        [self addSubview:_pageControl];
        _pageControl.currentPageIndicatorTintColor = RGBA(230, 97, 224, 1);

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClick)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)tapGestureClick
{
    [self removeFromSuperview];
}

- (Class)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView classForIndex:(NSUInteger)index
{
    return [ScanBigPhotoScrollView class];
}

- (NSUInteger)pagingScrollViewPagingViewCount:(ScanBigPageScrollView *)pagingScrollView
{
    return _imageArray.count;
}

- (UIView *)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index
{
    ScanBigPhotoScrollView *photoView = [[ScanBigPhotoScrollView alloc] initWithFrame:self.bounds];
    photoView.backgroundColor = [UIColor clearColor];
    photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    return photoView;
}

- (void)pagingScrollView:(ScanBigPageScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index
{
    assert([pageView isKindOfClass:[ScanBigPhotoScrollView class]]);
    assert(index < _imageArray.count);
    
    _pageControl.currentPage = index;
    
    ScanBigPhotoScrollView *photoView = (ScanBigPhotoScrollView *)pageView;
//    UIImage *image = [_imageArray objectAtIndex:index];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[index]]];
    [photoView displayImage:imageView.image];
}

- (void)displayPagingViewAtIndex:(NSInteger)index
{
    [_pagingScrollView displayPagingViewAtIndex:index];
}

@end
