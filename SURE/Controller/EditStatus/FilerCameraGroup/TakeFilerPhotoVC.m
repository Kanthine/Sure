//
//  TakeFilerPhotoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define Height ScreenHeight - 50


#import "TakeFilerPhotoVC.h"

#import "StaticFilerChooseView.h"
//#import "FilerChooseView.h"
#import "CustomCamearFilers.h"

#import "EditImageModel.h"


#import <AssetsLibrary/AssetsLibrary.h>

@interface TakeFilerPhotoVC ()

{
    BOOL _isChooseFiler;
}

@property (nonatomic ,strong) FilerCamearManager *cameraManager;
@property (nonatomic ,strong) GPUImageStillCamera *videoCamera;

//    滤镜数组
@property (nonatomic , strong) NSArray *filtersArray;//存放 自定义的 滤镜
//    闪光灯按钮
@property (nonatomic , strong) UIButton *flashButton;
//    摄像头位置按钮
@property (nonatomic , strong) UIButton *cameraPostionButton;
//    拍照
@property (nonatomic , strong) UIButton *photoButton;
//实时滤镜背景
@property (nonatomic , strong) StaticFilerChooseView *filterChooserView;


@end

@implementation TakeFilerPhotoVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isChooseFiler = NO;
    
    [self customCamera];
    
    [self customUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againRuningCamearSession) name:@"PopBackAcquirePhoto" object:nil];

    
    [self customFilerChooseView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.cameraManager.camera.isRunning == NO)
    {
        [self.cameraManager.camera startCameraCapture];
        NSLog(@"viewWillAppear ---------  开启相机");
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.cameraManager.camera.isRunning)
    {
        [self.cameraManager.camera stopCameraCapture];
        NSLog(@"viewWillDisappear 停止相机");
    }
    
    
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"TakeFilerPhotoVC =========== didReceiveMemoryWarning");
}

- (void)customFilerChooseView
{
    _filterChooserView = [[StaticFilerChooseView alloc] initWithFrame:CGRectMake(0, Height - 60 - 130.0f, ScreenWidth, 130.0f)];
    __weak TakeFilerPhotoVC *weakSelf = self;
    
    _filterChooserView.backgroundColor = [UIColor clearColor];
    
    [_filterChooserView addSelectedEvent:^(NSInteger idx)
     {
         [weakSelf.cameraManager setFilterAtIndex:idx];
         _isChooseFiler = NO;
         [weakSelf.filterChooserView removeFromSuperview];
     }];
}


//自定义相机
- (void)customCamera
{
    _cameraManager = [[FilerCamearManager alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 4 / 3.0) superview:self.view];
    [_cameraManager addFilters:self.filtersArray];//添加 滤镜数组
    [_cameraManager setfocusImage:[UIImage imageNamed:@"cameraFocus"]];//
    
//    [self.cameraManager startCamera];//由主界面控制开启相机
}


//从编辑相册界面跳转回来，重新开始照相
-(void)againRuningCamearSession
{
    [self.cameraManager.camera startCameraCapture];
}

- (void)startCameraCapture
{
//    [self.cameraManager startCamera];
}

- (void)suspendCameraCapture
{
//    [self.cameraManager stopCamera];
}


- (void)customUI
{
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.frame = CGRectMake(ScreenWidth * 1/2.0 - 30, Height - 60, 60, 60);
    [_photoButton setImage:[UIImage imageNamed:@"camera_Photo"] forState: UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(snapshot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoButton];

    
    UIButton *filerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filerButton.frame = CGRectMake(20, Height - 60, 60, 60);
    [filerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [filerButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [filerButton addTarget:self action:@selector(switchFilerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filerButton];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    upView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:upView];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(ScreenWidth - 40,5, 30, 30);
    [_flashButton setImage:[UIImage imageNamed:@"cameraFlash_Auto"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(changeFlashMode:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:_flashButton];
    
    _cameraPostionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraPostionButton.frame = CGRectMake( ScreenWidth - 80, 5, 30, 30);
    [_cameraPostionButton setImage:[UIImage imageNamed:@"camearSwitch"] forState:UIControlStateNormal];
    [_cameraPostionButton addTarget:self action:@selector(changeCameraPostion) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:_cameraPostionButton];
    
    
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackButton.frame = CGRectMake(10, 5, 30, 30);
    [goBackButton addTarget:self action:@selector(goBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setImage:[UIImage imageNamed:@"exitButton"] forState:UIControlStateNormal];
    [upView addSubview:goBackButton];
}


#pragma mark 滤镜组

- (NSArray *)filtersArray
{
    if (!_filtersArray)
    {
        NSArray *array = [CustomCamearFilers getfilerGroupArrayWithCamear:_videoCamera];
        _filtersArray = array;
    }
    return _filtersArray;
}

#pragma mark 摄像头位置按钮

- (void)goBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchFilerButtonClick
{
    _isChooseFiler = !_isChooseFiler;
    if (_isChooseFiler)
    {
        _filterChooserView.frame = CGRectMake(ScreenWidth, Height - 60 - 130.0f, ScreenWidth, 130.0f);
        [self.view addSubview:_filterChooserView];
        [UIView animateWithDuration:.2f animations:^
        {
            _filterChooserView.frame = CGRectMake(0, Height - 60 - 130.0f, ScreenWidth, 130.0f);
            
        } completion:^(BOOL finished)
        {
            
        }];
        
    }
    else
    {
        [UIView animateWithDuration:.2f animations:^
         {
             _filterChooserView.frame = CGRectMake(- ScreenWidth, Height - 60 - 130.0f, ScreenWidth, 130.0f);
             
         } completion:^(BOOL finished)
         {
             [_filterChooserView removeFromSuperview];
         }];
    }
}


#pragma mark 拍照

- (void)snapshot
{
    [self.cameraManager snapshotSuccess:^(UIImage *image)
     {
         
         
         image = [image fixOrientation];//检查修改照片方向问题
         image = [image cropCameraImage];
         
         
         //照相成功 展示于界面 并保存至相册
         [self.cameraManager.camera stopCameraCapture];
         
         [self saveImageToPhotoAlbum:image]; //存储至相册
         
         
         NSLog(@"%@",image);
     } snapshotFailure:^
     {
         NSLog(@"拍照失败");
     }];
}

- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }
    else
    {
        msg = @"保存图片成功" ;
        [self latestAsset];
    }
    
}

- (void)latestAsset
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group)
         {
             [group setAssetsFilter:[ALAssetsFilter allPhotos]];
             [group enumerateAssetsWithOptions:NSEnumerationReverse/*遍历方式-反向*/ usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
              {
                  if (result)
                  {
                      UIImage *tempImg=[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                      EditImageModel *imageModel = [[EditImageModel alloc]init];
                      
                      imageModel.modelType = EditImageModelTypePhoto;
                      [result aspectRatioThumbnail];
                      imageModel.thumbnailImage = [UIImage imageWithCGImage:[result thumbnail]];
                      imageModel.originalImage = tempImg;
                      imageModel.resourceURL = result.defaultRepresentation.url;
                      
                      if (self.delegate && [self.delegate respondsToSelector:@selector(takePhotoFinshEditImageModel:)])
                      {
                          [self.delegate takePhotoFinshEditImageModel:imageModel];
                      }
                      
                      
                      *stop = YES;
                  }
              }];
             *stop = YES;
         }
     } failureBlock:^(NSError *error)
     {
         if (error)
         {
             
         }
     }];
}


#pragma mark 改变摄像头位置
- (void)changeCameraPostion
{
    if (self.cameraManager.cameraPosition == FilerCamearManagerDevicePositionBack)
        self.cameraManager.cameraPosition = FilerCamearManagerDevicePositionFront;
    else
        self.cameraManager.cameraPosition = FilerCamearManagerDevicePositionBack;
    
}

#pragma mark 改变闪光灯状态


- (void)changeFlashMode:(UIButton *)button
{
    switch (self.cameraManager.flashMode)
    {
        case FilerCamearManagerFlashModeAuto:
            self.cameraManager.flashMode = FilerCamearManagerFlashModeOn;
            [button setImage:[UIImage imageNamed:@"cameraFlash_On"] forState:UIControlStateNormal];
            break;
        case FilerCamearManagerFlashModeOff:
            self.cameraManager.flashMode = FilerCamearManagerFlashModeAuto;
            [button setImage:[UIImage imageNamed:@"cameraFlash_Auto"] forState:UIControlStateNormal];
            break;
        case FilerCamearManagerFlashModeOn:
            self.cameraManager.flashMode = FilerCamearManagerFlashModeOff;
            [button setImage:[UIImage imageNamed:@"cameraFlash_Off"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
