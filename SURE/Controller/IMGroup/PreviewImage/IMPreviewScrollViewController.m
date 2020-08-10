//
//  IMPreviewScrollViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "IMPreviewScrollViewController.h"
#import "IMPreviewViewController.h"

@interface IMPreviewScrollViewController ()
<UIPageViewControllerDelegate, UIPageViewControllerDataSource,IMPreviewViewControllerDelegate>

{
    NSArray *_imageArray;
    NSUInteger _index;
}

@property (nonatomic ,strong) UIView *navBarView;

@property (nonatomic,strong)  NSMutableArray<IMPreviewViewController*> *controllerArray;//子控制器
@property (nonatomic ,strong) UIPageViewController *pageViewController;


@end

@implementation IMPreviewScrollViewController

- (instancetype)initWithImageArray:(NSArray *)imageArray CurrentIndex:(NSInteger)currentIndex
{
    self = [super init];
    
    if (self)
    {
        _index = currentIndex;
        _imageArray = imageArray;
        [self addChildViewController:self.pageViewController];
    
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.pageViewController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewController

- (UIPageViewController *)pageViewController
{
    if (_pageViewController == nil)
    {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(8)};
        
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.navigationController.navigationBarHidden = YES;
        _pageViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [_pageViewController setViewControllers:@[self.controllerArray[_index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
         {
             
         }];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}


#pragma mark - UIPageViewControllerDelegate

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(IMPreviewViewController *)viewController
{
    
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    _index = index;
    
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    
    if (([self.controllerArray count] == 0) || (index >= [self.controllerArray count]))
    {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UIViewController *contentVC = [self.controllerArray objectAtIndex:index];
    
    
    return contentVC;
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(IMPreviewViewController *)viewController
{
    
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    
    _index = index;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if ([self.controllerArray count] == 0 || index == [self.controllerArray count])
    {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UIViewController *contentVC = [self.controllerArray objectAtIndex:index];
    
    

    return contentVC;
    
}

- (NSMutableArray<IMPreviewViewController*> *)controllerArray
{
    if (_controllerArray == nil)
    {
        _controllerArray = [NSMutableArray array];
        
        [_imageArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             IMPreviewViewController *contentVC = [[IMPreviewViewController alloc]initWithImage:obj];
             contentVC.delegate = self;
             [_controllerArray addObject:contentVC];
         }];

    }
    
    return _controllerArray;
}

- (void)tapImageClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
