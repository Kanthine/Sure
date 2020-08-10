//
//  MergeVideoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/5.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define TimeInterval 0.05

#import "MergeVideoVC.h"

#import "EditImageModel.h"
#import "OperationPhotoVC.h"
#import "ProgressBar.h"

@interface MergeVideoVC ()

{
    NSString *pathToMovie;
}

@property (assign, nonatomic) CGFloat currentVideoDur;
@property (assign ,nonatomic) CGFloat totalVideoDur;



@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) UIButton *startButton;
@property (nonatomic ,strong) UIButton *pauseButton;
@property (nonatomic ,strong) UIButton *stopButton;
@property (nonatomic ,strong) UIView *focusView;

@property (strong, nonatomic) ProgressBar *progressBar;


@property (nonatomic ,strong) GPUImageVideoCamera *camera;
@property (nonatomic ,strong) GPUImageView * filterView;
@property (nonatomic ,strong) GPUImageMovieWriter *writerExtend;
@property (nonatomic ,strong) GPUImageOutput<GPUImageInput> *filter;

@end

@implementation MergeVideoVC

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

- (UIButton *)pauseButton
{
    
    if (_pauseButton == nil)
    {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.backgroundColor = [UIColor blueColor];
        [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
        
        _pauseButton.frame = CGRectMake(20, ScreenHeight - 64 - 60, 90, 50);
        [_pauseButton addTarget:self action:@selector(pauseButtonClcik:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _pauseButton;
}

- (UIButton *)startButton
{
    if (_startButton == nil)
    {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setFrame:CGRectMake(130, ScreenHeight  - 64 - 60, 90, 40)];
        _startButton.layer.borderWidth  = 2;
        _startButton.backgroundColor = [UIColor redColor];
        
        _startButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startButton;
}

- (UIButton *)stopButton
{
    if (_stopButton == nil)
    {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton  setFrame:CGRectMake(240, ScreenHeight - 64 - 60, 90, 40)];
        _stopButton.layer.borderWidth  = 2;
        _stopButton.backgroundColor = [UIColor purpleColor];
        _stopButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_stopButton setTitle:@"结束" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(stopButtonClcik) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _stopButton;
}


- (void)startButtonClick
{
    
    if (_totalVideoDur >= MAX_VIDEO_DUR)
    {
        NSLog(@"视频总长达到最大");
        return;
    }
    
    
    _startButton.hidden = YES;
    [self.writerExtend startRecording];
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(updateTimeLable) userInfo:nil repeats:YES];
    self.currentVideoDur = 0.0f;
    [self.progressBar addProgressView];
    [_progressBar stopShining];
}


- (void)pauseButtonClcik:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    
    if (_totalVideoDur >= MAX_VIDEO_DUR)
    {
        NSLog(@"视频总长达到最大");
        return;
    }
    
//    
//    if (sender.selected)
//    {
//        [self.writerExtend pauseRecording];
//        [_timer invalidate];
//        _timer = nil;
//        self.totalVideoDur += _currentVideoDur;
//        [_progressBar startShining];
//        
//    }
//    else
//    {
//        [self.writerExtend resumeRecording];
//        self.currentVideoDur = 0.0f;
//        _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(updateTimeLable) userInfo:nil repeats:YES];
//        [self.progressBar addProgressView];
//        [_progressBar stopShining];
//    }
    
}


- (void)stopButtonClcik
{
    [_timer invalidate];
    _timer = nil;
    
    [_progressBar startShining];
    
    
    [self.filter removeTarget:self.writerExtend];
    self.camera.audioEncodingTarget = nil;
    [self.writerExtend finishRecording];
    
    
    EditImageModel *videoModel = [[EditImageModel alloc]init];
    videoModel.modelType = EditImageModelTypeVideo;
    videoModel.resourceURL = [NSURL fileURLWithPath:pathToMovie isDirectory:YES];
    videoModel.thumbnailImage = [ self thumbnailImageForVideo:[NSURL fileURLWithPath:pathToMovie isDirectory:YES]];

    OperationPhotoVC *operVC = [[OperationPhotoVC alloc]init];
    operVC.imageArray = [NSMutableArray arrayWithObject:videoModel];
    [self.navigationController pushViewController:operVC animated:YES];

        
        
//    PlayViewController *playVC = [[PlayViewController alloc]init];
//    playVC.videoPathString = pathToMovie;
//    [self.navigationController pushViewController:playVC animated:YES];
    
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL
{
    
    NSData *data = [NSData dataWithContentsOfURL:videoURL];
    
    NSLog(@"length ====== %lu",data.length);
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL.path] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}



- (void)updateTimeLable
{
    
    self.currentVideoDur += TimeInterval;
    
    [_progressBar setLastProgressToWidth:_currentVideoDur / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    
    
    if (_totalVideoDur + _currentVideoDur >= MAX_VIDEO_DUR)
    {
        [self stopButtonClcik];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.totalVideoDur = 0.0f;
    
    
    self.view.backgroundColor = [UIColor redColor];
    
    _filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenWidth)];
    _filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [_filterView addSubview:self.focusView];
    [self.view addSubview:_filterView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [_filterView addGestureRecognizer:tapGesture];
    
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = NO;
    self.camera.horizontallyMirrorRearFacingCamera = NO;
    
    
    
    self.filter = (GPUImageOutput<GPUImageInput> * ) [[GPUImageEmbossFilter alloc] init];
    [self.camera addTarget:_filter];
    [_filter addTarget:_filterView];
    
    
    if (self.filter)
    {
        [self.camera addTarget:_filter];
        [_filter addTarget:_filterView];
    }
    else
    {
        [self.camera addTarget:_filterView];
    }
    [self.camera startCameraCapture];
    
    
    
    
    self.progressBar = [ProgressBar getInstance];
    _progressBar.frame = CGRectMake(0, _filterView.frame.origin.y + ScreenWidth, ScreenWidth, CGRectGetHeight( _progressBar.frame));
    
    [self.view addSubview:_progressBar];
    [_progressBar startShining];
    
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.pauseButton];
    [self.view addSubview:self.stopButton];
    
    
    NSString *fileName = [@"Documents/" stringByAppendingFormat:@"Movie%d.m4v",(int)[[NSDate date] timeIntervalSince1970]];
    pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.writerExtend = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(ScreenWidth, ScreenWidth)];
//    _writerExtend.maxFrames = 10;
    [self.filter addTarget:self.writerExtend];
    self.camera.audioEncodingTarget = self.writerExtend;
    
    
    //最后移除内存
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

//对焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture
{
    
    CGPoint point = [gesture locationInView:gesture.view];
    
    [self showFocusRectAtPoint:point];
}

- (void)showFocusRectAtPoint:(CGPoint)point
{
    _focusView.center = point;
    
    
    
    [_filterView bringSubviewToFront:_focusView];
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
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVCaptureDevice *device = [_camera inputCamera];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported])
            {
                [device setFocusPointOfInterest:point];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
            {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
            }
            
            if ([device isExposurePointOfInterestSupported])
            {
                [device setExposurePointOfInterest:point];
            }
            
            if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device setSubjectAreaChangeMonitoringEnabled:YES];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"对焦错误:%@", error);
        }
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"baocun");
        [self save_to_photosAlbum:pathToMovie];
    }
}
-(void)save_to_photosAlbum:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error)
    {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"视频保存成功.");
        //        [MBProgressHUD showSuccess:@"视频保存成功"];
        
    }
    
}


@end
