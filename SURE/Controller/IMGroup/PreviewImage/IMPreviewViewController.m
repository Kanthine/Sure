//
//  IMPreviewViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/21.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "IMPreviewViewController.h"



@interface IMPreviewViewController ()

<UIScrollViewDelegate>


@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation IMPreviewViewController

- (instancetype)initWithImage:(id)image
{
    self = [super init];
    
    if (self)
    {
        
        if ([image isKindOfClass:[UIImage class]])
        {
            self.imageView.image = image;
        }
        else if ([image isKindOfClass:[NSURL class]])
        {
            [self.imageView sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        else if ([image isKindOfClass:[NSString class]])
        {
            
            NSLog(@"image ======= %@",image);
            
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

        }

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _scrollView.zoomScale = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.tag = 342;
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
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        [_scrollView addSubview:self.imageView];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight)];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerClick)];
        [_imageView addGestureRecognizer:tapGestureRecognizer];
        
        
    }
    return _imageView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)tapGestureRecognizerClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapImageClick)])
    {
        [self.delegate tapImageClick];
    }
}


@end
