//
//  IntroPageViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/2/21.
//  Copyright © 2017年 longlong. All rights reserved.
//


#define APPVersion @"APPVersion"

#import "IntroPageViewController.h"
#import "MainTabBarController.h"
@interface IntroPageViewController ()
<UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray<UIImage *> *imageArray;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UIScrollView *scrollView;
@end




@implementation IntroPageViewController

//第一次加载
+ (BOOL)isFirstLaunch
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [userDefaults objectForKey:APPVersion];
    
    if (lastRunVersion == nil)
    {
        [userDefaults setObject:currentVersion forKey:APPVersion];
        [userDefaults synchronize];
        return YES;
    }
    else if ([lastRunVersion isEqualToString:currentVersion] == NO)
    {
        [userDefaults setObject:currentVersion forKey:APPVersion];
        [userDefaults synchronize];
        return YES;
    }

    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self addScrollViewImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)buttonClick
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MainTabBarController *mainController = [MainTabBarController shareMainController];
    window.rootViewController = mainController;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        _scrollView.backgroundColor = RGBA(234, 246, 254, 1);

    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = RGBA(230, 97, 224, 1);
        [_pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;
}

- (NSMutableArray<UIImage *> *)imageArray
{
    if (_imageArray == nil)
    {
        _imageArray = [NSMutableArray array];
        
        [_imageArray addObject:[UIImage imageNamed:@"IntroPage_1"]];
        [_imageArray addObject:[UIImage imageNamed:@"IntroPage_2"]];
        [_imageArray addObject:[UIImage imageNamed:@"IntroPage_3"]];
    }
    
    return _imageArray;
}

- (void)addScrollViewImage
{
    [self.imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIImageView *imageView = [[UIImageView alloc]initWithImage:obj];
         imageView.frame = CGRectMake(ScreenWidth * idx, 0, ScreenWidth, ScreenHeight);
         [_scrollView addSubview:imageView];
         
     }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth * (self.imageArray.count - 1) + (ScreenWidth - 170) / 2.0, ScreenHeight - 150, 170 , 60);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitle:@"SURE TIME!" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont fontWithName:BoldFontName size:23];
//    button.layer.borderWidth = 1.5;
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.cornerRadius = 25;
//    button.clipsToBounds = YES;
    
    [_scrollView addSubview:button];

    _scrollView.contentSize = CGSizeMake(ScreenWidth * self.imageArray.count, ScreenHeight);
    
    self.pageControl.numberOfPages = self.imageArray.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / ScreenWidth;
    
    _pageControl.currentPage = index;
    
}

- (void)pageControlClick:(UIPageControl *)pageControl
{
    CGFloat x = pageControl.currentPage * ScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

@end
