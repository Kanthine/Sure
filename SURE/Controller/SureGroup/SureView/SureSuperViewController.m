//
//  SureSuperViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/13.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "SureSuperViewController.h"

@interface SureSuperViewController ()

<UIGestureRecognizerDelegate>

{
    UIImageView *_navBarImageView;
    UIImageView *_titleImageView;
}

@property (nonatomic ,strong) UIView *navBarView;



@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation SureSuperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.delegate = self;
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.clipsToBounds = YES;
        _navBarView.tag = 9856;
        
        _navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        _navBarImageView.frame = _navBarView.bounds;
        [_navBarView addSubview:_navBarImageView];
        
        
        _titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_Sure"]];
        _titleImageView.frame = CGRectMake( (ScreenWidth - 73 ) / 2.0, 20 + 12, 73, 20);
        [_navBarView addSubview:_titleImageView];
        
        
        _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
//        [_rightNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_rightNavBarButton];
    }
    
    return _navBarView;
}



#pragma mark - 

- (void)followScrollView:(UITableView *)tableView
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [tableView addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    
    UITableView *tableView = gesture.view;
    
    if (tableView.contentOffset.y <= 0 && _navBarView.frame.size.height)
    {
        return;
    }
    
    
    
    CGPoint translation = [gesture translationInView:[tableView superview]];
    
    float delta = self.lastContentOffset - translation.y;//上滑 大于0 下滑 小于 0
    self.lastContentOffset = translation.y;
    
    NSLog(@"滑动方向 ======= %f",delta);
    
    
    if (delta >= 0)
    {
        //向上滑动时，导航栏收缩
        CGFloat height = _navBarView.frame.size.height;
        //滑动中
        if (height >= 20.0)
        {
            height = height - delta;
            
            height = height >= 20 ? height : 20.0;
            
            CGFloat scale = (height - 20 ) / 44.0;
            CGFloat newWidth = 73 * scale;
            CGFloat newHeight = 20 * scale;
            
            
            
            _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _navBarImageView.frame = _navBarView.bounds;
            
            
            _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
            _titleImageView.alpha = scale;
            
            
            _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
            _rightNavBarButton.alpha = scale;
            
            tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
        }
        
    }
    else if (delta < 0)
    {
        //向下滑动时，导航栏展开
        CGFloat height = _navBarView.frame.size.height ;
        
        if (height <= 64.0)
        {
            height = height - delta;
            height = height <= 64.0 ? height : 64.0;
            
            CGFloat scale = (height - 20 ) / 44.0;
            CGFloat newWidth = 73 * scale;
            CGFloat newHeight = 20 * scale;
            
            _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _navBarImageView.frame = _navBarView.bounds;
            _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
            _titleImageView.alpha = scale;
            
            
            _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
            _rightNavBarButton.alpha = scale;
            
            tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
            
        }
    }
    
    
    if ([gesture state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat height = _navBarView.frame.size.height ;
        
        if (height >= 44 && height < 64.0)
        {
            height = 64.0;
            [UIView animateWithDuration:.2f animations:^
             {
                 CGFloat scale = (height - 20 ) / 44.0;
                 CGFloat newWidth = 73 * scale;
                 CGFloat newHeight = 20 * scale;
                 
                 
                 
                 _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
                 _navBarImageView.frame = _navBarView.bounds;
                 
                 
                 _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
                 _titleImageView.alpha = scale;
                 
                 
                 _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
                 _rightNavBarButton.alpha = scale;
                 
                 tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
                 
             }];
        }
        else if (height > 20 && height < 44)
        {
            height = 20.0;
            [UIView animateWithDuration:.2f animations:^
             {
                 CGFloat scale = (height - 20 ) / 44.0;
                 CGFloat newWidth = 73 * scale;
                 CGFloat newHeight = 20 * scale;
                 
                 
                 
                 _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
                 _navBarImageView.frame = _navBarView.bounds;
                 
                 
                 _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
                 _titleImageView.alpha = scale;
                 
                 
                 _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
                 _rightNavBarButton.alpha = scale;
                 
                 tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
                 
             }];
        }
        
        
        self.lastContentOffset = 0;
    }
}


@end
