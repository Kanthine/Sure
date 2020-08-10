//
//  PhotoPreviewContentVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/30.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PhotoPreviewContentVC.h"
#import "SurePhotoModel.h"
#import "BrandTagView.h"

@interface PhotoPreviewContentVC ()
<UIScrollViewDelegate>

{
    SurePhotoModel *_photoModel;
}

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation PhotoPreviewContentVC

- (instancetype)initWithSureModel:(SurePhotoModel *)photoModel
{
    self = [super init];
    
    if (self)
    {
        _photoModel = photoModel;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:self.scrollView];
    self.imageView.image = _photoModel.originalImage;
    
    [self addBrandTag];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _scrollView.zoomScale = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBrandTag
{
    
    if (_photoModel.brandTagArray && _photoModel.brandTagArray.count)
    {
        
        __weak __typeof(self)weakSelf = self;

        [_photoModel.brandTagArray  enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            CGFloat x = [[obj objectForKey:ImageWidthRateKey] floatValue] * ScreenWidth;
            CGFloat y = [[obj objectForKey:ImageHeightRateKey] floatValue] * ScreenWidth;
            NSString *tagString = [obj objectForKey:ImageBrandTitle];
            NSString *goodID = [obj objectForKey:ImageGoodID];
            
            BrandTagView *tagView = [[BrandTagView alloc]initWithFrame:CGRectMake(x, y, 100, BrandTagViewHEIGHT) Title:tagString TagIndex:0];
            tagView.tag = 12 + idx;
            tagView.goodIDString = goodID;
            tagView.isCanMove = NO;
            tagView.isCanDelete = NO;
            [weakSelf.imageView addSubview:tagView];
            [weakSelf.imageView bringSubviewToFront:tagView];
            tagView.tapBrandTagClick = ^(NSString *goodIDString)
            {
//                weakSelf.tapTagClick(goodIDString);
            };

        }];
    }
    
    

}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44)];
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
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 44);
        [_scrollView addSubview:self.imageView];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (ScreenHeight -ScreenWidth - 44) / 2.0 , ScreenWidth, ScreenWidth)];
    }
    return _imageView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
