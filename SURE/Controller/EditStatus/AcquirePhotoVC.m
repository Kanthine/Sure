//
//  AcquirePhotoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/12.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BottomViewHeight 50

#import "AcquirePhotoVC.h"

#import "PhotoLibraryViewController.h"
#import "TakeFilerPhotoVC.h"
#import "TakeVideoVC.h"
#import "EditImageModel.h"

#import "OperationPhotoVC.h"

@interface AcquirePhotoVC ()

<PhotoLibraryViewControllerDelegate,UINavigationControllerDelegate,TakeFilerPhotoVCDelegate,TakeVideoVCDelegate>

{
    UIViewController *_currentViewController;
}


@property (nonatomic ,strong) PhotoLibraryViewController *libraryPhotoVC;
@property (nonatomic ,strong) TakeFilerPhotoVC *cameraVC;
@property (nonatomic ,strong) TakeVideoVC *takeVideoVC;

@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIViewController *currentVC;

@end

@implementation AcquirePhotoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.bottomView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_cameraVC == nil)
    {
        [self setCameraChildViewController];
    }

    
    if (_libraryPhotoVC == nil)
    {
        [self setPhotoLibraryChildViewController];
    }
    
    if (_takeVideoVC == nil)
    {
        [self setVideoChildViewController];
    }
    
//    [self takeVideoFinishedWithPath:nil ThumbImage:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - BottomViewHeight, ScreenWidth, BottomViewHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        
        CGFloat buttonWidth = ScreenWidth / 3.0;
        NSArray *titleArray = @[@"相册",@"拍摄",@"录制"];
        for (int i = 0; i < titleArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, BottomViewHeight);
            button.tag = 10 + i;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(switchPhotoOriginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
        }
    }
    
    return _bottomView;
}

- (void)setCameraChildViewController
{
    _cameraVC = [[TakeFilerPhotoVC alloc]init];
    [_cameraVC.view setFrame:CGRectMake(0, 0, ScreenWidth,  ScreenHeight - BottomViewHeight)];
    _cameraVC.delegate = self;
    _cameraVC.view.clipsToBounds = YES;
    [self addChildViewController:_cameraVC];
//    
//    if (_status == AcquirePhotoStateTakePhoto)
//    {
//        [_cameraVC startCameraCapture];
//    }
}

- (void)setVideoChildViewController
{
    _takeVideoVC = [[TakeVideoVC alloc]init];
    _takeVideoVC.view.frame = CGRectMake(0, 0, ScreenWidth ,ScreenHeight - BottomViewHeight);
    _takeVideoVC.delegate = self;
    _takeVideoVC.view.clipsToBounds = YES;
    [self addChildViewController:_takeVideoVC];
    
    
//    if (_status == AcquirePhotoStateTakeVideo)
//    {
//        [_takeVideoVC startTakeVideo];
//    }
}

- (void)setPhotoLibraryChildViewController
{
    
    _libraryPhotoVC = [[PhotoLibraryViewController alloc]init];
    [_libraryPhotoVC.view setFrame:CGRectMake(0, 0, ScreenWidth ,ScreenHeight - BottomViewHeight)];
    
    if (self.navigationController == nil)
    {
        if (self.selectedImageArray)
        {
            _libraryPhotoVC.acquiredImageArray = _selectedImageArray;
        }
    }
    
    _libraryPhotoVC.view.clipsToBounds = YES;
    _libraryPhotoVC.delegate = self;
    _libraryPhotoVC.maximumNumberOfSelection = 5;
    _libraryPhotoVC.assetsFilter = [ALAssetsFilter allPhotos];
    _libraryPhotoVC.showEmptyGroups = NO;
    _libraryPhotoVC.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                                       {
                                           if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
                                           {
                                               NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                               return duration >= 5;
                                           }
                                           else
                                           {
                                               return YES;
                                           }
                                       }];
    
    [self addChildViewController:_libraryPhotoVC];
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

- (void)setStatus:(AcquirePhotoState)status
{
    _status = status;
    switch (status)
    {
        case AcquirePhotoStateTakePhoto:
        {
            [self.view  addSubview:_cameraVC.view];
            [_cameraVC didMoveToParentViewController:self];
            _currentViewController = _cameraVC;
            [_cameraVC startCameraCapture];
        }
            break;
        
        case AcquirePhotoStateLibrary:
        {
            [self.view  addSubview:_libraryPhotoVC.view];
            [_libraryPhotoVC didMoveToParentViewController:self];
            _currentViewController = _libraryPhotoVC;
        }
            break;
        case AcquirePhotoStateTakeVideo:
        {
//            [_cameraVC suspendCameraCapture];
            [self.view  addSubview:_takeVideoVC.view];
            [_takeVideoVC didMoveToParentViewController:self];
            _currentViewController = _takeVideoVC;
            
            [_takeVideoVC startTakeVideo];

        }
            
            break;
        default:
            break;
    }
    
    
    
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         
         
         if ([obj isKindOfClass:[UIButton class]])
         {
             UIButton *button = (UIButton *)obj;
             [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             if (idx == status)
             {
                 [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
             }
         }
     }];

    
}

- (void)switchPhotoOriginButtonClick:(UIButton *)sender
{
    for (UIView *view in sender.superview.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    switch (sender.tag)
    {
        case 10:
        {
            _status = AcquirePhotoStateLibrary;
            
            if (_currentViewController != _libraryPhotoVC)
            {
                
                [_takeVideoVC stopTakeVideo];
                [_cameraVC suspendCameraCapture];
                
                
                [self transitionFromViewController:_currentViewController toViewController:_libraryPhotoVC duration:1 options:UIViewAnimationOptionTransitionNone animations:^
                 {
                 }  completion:^(BOOL finished)
                 {
                     
                     _currentViewController= _libraryPhotoVC;
                     
                 }];
                
            }
        }
            break;
        case 11:
        {
             _status = AcquirePhotoStateTakePhoto;
            if (_currentViewController != _cameraVC)
            {
                [_takeVideoVC stopTakeVideo];
//                 [_cameraVC startCameraCapture];
                [self transitionFromViewController:_currentViewController toViewController:_cameraVC duration:1 options:UIViewAnimationOptionTransitionNone animations:^
                 {
                     
                     
                 }  completion:^(BOOL finished)
                 {
                     
                     _currentViewController= _cameraVC;
                    
                     
                     [_cameraVC startCameraCapture];
                 }];

            }
            
        }
            break;
           case 12:
        {
            _status = AcquirePhotoStateTakeVideo;
            
            if (_currentViewController != _takeVideoVC)
            {
                
                [_cameraVC suspendCameraCapture];
//                [_takeVideoVC startTakeVideo];
                
                [self transitionFromViewController:_currentViewController toViewController:_takeVideoVC duration:1 options:UIViewAnimationOptionTransitionNone animations:^
                 {
                 }  completion:^(BOOL finished)
                 {
                      _currentViewController= _takeVideoVC;
                     [_takeVideoVC startTakeVideo];
                 }];
                

            }
        }
            break;
        default:
            break;
    }
    
    _currentViewController.view.frame = CGRectMake(0, 0, ScreenWidth ,ScreenHeight - BottomViewHeight);
}

#pragma mark - TakePhotoDelegate

//跳转两种情况： 1、第一次进入 push 到修剪照片  2、后续添加照片  dismiss

//照相成功 跳转
- (void)takePhotoFinshEditImageModel:(EditImageModel *)acquImage
{
    NSLog(@"takePhoto == %@",acquImage.resourceURL.path);
    
    if (self.navigationController)
    {
        OperationPhotoVC *operVC = [[OperationPhotoVC alloc]init];
        operVC.imageArray = [NSMutableArray arrayWithObject:acquImage];
        [self.navigationController pushViewController:operVC animated:YES];
    }
    else
    {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addPhotoSucceesWithImageArray:)])
        {
            [_selectedImageArray addObject:acquImage];
            [self.delegate addPhotoSucceesWithImageArray:_selectedImageArray];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

#pragma mark - AssetPickerController Delegate

//选取相册照片后，点击继续
-(void)assetPickerController:(PhotoLibraryViewController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (int i=0; i< assets.count; i++)
        {
            ALAsset *asset= assets[i];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            EditImageModel *imageModel = [[EditImageModel alloc]init];
            [asset aspectRatioThumbnail];
            imageModel.thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
            imageModel.originalImage = tempImg;
            imageModel.resourceURL = asset.defaultRepresentation.url;
            
            
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypeVideo"])
            {
                imageModel.modelType = EditImageModelTypeVideo;
            }
            else if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:@"ALAssetTypePhoto"])
            {
                imageModel.modelType = EditImageModelTypePhoto;
            }
            
            
            [imageArray addObject:imageModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
       {
           
           if (self.navigationController)
           {
               OperationPhotoVC *operVC = [[OperationPhotoVC alloc]init];
               operVC.imageArray = imageArray;
               [self.navigationController pushViewController:operVC animated:YES];
           }
           else
           {
               if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addPhotoSucceesWithImageArray:)])
               {
                   [self.delegate addPhotoSucceesWithImageArray:imageArray];
               }
               [self dismissViewControllerAnimated:YES completion:nil];
           }

       });
        
        
    });
}

-(void)assetPickerControllerDidMaximum:(PhotoLibraryViewController *)picker
{
    NSLog(@"到达上限");
}

#pragma mark - TakeVideoVCDelegate

- (void)takeVideoFinishedWithPath:(NSString *)videoPathString ThumbImage:(UIImage *)image
{
    
    EditImageModel *videoModel = [[EditImageModel alloc]init];
    videoModel.modelType = EditImageModelTypeVideo;
    videoModel.resourceURL = [NSURL fileURLWithPath:videoPathString isDirectory:YES];
    videoModel.thumbnailImage = image;
    
    if (self.navigationController)
    {
        OperationPhotoVC *operVC = [[OperationPhotoVC alloc]init];
        operVC.imageArray = [NSMutableArray arrayWithObject:videoModel];
        [self.navigationController pushViewController:operVC animated:YES];
    }
    else
    {
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addPhotoSucceesWithImageArray:)])
        {
            [_selectedImageArray addObject:videoModel];
            [self.delegate addPhotoSucceesWithImageArray:_selectedImageArray];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    NSLog(@"thumbnailImageForVideo ======== %@",error);
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}



@end
