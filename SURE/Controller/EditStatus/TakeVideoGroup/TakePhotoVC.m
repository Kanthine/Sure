//
//  TakePhotoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/11.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define Height ScreenHeight - 50

#import "TakePhotoVC.h"
#import "OperationPhotoVC.h"
#import "EditImageModel.h"
#import "UIImage+Extend.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface TakePhotoVC ()

<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic ,strong)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic ,strong)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic ,strong)AVCaptureMetadataOutput *output;

@property (nonatomic ,strong)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）


//图像预览层，实时显示捕获的图像
@property(nonatomic ,strong)AVCaptureVideoPreviewLayer *previewLayer;
/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 *  最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;

@property (nonatomic ,strong)UIButton *PhotoButton;
@property (nonatomic ,strong)UIButton *flashButton;
@property (nonatomic ,strong) UIView *photoView;
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIView *focusView;
@property (nonatomic ,assign)BOOL isflashOn;
@property (nonatomic ,strong)UIImage *image;

@property (nonatomic ,assign)BOOL canCa;

@end

@implementation TakePhotoVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _canCa = [self canUserCamear];
    
    if (_canCa)
    {
         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
         {
             
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againRuningCamearSession) name:@"PopBackAcquirePhoto" object:nil];
             
             self.effectiveScale = self.beginGestureScale = 1.0f;//缩放倍数 为 1
             [self customUI];
             [self customCamera];
         }
        else
        {
            self.view.backgroundColor = [UIColor whiteColor];
            return;
        }
        
    }
    else
    {
        return;
    }
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

- (void)customUI
{
    _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PhotoButton.frame = CGRectMake(ScreenWidth * 1/2.0 - 30, Height - 60, 60, 60);
    [_PhotoButton setImage:[UIImage imageNamed:@"camera_Photo"] forState: UIControlStateNormal];
    [_PhotoButton addTarget:self action:@selector(shutterCameraClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_PhotoButton];
    

    
    _photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 3 * 4)];
    _photoView.clipsToBounds = YES;
    _photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_photoView];
    
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [_photoView addSubview:_focusView];
    _focusView.hidden = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [_photoView addGestureRecognizer:tapGesture];
    
    //缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [_photoView addGestureRecognizer:pinch];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake( 45, Height - 45, 30, 30);
    [rightButton setImage:[UIImage imageNamed:@"camearSwitch"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(ScreenWidth - 75,Height - 45, 30, 30);
    [_flashButton setImage:[UIImage imageNamed:@"cameraFlash"] forState:UIControlStateNormal];
    [_flashButton addTarget:self action:@selector(FlashOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashButton];
    
    
    UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackButton.frame = CGRectMake(10, 10, 35, 35);
    [goBackButton addTarget:self action:@selector(goBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setImage:[UIImage imageNamed:@"exitButton"] forState:UIControlStateNormal];

    [self.view addSubview:goBackButton];
}

- (void)goBackButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] )
    {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    BOOL allTouchesAreOnThePreviewLayer = YES;
    
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    
    for ( i = 0; i < numTouches; ++i )
    {
        //        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint location = [recognizer locationOfTouch:i inView:_photoView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] )
        {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer )
    {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0)
        {
            self.effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
    
}

- (void)removeAVCameraDevice
{
    self.device = nil;
    self.input = nil;
    self.output = nil;
    self.ImageOutPut = nil;
    self.session = nil;
}

//自定义相机
- (void)customCamera
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];//2448 × 3264
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480])
    {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut])
    {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth / 3 * 4);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_photoView.layer addSublayer:self.previewLayer];
    
    //开始启动
//    [self.session startRunning];
    if ([_device lockForConfiguration:nil])
    {
        //默认 闪光灯关闭
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto])
        {
            [_device setFlashMode:AVCaptureFlashModeOff];
        }
        
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance])
        {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}

//闪光灯
- (void)FlashOn
{
    if ([_device lockForConfiguration:nil])
    {
        if (_isflashOn)
        {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff])
            {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                 [_flashButton setImage:[UIImage imageNamed:@"cameraFlash"] forState:UIControlStateNormal];
            }
        }
        else
        {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn])
            {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                 [_flashButton setImage:[UIImage imageNamed:@"cameraFlash"] forState:UIControlStateNormal];
            }
        }
        
        [_device unlockForConfiguration];
    }
}

//切换镜头
- (void)changeCamera
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1)
    {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil)
        {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput])
            {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

//对焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture
{
    if (self.session.isRunning)
    {
        CGPoint point = [gesture locationInView:gesture.view];
        [self focusAtPoint:point];
    }
}

- (void)focusAtPoint:(CGPoint)point
{
    //    CGSize size = self.view.bounds.size;
    CGSize size = _photoView.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error])
    {
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ])
        {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        
        
        [_photoView bringSubviewToFront:_focusView];
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^
         {
             _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
         }
                         completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.5 animations:^
              {
                  _focusView.transform = CGAffineTransformIdentity;
              }
                              completion:^(BOOL finished)
              {
                  _focusView.hidden = YES;
              }];
         }];
    }
    
}


#pragma mark - 截取照片

//照相按钮
- (void)shutterCameraClick
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection)
    {
        NSLog(@"take photo failed!");
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (imageDataSampleBuffer == NULL)
         {
             return;
         }
         
         //照相成功 展示于界面 并保存至相册
         NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         self.image = [UIImage imageWithData:imageData];//裁剪 3：4
         self.image = [self.image fixOrientation];//检查修改照片方向问题
         self.image = [self.image cropCameraImage];
         [self.session stopRunning];
         
         [self saveImageToPhotoAlbum:self.image]; //存储至相册
//         self.imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
//         self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//         [_photoView insertSubview:_imageView belowSubview:_PhotoButton];
//         self.imageView.layer.masksToBounds = YES;
//         self.imageView.image = _image;
//         
//         [self takePhotoSuccess];
     }];
}

#pragma - 保存至相册

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
        if (error) {
            
        }
    }];
}

/*
 PHAsset: 代表照片库中的一个资源，跟 ALAsset 类似，通过 PHAsset 可以获取和保存资源
 PHFetchOptions: 获取资源时的参数，可以传 nil，即使用系统默认值
 PHFetchResult: 表示一系列的资源集合，也可以是相册的集合
 PHAssetCollection: 表示一个相册或者一个时刻，或者是一个「智能相册（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等，如下图所示）
 PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
 PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数
 */



//点击取消，重新开始照相
-(void)againRuningCamearSession
{
    [self.imageView removeFromSuperview];
    [self.session startRunning];
}

#pragma mark - 检查相机权限

- (BOOL)canUserCamear
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else
    {

        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && alertView.tag == 100)
    {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}



@end
