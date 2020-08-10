//
//  PhotoPreviewViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PhotoPreviewViewController.h"

#import "SurePhotoModel.h"
#import "PhotoPreviewContentVC.h"

@interface PhotoPreviewViewController ()

<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

{
    UILabel *_titleLable;
    
    NSMutableArray<SurePhotoModel *> *_modelArray;
    NSUInteger _index;
}

@property (nonatomic ,strong) UIView *navBarView;

@property (nonatomic,strong)  NSMutableArray<PhotoPreviewContentVC*> *controllerArray;//子控制器
@property (nonatomic ,strong) UIPageViewController *pageViewController;

@end

@implementation PhotoPreviewViewController

- (instancetype)initWithModelArray:(NSMutableArray<SurePhotoModel *>*)modelArray IndexPath:(NSInteger)index
{
    self = [super init];
    
    if (self)
    {
        _index = index;
        _modelArray = modelArray;
        [self addChildViewController:self.pageViewController];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.pageViewController.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 44);
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:cancelButton];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        [imageView setTransform:CGAffineTransformMakeRotation(M_PI)];
        imageView.frame = CGRectMake(10, 14, 9, 15);
        [_navBarView addSubview:imageView];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 80)/2.0, 0, 80, 44)];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = [NSString stringWithFormat:@"%ld/%ld",_index + 1,_modelArray.count];
        [_navBarView addSubview:_titleLable];
        
        UIButton *deletePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deletePhotoButton.frame = CGRectMake(ScreenWidth - 70, 0, 60, 44);
        deletePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        deletePhotoButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [deletePhotoButton addTarget:self action:@selector(deletePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [deletePhotoButton setTitle:@"删除" forState:UIControlStateNormal];
        [deletePhotoButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        [_navBarView addSubview:deletePhotoButton];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineView.backgroundColor = GrayLineColor;
        [_navBarView addSubview:lineView];
    }
    return _navBarView;
}

- (void)cancelButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)deletePhotoButtonClick
{    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"要删除这张照片吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"要删除这张照片吗?"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:TextColor149 range:NSMakeRange(0, 2)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 2)];
    if ([actionSheet valueForKey:@"attributedTitle"])
    {
        [actionSheet setValue:alertControllerStr forKey:@"attributedTitle"];
    }

    
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf deletePhotoWithIndex:_index];
                                    }];

    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:deleteAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)deletePhotoWithIndex:(NSUInteger)index
{
    
}

#pragma mark - UIPageViewController

- (UIPageViewController *)pageViewController
{
    if (_pageViewController == nil)
    {
        NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(8)};
        
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageViewController.navigationController.navigationBarHidden = YES;
        _pageViewController.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight -44);
        
        [_pageViewController setViewControllers:@[self.controllerArray[_index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
         {
             
         }];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    
    return _pageViewController;
}


#pragma mark - UIPageViewControllerDelegate

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(PhotoPreviewContentVC *)viewController
{
    
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    _index = index;

    
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
    _titleLable.text = [NSString stringWithFormat:@"%ld/%ld",_index,_modelArray.count];

    
    return contentVC;
    
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(PhotoPreviewContentVC *)viewController
{
    
    NSUInteger index = [self.controllerArray indexOfObject:viewController];
    
    _index = index;
    

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
    
    _titleLable.text = [NSString stringWithFormat:@"%ld/%ld",_index,_modelArray.count];

    
    NSLog(@"contentVC ===== %@",contentVC);
    
    return contentVC;
    
}

- (NSMutableArray<PhotoPreviewContentVC*> *)controllerArray
{
    if (_controllerArray == nil)
    {
//        __weak __typeof__(self) weakSelf = self;
        _controllerArray = [NSMutableArray array];
        
        [_modelArray enumerateObjectsUsingBlock:^(SurePhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            PhotoPreviewContentVC *contentVC = [[PhotoPreviewContentVC alloc]initWithSureModel:obj];
            [_controllerArray addObject:contentVC];
        }];
        
     
        NSLog(@"_controllerArray ==== %@",_controllerArray);
    }
    
    return _controllerArray;
}



@end
