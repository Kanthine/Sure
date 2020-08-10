//
//  PhotoPickerViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "PhotoPickerViewController.h"

#import "SurePhotoModel.h"
#import "PhotosManager.h"

#import "PhotoEditViewController.h"


/*
 * 摄像头模式
 */
typedef NS_ENUM(NSInteger, CamearDevicePosition)
{
    
    CamearDevicePositionBack = 0, //后摄像头
    
    CamearDevicePositionFront //前摄像头
};



@interface PhotoPickerViewController ()
<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) CamearDeviceManager *deviceManager;
@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UIButton *photoButton;

/* 预览媒体流视图 */
@property (nonatomic ,strong) UIView *streamesView;
/* 图片输出 */
@property (nonatomic ,strong) AVCaptureStillImageOutput *ImageOutPut;
@property (nonatomic ,strong) UIButton *camearPostionButton;
@property (nonatomic ,strong) UIButton *flashModelButton;

/* 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入） */
@property(nonatomic ,strong)AVCaptureDevice *device;

/* 会话 */
@property(nonatomic ,strong)AVCaptureSession *session;

/* 输入设备，使用AVCaptureDevice 来初始化 */
@property(nonatomic ,strong)AVCaptureDeviceInput *videoInput;

/* 摄像头位置 */
@property (nonatomic , assign) CamearDevicePosition cameraPosition;
/* 闪光灯模式 */
@property (nonatomic , assign) AVCaptureFlashMode flashMode;


/* 图像预览层，实时显示捕获的图像 */
@property(nonatomic ,strong)AVCaptureVideoPreviewLayer *previewLayer;

/* 记录开始的缩放比例 */
@property(nonatomic,assign)CGFloat beginGestureScale;

/* 最后的缩放比例 */
@property(nonatomic,assign)CGFloat effectiveScale;

/* 对焦 */
@property(nonatomic ,strong) UIView *focusView;


@end

@implementation PhotoPickerViewController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // 初始化相机
        [self initCamearDeviceManager];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.streamesView];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.camearPostionButton];
    [self.view addSubview:self.flashModelButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       if ([self.session isRunning] == NO)
                       {
                           [self.session startRunning];
                       }
                   });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        cancelButton.frame = CGRectMake(10, 0, 60, 44);
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        [_navBarView addSubview:cancelButton];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 80)/2.0, 0, 80, 44)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"拍照";
        [_navBarView addSubview:titleLable];
    }
    return _navBarView;
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    _cancelPhotoStreamsClick();
}

- (UIButton *)photoButton
{
    if (_photoButton == nil)
    {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(ScreenWidth * 1/2.0 - 30,ScreenHeight - 44 - 80, 60, 60);
        [_photoButton setImage:[UIImage imageNamed:@"camera_Photo"] forState: UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(shutterCameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photoButton;
}

- (UIView *)focusView
{
    if (_focusView == nil)
    {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UIView *)streamesView
{
    if (_streamesView == nil)
    {
        _streamesView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
        _streamesView.clipsToBounds = YES;
        _streamesView.backgroundColor = [UIColor blackColor];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
        
        //缩放手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        pinch.delegate = self;
        
        [self.streamesView addSubview:self.focusView];
        [self.streamesView addGestureRecognizer:tapGesture];
        [self.streamesView addGestureRecognizer:pinch];
        
    }
    
    return _streamesView;
}


- (UIButton *)flashModelButton
{
    if (_flashModelButton == nil)
    {
        
        UIButton *flashModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        flashModelButton.frame = CGRectMake(ScreenWidth - 60, ScreenWidth - 60 + 44, 60, 60);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 25, 25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"cameraFlash_Off"];
        imageView.tag = 23;
        [flashModelButton addSubview:imageView];
        [flashModelButton addTarget:self action:@selector(flashModelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _flashModelButton = flashModelButton;
    }
    
    return _flashModelButton;
}

- (UIButton *)camearPostionButton
{
    if (_camearPostionButton == nil)
    {
        UIButton *camearPostionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        camearPostionButton.frame = CGRectMake(0, ScreenWidth - 60 + 44, 60, 60);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 25, 25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"camearSwitch"];
        [camearPostionButton addSubview:imageView];
        [camearPostionButton addTarget:self action:@selector(camearPostionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _camearPostionButton = camearPostionButton;
    }
    return _camearPostionButton;
    
}

- (void)camearPostionButtonClick:(UIButton *)sender
{
    if (_cameraPosition == CamearDevicePositionBack)
    {
        self.cameraPosition = CamearDevicePositionFront;
    }
    else if (_cameraPosition == CamearDevicePositionFront)
    {
        self.cameraPosition = CamearDevicePositionBack;
    }
}

- (void)flashModelButtonClick:(UIButton *)sender
{
    UIImageView *imageView = [sender viewWithTag:23];
    
    switch (_flashMode)
    {
        case AVCaptureFlashModeAuto:
            imageView.image = [UIImage imageNamed:@"cameraFlash_Off"];
            self.flashMode = AVCaptureFlashModeAuto;
            break;
        case AVCaptureFlashModeOff:
            imageView.image = [UIImage imageNamed:@"cameraFlash_On"];
            self.flashMode = AVCaptureFlashModeOff;
            break;
        case AVCaptureFlashModeOn:
            imageView.image = [UIImage imageNamed:@"cameraFlash_Auto"];
            self.flashMode = AVCaptureFlashModeOn;
            break;
        default:
            break;
    }
}

#pragma mark - 照片

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
         UIImage *image = [UIImage imageWithData:imageData];
         image = [image fixOrientation];//检查修改照片方向问题
         image = [image cropCameraImage];//裁剪 1：1
         
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
         
         
     }];
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error)
    {
        msg = @"保存图片失败";
    }
    else
    {
        msg = @"保存图片成功" ;
        __weak __typeof__(self) weakSelf = self;
        
        [PhotosManager fetchLatestAssetCompletionBlock:^(PHAsset *asset)
         {
             NSLog(@"asset ===%@",asset);
             
             PHImageManager *imageManager = [PHImageManager defaultManager];
             [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
              {
                  
                  NSLog(@"info ===%@",info);
                  BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                  
                  if (downloadFinined)
                  {
                      SurePhotoModel *model = [[SurePhotoModel alloc]init];
                      model.modelType = SureModelTypePhoto;
                      model.originalImage = result;
                      [model compressOriginalImageLength];
                      
                      
                      
                      PhotoEditViewController *editVC = [[PhotoEditViewController alloc]initWithPhotoModel:model];
                      editVC.navigationController.navigationBarHidden = YES;
                      [weakSelf.navigationController pushViewController:editVC animated:YES];
                  }
                  
              }];
         }];
    }
}

#pragma mark - 编辑 相机

- (void)initCamearDeviceManager
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       self.effectiveScale = self.beginGestureScale = 1.0f;
                       
                       //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
                       self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                       
                       //使用设备初始化输入
                       self.videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
                       
                       
                       //生成会话，用来结合输入输出
                       self.session = [[AVCaptureSession alloc]init];//2448 × 3264
                       if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
                       {
                           self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
                       }
                       else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720])
                       {
                           self.session.sessionPreset = AVCaptureSessionPreset1280x720;
                       }
                       else if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480])
                       {
                           self.session.sessionPreset = AVCaptureSessionPreset640x480;
                       }
                       
                       if ([self.session canAddInput:self.videoInput])
                       {
                           [self.session addInput:self.videoInput];
                       }
                       //生成输出对象
                       self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
                       
                       if ([self.session canAddOutput:self.ImageOutPut])
                       {
                           [self.session addOutput:self.ImageOutPut];
                       }
                       
                       
                       
                       
                       
                       
                       
                       [self.session startRunning];
                       
                       
                       //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
                       self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
                       self.previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
                       self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                       
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
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self.streamesView.layer addSublayer:self.previewLayer];
                                      });
                   });
}

#pragma mark 对焦

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
    CGSize size = self.streamesView.bounds.size;
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
        
        
        [self.streamesView bringSubviewToFront:_focusView];
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

#pragma mark 调整焦距

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    BOOL allTouchesAreOnThePreviewLayer = YES;
    
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    
    for ( i = 0; i < numTouches; ++i )
    {
        //        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint location = [recognizer locationOfTouch:i inView:self.streamesView];
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
        [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo].videoScaleAndCropFactor = self.effectiveScale;
        
        [CATransaction commit];
        
    }
}

#pragma mark 摄像头位置

- (void)setCameraPosition:(CamearDevicePosition)cameraPosition
{
    _cameraPosition = cameraPosition;
    
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1)
    {
        NSError *error;
        CATransition *animation = [CATransition animation];
        
        animation.duration = .5f;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.type = @"oglFlip";
        AVCaptureDevice *newVideoCamera = nil;
        
        if (cameraPosition == CamearDevicePositionFront)
        {
            NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for ( AVCaptureDevice *device in videoDevices )
            {
                if ( device.position == AVCaptureDevicePositionFront )
                {
                    newVideoCamera = device;
                    break;
                }
            }
            
            animation.subtype = kCATransitionFromRight;
        }
        else
        {
            NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for ( AVCaptureDevice *device in videoDevices )
            {
                if ( device.position == AVCaptureDevicePositionBack )
                {
                    newVideoCamera = device;
                    break;
                }
            }
            
            
            animation.subtype = kCATransitionFromLeft;
        }
        
        AVCaptureDeviceInput *newVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:newVideoCamera error:nil];
        
        
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newVideoInput != nil)
        {
            [self.session beginConfiguration];
            [self.session removeInput:_videoInput];
            
            //            self.device = newCamera;
            if ([newVideoCamera supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080])
            {
                //前置摄像头不支持 AVCaptureSessionPreset1920x1080
                self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
            }
            else if ([newVideoCamera supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080])
            {
                self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
            }
            else if ([newVideoCamera supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480])
            {
                self.session.sessionPreset = AVCaptureSessionPreset640x480;
            }
            
            if ([self.session canAddInput:newVideoInput])
            {
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            }
            else
            {
                [self.session addInput:self.videoInput];
            }
            
            
            [self.session commitConfiguration];
            
        }
        else if (error)
        {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
    
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
    {
        if ( device.position == position )
        {
            return device;
        }
    }
    
    return nil;
}

#pragma mark 闪光灯

- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    _flashMode = flashMode;
    
    if ([_device lockForConfiguration:nil])
    {
        switch (flashMode)
        {
            case AVCaptureFlashModeAuto:
            {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
                break;
            case AVCaptureFlashModeOff:
            {
                [_device setFlashMode:AVCaptureFlashModeOff];
            }
                break;
            case AVCaptureFlashModeOn:
            {
                [_device setFlashMode:AVCaptureFlashModeOn];
            }
                break;
            default:
                break;
        }
        
        [_device unlockForConfiguration];
    }
}


@end

