//
//  FlashView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "FlashView.h"
#import "SacnBigImageView.h"
#import "AppDelegate.h"

@interface FlashView()

<UIScrollViewDelegate>

{
    SacnBigImageView *_bigView;
    UIScrollView* _scrollView;
    NSTimer *_timer;
    UIPageControl *_pageControl;
}

@end

@implementation FlashView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)setFlashModelArray:(NSArray *)flashModelArray
{
    if ([_flashModelArray isEqualToArray:flashModelArray] == NO)
    {
        _flashModelArray = flashModelArray;
        
        
        for (UIView* v in self.subviews)
        {
            [v removeFromSuperview];
        }
        
        [self initScrollView];
        [self initPageControl];
        [self initSubViewScroll];
        
        if (_timer.valid)
        {
        }
        else
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
        
    }
}


- (void)runTimePage
{
    int page = (int)_pageControl.currentPage;
    page++;
    page = page >= _flashModelArray.count ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}

- (void)turnPage
{
    int page = (int)_pageControl.currentPage;
    [_scrollView scrollRectToVisible:CGRectMake(ScreenWidth*(page),0,ScreenWidth,_scrollView.frame.size.height) animated:NO];
    
//    if (_bigView)
//    {
//        [_bigView displayPagingViewAtIndex:_pageControl.currentPage];
//    }
}

-(void)initSubViewScroll
{
    for (int i=0; i < self.flashModelArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        imageView.contentMode =  UIViewContentModeScaleAspectFill;
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        imageView.clipsToBounds  = YES;
        
        NSURL* url = nil;
        if (_flashType == FlashViewModelTypeBrand)
        {
            BrandDetaileFlashImage *flashModel = self.flashModelArray[i];
            
            url = [NSURL URLWithString:flashModel.imageUrlStr];
        }
        else if (_flashType == FlashViewModelTypeProduct)
        {
            ProductDetaileFlashImage *flashModel = self.flashModelArray[i];
            
            url = [NSURL URLWithString:flashModel.imageUrlStr];
        }
        
        
        [imageView sd_setImageWithURL:url placeholderImage:nil];
        
        [_scrollView addSubview:imageView];
        
        UIButton *imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0 , _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        [imgBtn setContentMode:UIViewContentModeScaleAspectFill];
        [imgBtn setClipsToBounds:YES];
        [imgBtn setTag:i];
        [imgBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:imgBtn];
    }
}

//添加点击事件 图片链接
-(void)imageButtonClick:(UIButton *)sender
{
    if (_flashType == FlashViewModelTypeProduct)
    {
        [self scanBigImage];
    }
}

-(void)initScrollView
{
    if (_scrollView)
    {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(self.flashModelArray.count * self.frame.size.width, self.frame.size.height);
    NSLog(@"_scrollView.contentSize == %@ ",[NSValue valueWithCGSize:_scrollView.contentSize]);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

-(void)initPageControl
{
    if (_pageControl)
    {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake( (self.frame.size.width - 10 * self.flashModelArray.count) / 2.0, self.frame.size.height-20, 10*self.flashModelArray.count, 20)];
    _pageControl.numberOfPages = self.flashModelArray.count;
    
//    _pageControl.pageIndicatorTintColor = RGBA(230, 97, 224, 1);
    _pageControl.currentPageIndicatorTintColor = RGBA(230, 97, 224, 1);
    
    _pageControl.hidesForSinglePage = YES;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [scrollView contentOffset].x / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

//浏览大图
- (void)scanBigImage
{
    NSInteger index = _scrollView.contentOffset.x / ScreenWidth;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (ProductDetaileFlashImage *flashModel in _flashModelArray)
    {
        [array addObject:flashModel.imageUrlStr];
    }
    
    _bigView = [[SacnBigImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) ImageArray:array CurrentIndex:index];
    
    [APPDELEGETE.window addSubview:_bigView];
    [APPDELEGETE.window bringSubviewToFront:_bigView];
}

@end



