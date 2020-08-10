//
//  PhotoResourceVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BottomViewHeight 49.0f

#import "PhotoResourceVC.h"

#import "CamearDeviceManager.h"
#import "AllPhotosViewController.h"
#import "PhotoStreamsViewController.h"
#import "VideoStreamsViewController.h"

#import "PhotoEditViewController.h"

@interface PhotoResourceVC ()

<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic ,assign) PhotoResourceContentTpye contentType;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic,strong)NSArray<UIViewController*> *controllerArray;//子控制器
@property (nonatomic,strong)UIView *bottomView;//顶部带选择标题容器


@property (nonatomic ,strong) CamearDeviceManager *camearManager;

@end

@implementation PhotoResourceVC

- (instancetype)initWithContentType:(PhotoResourceContentTpye)contentType
{
    self = [super init];
    
    if (self)
    {
        _contentType = contentType;
        
        [self addChildViewController:self.pageViewController];
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.bottomView];
    
    
//    UIViewController *vc = self.controllerArray[_joinType];
//    vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - BottomViewHeight);
//    vc.view.tag = 10;
//    [self.view addSubview:vc.view];
    
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//- (void)addSomeChildViewController
//{
//    [self.controllerArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
//    {
//        [self addChildViewController:obj];
//    }];
//}


- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - BottomViewHeight, ScreenWidth, BottomViewHeight)];
        
        NSArray *array = @[@"图库",@"相机",@"视频"];
        
        
        CGFloat buttonWidth = ScreenWidth / 3.0;
        
        for (int i = 0; i < 3; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, BottomViewHeight);
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 1;
            if (_contentType == i)
            {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [_bottomView addSubview:button];
        }
        
        
        
    }
    
    return _bottomView;
}

- (void)bottomButtonClick:(UIButton *)sender
{
    NSUInteger index = sender.tag - 1;
    
    UIPageViewControllerNavigationDirection  direction;
    
    if (self.contentType < index)
    {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    else
    {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    self.contentType = index;
    
//    UIView *vcView = [self.view viewWithTag:10];
//    if (vcView)
//    {
//        [vcView removeFromSuperview];
//    }
//    
//    UIViewController *vc = self.controllerArray[index];
//    vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - BottomViewHeight);
//    vc.view.tag = 10;
//    [self.view addSubview:vc.view];
    

    [_pageViewController setViewControllers:@[self.controllerArray[index]] direction:direction animated:NO completion:^(BOOL finished)
     {
         
     }];
}

- (void)setContentType:(PhotoResourceContentTpye)contentType
{
    _contentType = contentType;
    
    [_bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[UIButton class]])
         {
             UIButton *button = (UIButton *)obj;
             
             if (button.tag - 1 == contentType)
             {
                 [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
             }
             else
             {
                 [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             }
             
         }
     }];
    
    
}

- (CamearDeviceManager *)camearManager
{
    if (_camearManager == nil)
    {
        _camearManager = [[CamearDeviceManager alloc]init];
    }
    
    return _camearManager;
}

- (NSArray<UIViewController*> *)controllerArray
{
    if (_controllerArray == nil)
    {
        __weak __typeof__(self) weakSelf = self;
        AllPhotosViewController *photoLibraryVC = [[AllPhotosViewController alloc]init];
        photoLibraryVC.cancelAllPhotosButtonClick = ^
        {
            [weakSelf dismissPhotoResourceViewController];
        };
        photoLibraryVC.nextStepAllPhotosButtonClick = ^(SurePhotoModel *photoModel)
        {
             [weakSelf nextStepClickWithModel:photoModel];
        };
        
        
        
        PhotoStreamsViewController *photoStreamsVC = [[PhotoStreamsViewController alloc]initWithCamearManager:self.camearManager];
        photoStreamsVC.cancelPhotoStreamsClick = ^
        {
            [weakSelf dismissPhotoResourceViewController];
        };
        photoStreamsVC.nextStepPhotoStreamsClick = ^(SurePhotoModel *photoModel)
        {
            [weakSelf nextStepClickWithModel:photoModel];
        };

        
        VideoStreamsViewController *videoStreamsVC = [[VideoStreamsViewController alloc]initWithCamearManager:self.camearManager];
        videoStreamsVC.cancelVideoStreamsClick = ^
        {
            [weakSelf dismissPhotoResourceViewController];
        };
        videoStreamsVC.nextStepVideoStreamsClick = ^(SurePhotoModel *photoModel)
        {
            [weakSelf nextStepClickWithModel:photoModel];
        };
        
        _controllerArray = @[photoLibraryVC,photoStreamsVC,videoStreamsVC];
    }
    
    return _controllerArray;
}

- (void)dismissPhotoResourceViewController
{
    
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextStepClickWithModel:(SurePhotoModel *)moedl
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        
        return;
    }
    
    PhotoEditViewController *editVC = [[PhotoEditViewController alloc]initWithPhotoModel:moedl];
    editVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (UIPageViewController *)pageViewController
{
    if (_pageViewController == nil)
    {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};

        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - BottomViewHeight);


        NSLog(@"gestureRecognizers === %@",_pageViewController.gestureRecognizers);






        [_pageViewController setViewControllers:@[self.controllerArray[_contentType]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
        {

        }];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }

    return _pageViewController;
}


#pragma mark - UIPageViewControllerDelegate

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    self.contentType = index;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    
    
    
    if (([self.controllerArray count] == 0) || (index >= [self.controllerArray count]))
    {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    UIViewController *contentVC = [self.controllerArray objectAtIndex:index];
    return contentVC;
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    
    self.contentType = index;
    
    NSLog(@"contentVC ===== %ld",index);

    
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
    
    
    NSLog(@"contentVC ===== %@",contentVC);
    
    return contentVC;

}

@end
