//
//  CamearDeviceManager.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define COUNT_DUR_TIMER_INTERVAL 0.05

#define MIN_VIDEO_DUR 2.0f
#define MAX_VIDEO_DUR 8.0f

#define VIDEO_FOLDER @"videos"


#import "CamearDeviceManager.h"
#import "FilePathManager.h"

@interface VideoManagerData: NSObject//视频数据 时长 地址 两个属性

@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSURL *fileURL;

@end

@implementation VideoManagerData
@end


@interface CamearDeviceManager ()
<AVCaptureFileOutputRecordingDelegate,UIGestureRecognizerDelegate>


@property (nonatomic ,strong) UIButton *camearPostionButton;
@property (nonatomic ,strong) UIButton *flashModelButton;

/* 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入） */
@property(nonatomic ,strong)AVCaptureDevice *device;

/* 会话 */
@property(nonatomic ,strong)AVCaptureSession *session;

/* 输入设备，使用AVCaptureDevice 来初始化 */
@property(nonatomic ,strong)AVCaptureDeviceInput *videoInput;
@property(nonatomic ,strong)AVCaptureDeviceInput *audioInput;

/* 摄像头位置 */
@property (nonatomic , assign) CamearDeviceManagerDevicePosition cameraPosition;
/* 闪光灯模式 */
@property (nonatomic , assign) CamearDeviceManagerFlashMode flashMode;


/* 图像预览层，实时显示捕获的图像 */
@property(nonatomic ,strong)AVCaptureVideoPreviewLayer *previewLayer;

/* 记录开始的缩放比例 */
@property(nonatomic,assign)CGFloat beginGestureScale;

/* 最后的缩放比例 */
@property(nonatomic,assign)CGFloat effectiveScale;

/* 对焦 */
@property(nonatomic ,strong) UIView *focusView;




/* 分段录制数据 */
@property (strong, nonatomic) NSTimer *countDurTimer;
@property (assign, nonatomic) CGFloat currentVideoDur;
@property (assign, nonatomic) NSURL *currentFileURL;
@property (assign ,nonatomic) CGFloat totalVideoDur;

@property (strong, nonatomic) NSMutableArray *videoFileDataArray;



@end



@implementation CamearDeviceManager

- (void)dealloc
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       _session = nil;
                       _previewLayer = nil;
                       _device = nil;
                       _videoInput = nil;
                       _audioInput = nil;
                       _videoFileDataArray = nil;
                   });
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.effectiveScale = self.beginGestureScale = 1.0f;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
           //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
           self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
           
           //使用设备初始化输入
           self.videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
           self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
           
           //生成会话，用来结合输入输出
           self.session = [[AVCaptureSession alloc]init];//2448 × 3264


           
           if ([self.session canAddInput:self.videoInput])
           {
               [self.session addInput:self.videoInput];
           }
           if ([self.session canAddInput:self.audioInput])
           {
               [self.session addInput:self.audioInput];
           }

           
            //生成输出对象
           self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
           
           if ([self.session canAddOutput:self.ImageOutPut])
           {
               [self.session addOutput:self.ImageOutPut];
           }
           //生成输出对象
           self.moiveOutPut = [[AVCaptureMovieFileOutput alloc] init];
           if ([self.session canAddOutput:self.moiveOutPut])
           {
               [self.session addOutput:self.moiveOutPut];
           }
           self.videoFileDataArray = [[NSMutableArray alloc] init];
           self.totalVideoDur = 0.0f;
           
           
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

//           self.session.sessionPreset = AVCaptureSessionPresetHigh;

           
           
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
           
           [self.session startRunning];

           _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
           _focusView.layer.borderWidth = 1.0;
           _focusView.layer.borderColor =[UIColor greenColor].CGColor;
           _focusView.backgroundColor = [UIColor clearColor];
           _focusView.hidden = YES;
           
           UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
           
           //缩放手势
           UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
           pinch.delegate = self;
           
           dispatch_async(dispatch_get_main_queue(), ^
          {
              [self.streamesView.layer addSublayer:self.previewLayer];
              [self.streamesView addSubview:_focusView];
              [self.streamesView addGestureRecognizer:tapGesture];
              [self.streamesView addGestureRecognizer:pinch];
              [self.streamesView addSubview:self.camearPostionButton];
              [self.streamesView addSubview:self.flashModelButton];
          });
       });
    }
    return self;
}

- (UIView *)streamesView
{
    if (_streamesView == nil)
    {
        _streamesView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
        _streamesView.clipsToBounds = YES;
        _streamesView.backgroundColor = [UIColor blackColor];
    }
    
    return _streamesView;
}

- (UIButton *)flashModelButton
{
    if (_flashModelButton == nil)
    {
        
        UIButton *flashModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        flashModelButton.frame = CGRectMake(ScreenWidth - 60, ScreenWidth - 60, 60, 60);
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
        camearPostionButton.frame = CGRectMake(0, ScreenWidth - 60, 60, 60);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 25, 25)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"camearSwitch"];
        [camearPostionButton addSubview:imageView];        [camearPostionButton addTarget:self action:@selector(camearPostionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _camearPostionButton = camearPostionButton;
    }
    return _camearPostionButton;
    
}

- (void)camearPostionButtonClick:(UIButton *)sender
{
    if (_cameraPosition == CamearDeviceManagerDevicePositionBack)
    {
        self.cameraPosition = CamearDeviceManagerDevicePositionFront;
    }
    else if (_cameraPosition == CamearDeviceManagerDevicePositionFront)
    {
        self.cameraPosition = CamearDeviceManagerDevicePositionBack;
    }
}

- (void)flashModelButtonClick:(UIButton *)sender
{
    UIImageView *imageView = [sender viewWithTag:23];
    
    switch (_flashMode)
    {
        case CamearDeviceManagerFlashModeAuto:
            imageView.image = [UIImage imageNamed:@"cameraFlash_Off"];
            self.flashMode = CamearDeviceManagerFlashModeOff;
            break;
        case CamearDeviceManagerFlashModeOff:
            imageView.image = [UIImage imageNamed:@"cameraFlash_On"];
            self.flashMode = CamearDeviceManagerFlashModeOn;
            break;
        case CamearDeviceManagerFlashModeOn:
            imageView.image = [UIImage imageNamed:@"cameraFlash_Auto"];
            self.flashMode = CamearDeviceManagerFlashModeAuto;
            break;
        default:
            break;
    }
}

- (void)startRunning
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        if ([self.session isRunning] == NO)
        {
            NSLog(@"相机休眠 ---- > 启动相机");
            [self.session startRunning];
        }
        else
        {
            NSLog(@"相机运行中");
        }
        
        NSLog(@"session ====== %@",self.session);
    });
}

- (void)stopRunning
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        if ([self.session isRunning])
        {
            [self.session stopRunning];
        }
    });

}

#pragma mark 

- (void)setMidiaStreamesTpye:(CamearDeviceManagerMediaStreamesTpye)mediaStreamesTpye
{
    _mediaStreamesTpye = mediaStreamesTpye;
    
    
    if (mediaStreamesTpye == CamearDeviceManagerMediaStreamesTpyePhoto)
    {
        
    }
    else if (mediaStreamesTpye == CamearDeviceManagerMediaStreamesTpyeVideo)
    {
        
    }
    
    
    
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
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] )
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
        
        if (maxScaleAndCropFactor > 3)
        {
            maxScaleAndCropFactor = 3.0;
        }
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [self cameraBackgroundDidChangeZoom:self.effectiveScale];
        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:.025];
//        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
//        [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo].videoScaleAndCropFactor = self.effectiveScale;
//        [self.moiveOutPut connectionWithMediaType:AVMediaTypeVideo].videoScaleAndCropFactor = self.effectiveScale;
//        [CATransaction commit];
    }
}

// 数码变焦 1-3倍
- (void)cameraBackgroundDidChangeZoom:(CGFloat)zoom
{
    AVCaptureDevice *captureDevice = [self.videoInput device];
    NSError *error;
    if ([captureDevice lockForConfiguration:&error])
    {
        [captureDevice rampToVideoZoomFactor:zoom withRate:50];
    }
    else
    {
        // Handle the error appropriately.
    }
}

#pragma mark 摄像头位置

- (void)setCameraPosition:(CamearDeviceManagerDevicePosition)cameraPosition
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
        AVCaptureDevice *newAudioCamera = nil;

        if (cameraPosition == CamearDeviceManagerDevicePositionFront)
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
            
            NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
            for ( AVCaptureDevice *device in audioDevices )
            {
                if ( device.position == AVCaptureDevicePositionFront )
                {
                    newAudioCamera = device;
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
            
            NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
            for ( AVCaptureDevice *device in audioDevices )
            {
                if ( device.position == AVCaptureDevicePositionBack )
                {
                    newAudioCamera = device;
                    break;
                }
            }
            animation.subtype = kCATransitionFromLeft;
        }
        NSLog(@"newAudioCamera ====== %@",newAudioCamera);
        
        
        AVCaptureDeviceInput *newVideoInput = [AVCaptureDeviceInput deviceInputWithDevice:newVideoCamera error:nil];
        AVCaptureDeviceInput *newAudioInput = [AVCaptureDeviceInput deviceInputWithDevice:newAudioCamera error:nil];

        [self.previewLayer addAnimation:animation forKey:nil];
        if (newVideoInput != nil)
        {
            [self.session beginConfiguration];
            [self.session removeInput:_videoInput];
            [self.session removeInput:_audioInput];
            
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
            if ([self.session canAddInput:newAudioInput])
            {
                [self.session addInput:newAudioInput];
                self.audioInput = newAudioInput;
            }
            else
            {
                [self.session addInput:self.audioInput];
            }
            
            
            [self.session commitConfiguration];
            
        }
        else if (error)
        {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
        
//        if (cameraPosition == CamearDeviceManagerDevicePositionFront)
//        {
//            //前置摄像头，关闭闪关灯
//            UIImageView *imageView = [_flashModelButton viewWithTag:23];
//            imageView.image = [UIImage imageNamed:@"cameraFlash_Off"];
//            self.flashMode = CamearDeviceManagerFlashModeOff;
//            _flashModelButton.hidden = YES;
//        }
//        else
//        {
//            if (_flashModelButton.hidden)
//            {
//                _flashModelButton.hidden = NO;
//            }
//
//        }
        
        
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

- (void)setFlashMode:(CamearDeviceManagerFlashMode)flashMode
{
    _flashMode = flashMode;
    
    if ([_device lockForConfiguration:nil])
    {
        switch (flashMode)
        {
            case CamearDeviceManagerFlashModeAuto:
            {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
                break;
            case CamearDeviceManagerFlashModeOff:
            {
                [_device setFlashMode:AVCaptureFlashModeOff];
            }
                break;
            case CamearDeviceManagerFlashModeOn:
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

+ (BOOL)authorizationStateAuthorized
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
       {
       }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
       {
           NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
           if([[UIApplication sharedApplication] canOpenURL:url])
           {
               [[UIApplication sharedApplication] openURL:url];
           }
       }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [APPDELEGETE.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    else
    {
        
        return YES;
    }
    return YES;
}

#pragma mark - 分段录制

//开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    self.currentFileURL = fileURL;
    
    self.currentVideoDur = 0.0f;
    [self startCountDurTimer];
    
    
    NSLog(@"开始录制");
    
    if ([_delegate respondsToSelector:@selector(videoRecorder:didStartRecordingToOutPutFileAtURL:)])
    {
        [_delegate videoRecorder:self didStartRecordingToOutPutFileAtURL:fileURL];
    }
}

//完成一段录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    self.totalVideoDur += _currentVideoDur;
    NSLog(@"本段视频长度: %f", _currentVideoDur);
    NSLog(@"现在的视频总长度: %f", _totalVideoDur);
    
    if (error)
    {
         NSLog(@"完成一段录制: %@", error);
    }
    
   

    if (!error)
    {
        VideoManagerData *data = [[VideoManagerData alloc] init];
        data.duration = _currentVideoDur;
        data.fileURL = outputFileURL;
        
        [_videoFileDataArray addObject:data];
    }
    
    if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishRecordingToOutPutFileAtURL:duration:totalDur:error:)])
    {
        [_delegate videoRecorder:self didFinishRecordingToOutPutFileAtURL:outputFileURL duration:_currentVideoDur totalDur:_totalVideoDur error:error];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    
    NSLog(@"error =========== %@",error);
    
    
}

- (void)startCountDurTimer
{
    self.countDurTimer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)onTimer:(NSTimer *)timer
{
    self.currentVideoDur += COUNT_DUR_TIMER_INTERVAL;
    
    if ([_delegate respondsToSelector:@selector(videoRecorder:didRecordingToOutPutFileAtURL:duration:recordedVideosTotalDur:)])
    {
        [_delegate videoRecorder:self didRecordingToOutPutFileAtURL:_currentFileURL duration:_currentVideoDur recordedVideosTotalDur:_totalVideoDur];
    }
    
    if (_totalVideoDur + _currentVideoDur >= MAX_VIDEO_DUR)
    {
        [self stopCurrentVideoRecording];
    }
}

- (void)stopCountDurTimer
{
    [_countDurTimer invalidate];
    self.countDurTimer = nil;
}

//总时长
- (CGFloat)getTotalVideoDuration
{
    return _totalVideoDur;
}

//现在录了多少视频
- (NSUInteger)getVideoCount
{
    return [_videoFileDataArray count];
}

//开始录制视频
- (void)startRecordingToOutputFileURL:(NSURL *)fileURL
{
    if (_totalVideoDur >= MAX_VIDEO_DUR)
    {
        NSLog(@"视频总长达到最大");
        return;
    }
    
    BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:fileURL.absoluteString];
    
    NSLog(@"exit ========%d",exit);
    NSLog(@"_moiveOutPut ========%@",_moiveOutPut);
    NSLog(@"session.outputs ========%@",self.session.outputs);
    
    
    [self.moiveOutPut startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}
//停止录制
- (void)stopCurrentVideoRecording
{
    [self stopCountDurTimer];
    
    NSLog(@"==== 停止录制 ====");
    
    [_moiveOutPut stopRecording];
}

//不调用delegate
- (void)deleteAllVideo
{
    for (VideoManagerData *data in _videoFileDataArray)
    {
        NSURL *videoFileURL = data.fileURL;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath]) {
                NSError *error = nil;
                [fileManager removeItemAtPath:filePath error:&error];
                
                if (error) {
                    NSLog(@"deleteAllVideo删除视频文件出错:%@", error);
                }
            }
        });
    }
}

//删除 最后一段视频
- (void)deleteLastVideo //公有方法
{
    if ([_videoFileDataArray count] == 0)
    {
        return;
    }
    
    VideoManagerData *data = (VideoManagerData *)[_videoFileDataArray lastObject];
    
    NSURL *videoFileURL = data.fileURL;
    CGFloat videoDuration = data.duration;
    
    [_videoFileDataArray removeLastObject];
    _totalVideoDur -= videoDuration;
    
    //delete
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSString *filePath = [[videoFileURL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                       
                       NSFileManager *fileManager = [NSFileManager defaultManager];
                       if ([fileManager fileExistsAtPath:filePath])
                       {
                           NSError *error = nil;
                           [fileManager removeItemAtPath:filePath error:&error];//根据文件路径，移除文件
                           
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              //delegate
                                              if ([_delegate respondsToSelector:@selector(videoRecorder:didRemoveVideoFileAtURL:totalDur:error:)])
                                              {
                                                  [_delegate videoRecorder:self didRemoveVideoFileAtURL:videoFileURL totalDur:_totalVideoDur error:error];
                                              }
                                          });
                       }
                   });
}

//merge 合并
- (void)mergeVideoFiles
{
    NSMutableArray *fileURLArray = [[NSMutableArray alloc] init];
    for ( VideoManagerData*data in _videoFileDataArray)
    {
        [fileURLArray addObject:data.fileURL];
    }
    
    if (fileURLArray.count)
    {
        //合并 视频
        [self mergeAndExportVideosAtFileURLs:fileURLArray];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishMergingVideosToOutPutFileAtURL:)])
                           {
                               //合并完成 调用协议方法
                               [_delegate videoRecorder:self didFinishMergingVideosToOutPutFileAtURL:nil];
                           }
                       });
        
    }
}

//必须是fileURL
//截取将会是视频的中间部分
//这里假设拍摄出来的视频总是高大于宽的
/*
 视频处理主要是用到以下这几个类: AVMutableComposition、AVMutableVideoComposition、AVMutableAudioMix、AVMutableVideoCompositionInstruction、AVMutableVideoCompositionLayerInstruction、AVAssetExportSession 等。
 
 其中 AVMutableComposition 可以用来操作音频和视频的组合，
 AVMutableVideoComposition 可以用来对视频进行操作，
 AVMutableAudioMix 类是给视频添加音频的，
 AVMutableVideoCompositionInstruction和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向，
 AVAssetExportSession 是用来进行视频导出操作的。需要值得注意的是当App进入后台之后，会对使用到GPU的代码操作进行限制，会造成崩溃，而视频处理这些功能多数会使用到GPU,所以需要做对应的防错处理。
 
 
 文／junbinchencn（简书作者）
 原文链接：http://www.jianshu.com/p/5433143cccd8
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */
/*!
 @method mergeAndExportVideosAtFileURLs:
 
 @param fileURLArray
 包含所有视频分段的文件URL数组，必须是[NSURL fileURLWithString:...]得到的
 
 @discussion
 将所有分段视频合成为一段完整视频，并且裁剪为正方形
 */
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray
{
    NSLog(@"fileURLArray ===== %@",fileURLArray);
    
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);//视频尺寸
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    
    /*
     AVMutableComposition是一个可变的子类AVComposition，当你想从现有资产的新成分使用。您可以添加和删除曲目，并可以添加，删除和扩展的时间范围
     */
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    CMTime totalDuration = kCMTimeZero;//视频总时间
    
    //先去assetTrack 也为了取renderSize
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    for (NSURL *fileURL in fileURLArray)
    {
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        
        NSLog(@"asset ==== %@",asset);
        
        NSLog(@"tracks ==== %@",asset.tracks);
        
        if (!asset)
        {
            continue;
        }
        
        [assetArray addObject:asset];
        
        /*
         一般的视频至少有2个轨道，一个播放声音，一个播放画面。AVFoundation中有一个专门的类承载多媒体中的track：AVAssetTrack。
         
         tkhd中还有一个很重要的字段：track id，这是视频中track的唯一标示符。在AVAsset中，可以通过trackId，获得特定的track
         除了通过trackID获得track之外，AVAsset中还提供了其他3中方式获得track
         
         
         */
        
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        [assetTrackArray addObject:assetTrack];
        
        //视频尺寸 宽度 高度
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    }
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    //取出视频尺寸 根据最小值 裁成正方形
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++)
    {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        NSLog(@"asset ==== %@",asset);

        NSLog(@"tracks ==== %@",asset.tracks);
        /*
         AVMutableCompositionTrack是一个可变的AVCompositionTrack子类，它允许您插入，删除和规模轨道段，而不影响其低级表示（即，您执行操作是非破坏性的原件）。
         
         AVCompositionTrack定义了轨道段的时间对准约束
         
         insertTimeRange(CMTimeRange, of: AVAssetTrack, at: CMTime) 插入源轨道的时间范围。
         
         
         
         AVMutableComposition是一个可变的子类AVComposition，当你想从现有资产的新成分使用。您可以添加和删除曲目，并可以添加，删除和扩展的时间范围。
         
         
         addMutableTrack(withMediaType: String, preferredTrackID: CMPersistentTrackID)
         增加了一个空轨道到接收器。
         
         
         insertTimeRange(CMTimeRange, of: AVAsset, at: CMTime)
         插入一个指定的资产到接收机的给定时间范围内的所有曲目。
         */
        //音频
        // 管理轨道     增加了一个空轨道到接收器。
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        
        //管理时间范围
        if ([asset tracksWithMediaType:AVMediaTypeAudio] && [asset tracksWithMediaType:AVMediaTypeAudio].count)
        {
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:totalDuration
                                  error:nil];
        }
        

        //视频
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        //fix orientationissue  设置旋转矩阵变换
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);//视频时间
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影像
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    //get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:[FilePathManager getVideoMergeFilePathString]];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishMergingVideosToOutPutFileAtURL:)])
                           {
                               //合并完成 调用协议方法
                               [_delegate videoRecorder:self didFinishMergingVideosToOutPutFileAtURL:mergeFileURL];
                           }
                       });
    }];
}

- (void)loadLastImageCom:(void(^)(UIImage *image))block
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];

    if (!videoConnection)
    {
        NSLog(@"take photo failed!");
        return ;
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
         block(image);
     }];
}

/*
 *相机、录像左右滑动时做个假画面
 */
- (UIImage*)captureTheLastFrame
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth, ScreenWidth), NO, 0.0);
    [_previewLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSLog(@"viewImage ==== %@",viewImage);
    
    return viewImage;
}

@end

