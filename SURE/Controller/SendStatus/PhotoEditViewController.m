//
//  PhotoEditViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "BrandTagViewController.h"
#import "PhotoFilerChooseView.h"
#import "PhotoPublishViewController.h"
#import "PhotoResourceVC.h"


#import "BrandTagView.h"

@interface PhotoEditViewController ()
<BrandTagViewControllerDelegate,BrandTagViewDelegate>
{
    BOOL _isFilerImage;
    SurePhotoModel *_photoModel;
    
    
    
    
    UIButton *_playButton;
    AVPlayerItem *_playerItem;
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
}
@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) PhotoFilerChooseView *filerScrollView;
@property (nonatomic ,strong) UIView *bottomView;


@property (nonatomic ,strong) UIImageView *imageView;





@end

@implementation PhotoEditViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (instancetype)initWithPhotoModel:(SurePhotoModel *)model
{
    self = [super init];
    
    if (self)
    {
        _isFilerImage = NO;
        _photoModel = model;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    
    if (_photoModel.modelType == SureModelTypePhoto)
    {
        [self.view addSubview:self.imageView];
    }
    else if (_photoModel.modelType == SureModelTypeVideo)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        
        NSData *data =  [NSData dataWithContentsOfFile:[_photoModel.albumURL path]];

        NSLog(@"视频长度 length ======== %ld",data.length);

        [self setPlayVideoView];
    }

    [self.view addSubview:self.filerScrollView];
    [self.view addSubview:self.bottomView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    NSLog(@"length ======== %ld",UIImageJPEGRepresentation(_photoModel.originalImage, 1.0).length);

}

- (void)setPlayVideoView
{
    [_playButton removeFromSuperview];
    _playButton = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    _playerItem = nil;
    

    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_photoModel.albumURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 44, ScreenWidth, ScreenWidth);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_playerLayer];
    
    
    _playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"playVideo"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
}

- (void)playVideoButtonClick:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem)
    {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^
     {
         _playButton.alpha = 1.0f;
     }];
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
        

        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 80)/2.0, 0, 80, 44)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"编辑照片";
        [_navBarView addSubview:titleLable];
        
        UIButton *nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextStepButton.frame = CGRectMake(ScreenWidth - 70, 0, 60, 44);
        nextStepButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        nextStepButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextStepButton addTarget:self action:@selector(nextStepButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        [_navBarView addSubview:nextStepButton];

    }
    return _navBarView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = _photoModel.originalImage;
        
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapGestureClick:)];
        [_imageView addGestureRecognizer:tapGesture];
        
        
    }
    
    return _imageView;
}

- (PhotoFilerChooseView *)filerScrollView
{
    if (_filerScrollView == nil)
    {
        _filerScrollView = [[PhotoFilerChooseView alloc]initWithFrame:CGRectMake(0, ScreenWidth + 44, ScreenWidth, ScreenHeight - ScreenWidth - 44 - 50) ThumbnailImage:_photoModel.originalImage];
        _filerScrollView.backgroundColor = [UIColor blueColor];
        
        __weak __typeof__(self) weakSelf = self;
        _filerScrollView.didSelectItemAtIndexPath = ^(NSIndexPath *indexPath,UIImage *filerImage)
        {
            if (indexPath.item == 0)
            {
                _isFilerImage = NO;
            }
            else
            {
                _isFilerImage = YES;
            }
            weakSelf.imageView.image = filerImage;
        };
    }
    
    return _filerScrollView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
        _bottomView.backgroundColor =[UIColor whiteColor];
        
        
        UIButton *filerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        filerButton.frame = CGRectMake(0, 0, ScreenWidth / 2.0, 50);
        filerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [filerButton setTitle:@"滤镜" forState:UIControlStateNormal];
        [filerButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        [_bottomView addSubview:filerButton];
        
        
        UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        signButton.frame = CGRectMake(ScreenWidth / 2.0, 0, ScreenWidth / 2.0, 50);
        signButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [signButton setTitle:@"添加标签" forState:UIControlStateNormal];
        [signButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        [_bottomView addSubview:signButton];
    }
    
    return _bottomView;
}

- (void)cancelButtonClick
{
//    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextStepButtonClick
{
    if ([self verdictIsAddTag] == NO)
    {
        return;
    }
    
//    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

    
    if (_isFilerImage)
    {
        _photoModel.filerImage = _imageView.image;
    }
    [_photoModel surePhotoModellocalization];
    
    __weak __typeof__(self) weakSelf = self;

    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         if ([obj isKindOfClass:NSClassFromString(@"PhotoResourceVC")] )
         {
             
             PhotoResourceVC *resourceVC = (PhotoResourceVC *)obj;
             if (resourceVC.joinType == PhotoResourceJoinTypePush)
             {
                 PhotoPublishViewController *publishVC = [[PhotoPublishViewController alloc]init];
                 publishVC.modelArray = [NSMutableArray arrayWithObject:_photoModel];
                 [weakSelf.navigationController pushViewController:publishVC animated:YES];
             }
             else if (resourceVC.joinType == PhotoResourceJoinTypePresent)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissPhotoResourceViewControll" object:nil userInfo:@{@"model":_photoModel}];
                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
             }
                          
             
             * stop = YES;
         }
    }];
}

- (BOOL)verdictIsAddTag
{
    if (_photoModel.brandTagArray && _photoModel.brandTagArray.count)
    {
        return YES;
    }
    
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请你至少添加1个标签" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAcyion = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        
    }];
    [alertView addAction:confirmAcyion];
    [self presentViewController:alertView animated:YES completion:nil];
    
    
    return NO;
}

#pragma mark - 添加标签

/*
 * 必须确保登录
 */
- (void)imageViewTapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:_imageView];
    
    BrandTagViewController *tagVC = [[BrandTagViewController alloc]init];
    tagVC.tapPoint = tapPoint;
    tagVC.delegate = self;
    tagVC.backImageView.image = _photoModel.originalImage;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)signButtonClick
{
    BrandTagViewController *tagVC = [[BrandTagViewController alloc]init];
    tagVC.delegate = self;
    tagVC.backImageView.image = _photoModel.originalImage;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)selectedBrandTagWithSign:(NSString *)brandString BrandID:(NSString *)brandIDStr GoodsID:(NSString *)goodIDString LocationPoint:(CGPoint)tapPoint
{
    if (tapPoint.x == 0 && tapPoint.y == 0)
    {
        tapPoint = CGPointMake(ScreenWidth / 2.0, ScreenWidth / 2.0);
    }
    
    BrandTagView * tagView = [[BrandTagView alloc]initWithFrame:CGRectMake(100, 100, 100, BrandTagViewHEIGHT) Title:brandString TagIndex:_photoModel.brandTagArray.count];
    tagView.goodIDString = goodIDString;
    tagView.brandIDString = brandIDStr;
    tagView.center = tapPoint;
    tagView.delegate = self;
    tagView.isCanMove = YES;
    tagView.isCanDelete = YES;
    
    tagView.allowPanRect = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    tagView.backgroundColor = [UIColor clearColor];
    
    
    if (_photoModel.modelType == SureModelTypePhoto)
    {
        [_imageView addSubview:tagView];
        CGFloat widthRate = tagView.frame.origin.x/ _imageView.image.size.width;
        CGFloat heightRate = tagView.frame.origin.y / _imageView.image.size.height;
        
        
        NSDictionary *dict = @{ImageWidthRateKey:@(widthRate),ImageHeightRateKey:@(heightRate),ImageBrandTitle:brandString,ImageGoodID:goodIDString,ImageBrandID:brandIDStr};
        [_photoModel.brandTagArray addObject:dict];
    }
    else
    {
        [self.view addSubview:tagView];
        [self.view bringSubviewToFront:tagView];
        CGFloat widthRate = tagView.frame.origin.x/ ScreenWidth;
        CGFloat heightRate = tagView.frame.origin.y / ScreenWidth;
        
        
        NSDictionary *dict = @{ImageWidthRateKey:@(widthRate),ImageHeightRateKey:@(heightRate),ImageBrandTitle:brandString,ImageGoodID:goodIDString,ImageBrandID:brandIDStr};
        [_photoModel.brandTagArray addObject:dict];
    }
    

}

- (void)deleteTagClick:(BrandTagView *)tagView
{
    
    __weak __typeof__(self) weakSelf = self;

    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认要删除这个标签？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       
                                   }];
    UIAlertAction *confirmAcyion = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf confirmDeleteTheTag:tagView];
                                    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAcyion];
    [self presentViewController:alertView animated:YES completion:nil];
    

}

- (void)confirmDeleteTheTag:(BrandTagView *)tagView
{
    [_photoModel.brandTagArray removeObjectAtIndex:tagView.tagIndex];
    [tagView removeFromSuperview];
    tagView = nil;
}

- (void)updateTagViewFrame:(CGRect)frame Title:(NSString *)titleString BrandIDStr:(NSString *)brandIDString GoodsID:(NSString *)goodsIDstr TagIndex:(NSUInteger)index
{
    if (_photoModel.modelType == SureModelTypePhoto)
    {
        CGFloat widthRate = frame.origin.x/ _imageView.image.size.width;
        CGFloat heightRate = frame.origin.y / _imageView.image.size.height;
        NSDictionary *dict = @{ImageWidthRateKey:@(widthRate),ImageHeightRateKey:@(heightRate),ImageBrandTitle:titleString,ImageGoodID:goodsIDstr,ImageBrandID:brandIDString};
        
        [_photoModel.brandTagArray replaceObjectAtIndex:index withObject:dict];
    }
    else
    {
        CGFloat widthRate = frame.origin.x/ ScreenWidth;
        CGFloat heightRate = frame.origin.y / ScreenWidth;
        NSDictionary *dict = @{ImageWidthRateKey:@(widthRate),ImageHeightRateKey:@(heightRate),ImageBrandTitle:titleString,ImageGoodID:goodsIDstr,ImageBrandID:brandIDString};
        

        [_photoModel.brandTagArray replaceObjectAtIndex:index withObject:dict];
    }

}



@end
