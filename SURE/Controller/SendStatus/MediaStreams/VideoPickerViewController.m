//
//  VideoPickerViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//



#define COUNT_DUR_TIMER_INTERVAL 0.05

#define VIDEO_FOLDER @"videos"

#define MIN_VIDEO_DUR 2.0f
#define MAX_VIDEO_DUR 8.0f

#import "VideoPickerViewController.h"



#import "SurePhotoModel.h"

#import "FilePathManager.h"
#import "VideoPartDeleteButton.h"
#import "VideoPregressBar.h"


#import "PhotoEditViewController.h"


/*
 * 摄像头模式
 */
typedef NS_ENUM(NSInteger, VideoPickerCamearPosition)
{
    
    VideoPickerCamearPositionBack = 0, //后摄像头
    
    VideoPickerCamearPositionFront //前摄像头
};





@interface VideoPickerData: NSObject//视频数据 时长 地址 两个属性

@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSURL *fileURL;

@end

@implementation VideoPickerData
@end






@interface VideoPickerViewController ()

<UIGestureRecognizerDelegate,AVCaptureFileOutputRecordingDelegate>


@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UIImageView *recordImageView;
@property (nonatomic ,strong) UIButton *nextStepButton;


@property (nonatomic ,strong) UIButton *camearPostionButton;
@property (nonatomic ,strong) UIButton *flashModelButton;
/* 预览媒体流视图 */
@property (nonatomic ,strong) UIView *streamesView;


/* 视频输出 */
@property (nonatomic ,strong) AVCaptureMovieFileOutput *moiveOutPut;
/* 捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入） */
@property(nonatomic ,strong)AVCaptureDevice *device;
/* 会话 */
@property(nonatomic ,strong)AVCaptureSession *session;
/* 输入设备，使用AVCaptureDevice 来初始化 */
@property(nonatomic ,strong)AVCaptureDeviceInput *videoInput;
@property(nonatomic ,strong)AVCaptureDeviceInput *audioInput;
/* 摄像头位置 */
@property (nonatomic , assign) VideoPickerCamearPosition cameraPosition;
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




/* 分段录制数据 */
@property (strong, nonatomic) NSTimer *countDurTimer;
@property (assign, nonatomic) CGFloat currentVideoDur;
@property (assign, nonatomic) NSURL *currentFileURL;
@property (assign ,nonatomic) CGFloat totalVideoDur;

@property (strong, nonatomic) NSMutableArray *videoFileDataArray;
















@property (strong, nonatomic) VideoPregressBar *progressBar;

@property (strong, nonatomic) VideoPartDeleteButton *partDeleteButton;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL isProcessingData;

@end

@implementation VideoPickerViewController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
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
    [self.view addSubview:self.recordImageView];
    [self.view addSubview:self.progressBar];
    [_progressBar startShining];
    [self.view addSubview:self.partDeleteButton];
    
    [self.view addSubview:self.streamesView];
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        titleLable.text = @"录制";
        [_navBarView addSubview:titleLable];
        
        
        [_navBarView addSubview:self.nextStepButton];
        
    }
    return _navBarView;
}


- (UIButton *)nextStepButton
{
    if (_nextStepButton == nil)
    {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.frame = CGRectMake(ScreenWidth - 70, 0, 60, 44);
        _nextStepButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextStepButton addTarget:self action:@selector(nextStepButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        
        
        [_nextStepButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        _nextStepButton.enabled = NO;
    }
    
    return _nextStepButton;
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //    _cancelVideoStreamsClick();
}

- (void)nextStepButtonClick
{
    if (_isProcessingData)
    {
        return;
    }
    
    if (!self.hud)
    {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = @"努力处理中";
    }
    [_hud show:YES];
    [self.view addSubview:_hud];
    
    [self mergeVideoFiles];//合并视频文件
    self.isProcessingData = YES;
}


- (UIImageView *)recordImageView
{
    if (_recordImageView == nil)
    {
        _recordImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"camera_Photo"]];
        _recordImageView.frame = CGRectMake(ScreenWidth * 1/2.0 - 30,ScreenHeight - 44 - 80, 60, 60);
        _recordImageView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureClick:)];
        longPressGesture.minimumPressDuration = .1f;
        [_recordImageView addGestureRecognizer:longPressGesture];
    }
    
    return _recordImageView;
}

- (VideoPartDeleteButton *)partDeleteButton
{
    if (_partDeleteButton == nil)
    {
        _partDeleteButton = [[VideoPartDeleteButton alloc]initWithFrame:CGRectMake(20,   44 + ScreenWidth + 50, 70, 45)];
        [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleDisable];
        _partDeleteButton.center = CGPointMake(_partDeleteButton.center.x, _recordImageView.center.y);
        [_partDeleteButton addTarget:self action:@selector(partDeleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _partDeleteButton;
}

- (VideoPregressBar *)progressBar
{
    if (_progressBar == nil)
    {
        _progressBar = [VideoPregressBar getInstance];
        _progressBar.frame = CGRectMake(0, 44 + ScreenWidth, ScreenWidth, CGRectGetHeight( _progressBar.frame));
    }
    
    return _progressBar;
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
    if (_cameraPosition == VideoPickerCamearPositionBack)
    {
        self.cameraPosition = VideoPickerCamearPositionFront;
    }
    else if (_cameraPosition == VideoPickerCamearPositionFront)
    {
        self.cameraPosition = VideoPickerCamearPositionBack;
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





- (void)longPressGestureClick:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan)
    {
        if (_isProcessingData)
        {
            return;
        }
        _recordImageView.image = [UIImage imageNamed:@"camera_PhotoPressed"];
        
        
        if (_partDeleteButton.deleteStyle == VideoPartDeleteButtonStyleDelete)
        {
            //取消删除
            [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
            [_progressBar setLastProgressToStyle:VideoPregressBarStyleNormal];
        }
        
        //得到文件路径 开始录制
        NSString *filePath = [FilePathManager getVideoSaveFilePathString];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        
        if (_totalVideoDur >= MAX_VIDEO_DUR)
        {
            NSLog(@"视频总长达到最大");
            return;
        }
        
        NSLog(@"fileURL ========%@",fileUrl);
        
        [self startRecordingToOutputFileURL:fileUrl];
    }
    else if  (longPressGesture.state == UIGestureRecognizerStateEnded)
    {
        _recordImageView.image = [UIImage imageNamed:@"camera_Photo"];
        
        
        if (_isProcessingData)
        {
            return;
        }
        //停止录制
        [_countDurTimer invalidate];
        self.countDurTimer = nil;
        NSLog(@"==== 停止录制 ====");
        
        [_moiveOutPut stopRecording];
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if  (longPressGesture.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"UIGestureRecognizerStateCancelled");
    }
}


- (void)pressCloseButton
{
    if ([_videoFileDataArray count] > 0)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"放弃这个视频真的好么?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                       {
                                       }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                        {
                                            [self dropTheVideo];
                                        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        [self dropTheVideo];
    }
}

- (void)partDeleteButtonClick
{
    if (_partDeleteButton.deleteStyle == VideoPartDeleteButtonStyleNormal)
    {
        //第一次按下删除按钮
        [_progressBar setLastProgressToStyle:VideoPregressBarStyleDelete];
        [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleDelete];
    }
    else if (_partDeleteButton.deleteStyle == VideoPartDeleteButtonStyleDelete)
    {
        //第二次按下删除按钮
        [self deleteLastVideo];
        [_progressBar deleteLastProgress];
        
        if ([_videoFileDataArray count] > 0)
        {
            [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
        }
        else
        {
            [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleDisable];
        }
    }
}

//放弃本次视频，并且关闭页面
- (void)dropTheVideo
{
    [self deleteAllVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除最后一段视频
- (void)deleteLastVideo
{
    if ([_videoFileDataArray count] > 0)
    {
        VideoPickerData *data = (VideoPickerData *)[_videoFileDataArray lastObject];
        
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
                                  
                                  
                                  //删除完成后 ，更新删除按钮界面
                                  if ([_videoFileDataArray count] > 0)
                                  {
                                      [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
                                  }
                                  else
                                  {
                                      [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleDisable];
                                  }
                                  
                                  
                                  if (self.totalVideoDur >= MIN_VIDEO_DUR && _nextStepButton.enabled == NO)
                                  {
                                      [_nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
                                      _nextStepButton.enabled = YES;
                                  }
                                  else
                                  {
                                      [_nextStepButton setTitleColor:TextColor149 forState:UIControlStateNormal];
                                      _nextStepButton.enabled = NO;
                                      
                                  }
                              });
           }
       });
    }
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

- (void)startCountDurTimer
{
    self.countDurTimer = [NSTimer scheduledTimerWithTimeInterval:COUNT_DUR_TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (void)onTimer:(NSTimer *)timer
{
    self.currentVideoDur += COUNT_DUR_TIMER_INTERVAL;
    
    
    [_progressBar setLastProgressToWidth:self.currentVideoDur / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    
    if (self.currentVideoDur + self.totalVideoDur >= MIN_VIDEO_DUR && _nextStepButton.enabled == NO)
    {
        [_nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _nextStepButton.enabled = YES;
    }
    
    
    if (_totalVideoDur + _currentVideoDur >= MAX_VIDEO_DUR)
    {
        [_countDurTimer invalidate];
        self.countDurTimer = nil;
        
        NSLog(@"==== 停止录制 ====");
        
        [_moiveOutPut stopRecording];
    
    }
}

//开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    self.currentFileURL = fileURL;
    
    self.currentVideoDur = 0.0f;
    [self startCountDurTimer];
    
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
}



//完成一段录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    self.totalVideoDur += _currentVideoDur;
    NSLog(@"本段视频长度: %f", _currentVideoDur);
    NSLog(@"现在的视频总长度: %f", _totalVideoDur);
    
    if (!error)
    {
        VideoPickerData *data = [[VideoPickerData alloc] init];
        data.duration = _currentVideoDur;
        data.fileURL = outputFileURL;
        
        [_videoFileDataArray addObject:data];
    }
    
    [_progressBar startShining];
    
    if (self.totalVideoDur >= MAX_VIDEO_DUR)
    {
        [self nextStepButtonClick];
    }
    
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput willFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"error =========== %@",error);
    
}

//recorder完成视频的合成
- (void)didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL
{
    [_hud hide:YES];
    
    if (outputFileURL == nil)
    {
        self.isProcessingData = YES;
        return;
    }
    
    self.isProcessingData = NO;
    
    
    
    UIImage *image = [self thumbnailImageForVideo:outputFileURL];
    
    
    SurePhotoModel *model = [[SurePhotoModel alloc]init];
    model.albumURL = outputFileURL;
    model.modelType = SureModelTypeVideo;
    model.originalImage = image;
    
    
    PhotoEditViewController *editVC = [[PhotoEditViewController alloc]initWithPhotoModel:model];
    editVC.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:editVC animated:YES];
    
    
    //    _nextStepVideoStreamsClick(model);
    
}

/* 取封面 */
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL
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

#pragma mark - 初始化相机

- (void)initCamearDeviceManager
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
   {
       self.effectiveScale = self.beginGestureScale = 1.0f;

       //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
       self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
       
       //使用设备初始化输入
       self.videoInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
       self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
       
       //生成会话，用来结合输入输出
       self.session = [[AVCaptureSession alloc]init];

       self.session.sessionPreset = AVCaptureSessionPresetLow;
       
       
       if ([self.session canAddInput:self.videoInput])
       {
           [self.session addInput:self.videoInput];
       }
       if ([self.session canAddInput:self.audioInput])
       {
           [self.session addInput:self.audioInput];
       }
       
       //生成输出对象
       self.moiveOutPut = [[AVCaptureMovieFileOutput alloc] init];
       if ([self.session canAddOutput:self.moiveOutPut])
       {
           [self.session addOutput:self.moiveOutPut];
       }
       self.videoFileDataArray = [[NSMutableArray alloc] init];
       self.totalVideoDur = 0.0f;
       
       
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
        
        
        
        CGFloat  maxScaleAndCropFactor = 3.0;
        
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [self cameraBackgroundDidChangeZoom:self.effectiveScale];
        
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

- (void)setCameraPosition:(VideoPickerCamearPosition)cameraPosition
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
        
        if (cameraPosition == VideoPickerCamearPositionFront)
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

//merge 合并
- (void)mergeVideoFiles
{
    NSMutableArray *fileURLArray = [[NSMutableArray alloc] init];
    for ( VideoPickerData *data in _videoFileDataArray)
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
           [_hud hide:YES];
           self.isProcessingData = YES;
           return;
        });
        
    }
}


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
                           [self didFinishMergingVideosToOutPutFileAtURL:mergeFileURL];
                       });
    }];
}


//不调用delegate
- (void)deleteAllVideo
{
    for (VideoPickerData *data in _videoFileDataArray)
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




@end



