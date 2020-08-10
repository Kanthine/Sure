//
//  TakeVideoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "TakeVideoVC.h"


#import <QuartzCore/QuartzCore.h>
#import "ProgressBar.h"
#import "FilePathManager.h"
#import "SBVideoRecorder.h"
#import "DeleteButton.h"
//#import "MBProgressHUD.h"



#import "EditImageModel.h"
#import "OperationPhotoVC.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#define TIMER_INTERVAL 0.05f

#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086


@interface TakeVideoVC ()


@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) SBVideoRecorder *recorder;



@property (strong, nonatomic) ProgressBar *progressBar;

@property (strong, nonatomic) DeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *flashButton;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL initalized;
@property (assign, nonatomic) BOOL isProcessingData;

@property (strong, nonatomic) UIView *preview;
@property (strong, nonatomic) UIImageView *focusRectView;



@end

@implementation TakeVideoVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)startTakeVideo
{
//    [_recorder.captureSession startRunning];
}

- (void)stopTakeVideo
{
//    [_recorder.captureSession stopRunning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.maskView = [self getMaskView];
    [self.view addSubview:_maskView];
    
    
    if (_initalized)
    {
        return;
    }
    
    
    self.preview = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenWidth)];
    _preview.clipsToBounds = YES;
    [self.view insertSubview:_preview belowSubview:_maskView];
    
    
    self.recorder = [[SBVideoRecorder alloc] init];
    _recorder.delegate = self;
    
    _recorder.preViewLayer.backgroundColor = [UIColor redColor].CGColor;
    _recorder.preViewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    [self.preview.layer addSublayer:_recorder.preViewLayer];
    
    
    [FilePathManager createVideoFolderIfNotExist];
    
    self.progressBar = [ProgressBar getInstance];
    _progressBar.frame = CGRectMake(0, _preview.frame.origin.y + ScreenWidth, ScreenWidth, CGRectGetHeight( _progressBar.frame));
    
    [self.view insertSubview:_progressBar belowSubview:_maskView];
    [_progressBar startShining];
    
    
    
    CGFloat buttonW = 80.0f;
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - buttonW) / 2.0, _progressBar.frame.origin.y + _progressBar.frame.size.height + 10, buttonW, buttonW)];
    [_recordButton setImage:[UIImage imageNamed:@"camera_Photo"] forState:UIControlStateNormal];
    _recordButton.userInteractionEnabled = NO;
    [self.view insertSubview:_recordButton belowSubview:_maskView];
    
    
    if (_isProcessingData == NO)
    {
        self.deleteButton = [DeleteButton getInstance];
        [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
        [ProgressBar setView:_deleteButton toOrigin:CGPointMake(15, self.view.frame.size.height - _deleteButton.frame.size.height - 10)];
        [_deleteButton addTarget:self action:@selector(pressDeleteButton) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint center = _deleteButton.center;
        center.y = _recordButton.center.y;
        _deleteButton.center = center;
        
        [self.view insertSubview:_deleteButton belowSubview:_maskView];
    }
    
    CGFloat okButtonW = 50;
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, okButtonW, okButtonW)];
    _okButton.enabled = NO;
    
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_normal_bg.png"] forState:UIControlStateNormal];
    [_okButton setBackgroundImage:[UIImage imageNamed:@"record_icon_hook_highlighted_bg.png"] forState:UIControlStateHighlighted];
    
    [_okButton setImage:[UIImage imageNamed:@"record_icon_hook_normal.png"] forState:UIControlStateNormal];
    
    [ProgressBar setView:_okButton toOrigin:CGPointMake(self.view.frame.size.width - okButtonW - 10, self.view.frame.size.height - okButtonW - 10)];
    
    [_okButton addTarget:self action:@selector(pressOKButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint okCenter = _okButton.center;
    okCenter.y = _recordButton.center.y;
    _okButton.center = okCenter;
    
    [self.view insertSubview:_okButton belowSubview:_maskView];
    
    [self initTopLayout];
    
    [self hideMaskView];
    
    self.initalized = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_recorder.captureSession startRunning];

    NSLog(@"viewWillAppear ---------");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear +++++++++");
    [_recorder.captureSession stopRunning];

    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

}


- (void)initTopLayout
{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    backView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
    
    CGFloat buttonW = 35.0f;
    
    //关闭
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, buttonW, buttonW)];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_normal.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_disable.png"] forState:UIControlStateDisabled];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_highlighted.png"] forState:UIControlStateSelected];
    [_closeButton setImage:[UIImage imageNamed:@"record_close_highlighted.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_closeButton belowSubview:_maskView];
    
    //前后摄像头转换
    self.switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10) * 2 - 10, 5, buttonW, buttonW)];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_normal.png"] forState:UIControlStateNormal];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_disable.png"] forState:UIControlStateDisabled];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateSelected];
    [_switchButton setImage:[UIImage imageNamed:@"record_lensflip_highlighted.png"] forState:UIControlStateHighlighted];
    [_switchButton addTarget:self action:@selector(pressSwitchButton) forControlEvents:UIControlEventTouchUpInside];
    _switchButton.enabled = [_recorder isFrontCameraSupported];
    [self.view insertSubview:_switchButton belowSubview:_maskView];
    

    self.flashButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - (buttonW + 10), 5, buttonW, buttonW)];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_normal.png"] forState:UIControlStateNormal];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_disable.png"] forState:UIControlStateDisabled];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted.png"] forState:UIControlStateHighlighted];
    [_flashButton setImage:[UIImage imageNamed:@"record_flashlight_highlighted.png"] forState:UIControlStateSelected];
    _flashButton.enabled = _recorder.isTorchSupported;
    [_flashButton addTarget:self action:@selector(pressFlashButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_flashButton belowSubview:_maskView];
    
    //focus rect view
    self.focusRectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    _focusRectView.image = [UIImage imageNamed:@"touch_focus_not.png"];
    _focusRectView.alpha = 0;
    [self.preview addSubview:_focusRectView];
}

- (void)pressCloseButton
{
    if ([_recorder getVideoCount] > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"放弃这个视频真的好么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
        alertView.tag = TAG_ALERTVIEW_CLOSE_CONTROLLER;
        [alertView show];
    } else {
        [self dropTheVideo];
    }
}

- (void)pressSwitchButton
{
    _switchButton.selected = !_switchButton.selected;
    if (_switchButton.selected) {//换成前摄像头
        if (_flashButton.selected) {
            [_recorder openTorch:NO];
            _flashButton.selected = NO;
            _flashButton.enabled = NO;
        } else {
            _flashButton.enabled = NO;
        }
    } else {
        _flashButton.enabled = [_recorder isFrontCameraSupported];
    }
    
    [_recorder switchCamera];
}

- (void)pressFlashButton
{
    _flashButton.selected = !_flashButton.selected;
    [_recorder openTorch:_flashButton.selected];
}

- (void)pressDeleteButton
{
    if (_deleteButton.style == DeleteButtonStyleNormal)
    {
        //第一次按下删除按钮
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleDelete];
        [_deleteButton setButtonStyle:DeleteButtonStyleDelete];
    }
    else if (_deleteButton.style == DeleteButtonStyleDelete)
    {
        //第二次按下删除按钮
        [self deleteLastVideo];
        [_progressBar deleteLastProgress];
        
        if ([_recorder getVideoCount] > 0)
        {
            [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        }
        else
        {
            [_deleteButton setButtonStyle:DeleteButtonStyleDisable];
        }
    }
}

- (void)pressOKButton
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
    
    [_recorder mergeVideoFiles];//合并视频文件
    self.isProcessingData = YES;
}

//放弃本次视频，并且关闭页面
- (void)dropTheVideo
{
    [_recorder deleteAllVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除最后一段视频
- (void)deleteLastVideo
{
    if ([_recorder getVideoCount] > 0)
    {
        [_recorder deleteLastVideo];
    }
    
    
    
    
}

- (void)hideMaskView
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.maskView.frame;
        frame.origin.y = self.maskView.frame.size.height;
        self.maskView.frame = frame;
    }];
}

- (UIView *)getMaskView
{
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height + DELTA_Y)];
    maskView.backgroundColor = RGBA(30, 30, 30, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    label.font = [UIFont systemFontOfSize:50.0f];
    label.textColor = RGBA(100, 100, 100, 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Wait...";
    label.backgroundColor = [UIColor clearColor];
    
    [maskView addSubview:label];
    
    return maskView;
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

- (void)showFocusRectAtPoint:(CGPoint)point
{
    _focusRectView.alpha = 1.0f;
    _focusRectView.center = point;
    _focusRectView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [UIView animateWithDuration:0.2f animations:^{
        _focusRectView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.values = @[@0.5f, @1.0f, @0.5f, @1.0f, @0.5f, @1.0f];
        animation.duration = 0.5f;
        [_focusRectView.layer addAnimation:animation forKey:@"opacity"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                _focusRectView.alpha = 0;
            }];
        });
    }];
    //    _focusRectView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    //    _focusRectView.center = point;
    //    [UIView animateWithDuration:0.3f animations:^{
    //        _focusRectView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //        _focusRectView.alpha = 1.0f;
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:0.1f animations:^{
    //            _focusRectView.alpha = 0.0f;
    //        }];
    //    }];
}


//- (void)startProgressTimer
//{
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
//    self.progressCounter = 0;
//}
//
//- (void)stopProgressTimer
//{
//    [_progressTimer invalidate];
//    self.progressTimer = nil;
//}
//
//- (void)onTimer:(NSTimer *)timer
//{
//    self.progressCounter++;
//    [_progressBar setLastProgressToWidth:self.progressCounter * TIMER_INTERVAL / MAX_VIDEO_DUR * DEVICE_SIZE.width];
//}

#pragma mark - SBVideoRecorderDelegate

//recorder开始录制一段视频时
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
}

//recorder完成一段视频的录制时
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"录制视频错误:%@", error);
    } else {
        NSLog(@"录制视频完成: %@", outputFileURL);
    }
    
    [_progressBar startShining];
    
    if (totalDur >= MAX_VIDEO_DUR) {
        [self pressOKButton];
    }
}

//recorder  删除最后一段视频段视频
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error) {
        NSLog(@"删除视频错误: %@", error);
    } else {
        NSLog(@"删除了视频: %@", fileURL);
        NSLog(@"现在视频长度: %f", totalDur);
    }
    
    //删除完成后 ，更新删除按钮界面
    if ([_recorder getVideoCount] > 0)
    {
        [_deleteButton setStyle:DeleteButtonStyleNormal];
    }
    else
    {
        [_deleteButton setStyle:DeleteButtonStyleDisable];
    }
    
    _okButton.enabled = (totalDur >= MIN_VIDEO_DUR);
}

//recorder正在录制的过程中
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    _okButton.enabled = (videoDuration + totalDur >= MIN_VIDEO_DUR);
}

//recorder完成视频的合成
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL
{
    [_hud hide:YES];

    
    if (outputFileURL == nil)
    {
        self.isProcessingData = YES;

        return;
    }
    
    self.isProcessingData = NO;
    
    UIImage *image = [self thumbnailImageForVideo:outputFileURL];
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(takeVideoFinishedWithPath:ThumbImage:)])
    {
        [self.delegate takeVideoFinishedWithPath:outputFileURL.path ThumbImage:image];
    }
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

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData)
    {
        return;
    }
    
    if (_deleteButton.style == DeleteButtonStyleDelete)
    {
        //取消删除
        [_deleteButton setButtonStyle:DeleteButtonStyleNormal];
        [_progressBar setLastProgressToStyle:ProgressBarProgressStyleNormal];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:_recordButton.superview];
    if (CGRectContainsPoint(_recordButton.frame, touchPoint))
    {
        //得到文件路径 开始录制
        NSString *filePath = [FilePathManager getVideoSaveFilePathString];
        [_recorder startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath]];
    }
    
    touchPoint = [touch locationInView:self.view];//previewLayer 的 superLayer所在的view
    if (CGRectContainsPoint(_recorder.preViewLayer.frame, touchPoint))
    {
        [self showFocusRectAtPoint:touchPoint];//对焦
        [_recorder focusInPoint:touchPoint];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isProcessingData)
    {
        return;
    }
    //停止录制
    [_recorder stopCurrentVideoRecording];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case TAG_ALERTVIEW_CLOSE_CONTROLLER:
        {
            switch (buttonIndex) {
                case 0:
                {
                }
                    break;
                case 1:
                {
                    [self dropTheVideo];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}



@end
