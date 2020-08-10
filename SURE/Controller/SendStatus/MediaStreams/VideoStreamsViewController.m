//
//  VideoStreamsViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define COUNT_DUR_TIMER_INTERVAL 0.05

#define VIDEO_FOLDER @"videos"

#define MIN_VIDEO_DUR 2.0f
#define MAX_VIDEO_DUR 8.0f

#import "VideoStreamsViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>


#import "SurePhotoModel.h"

#import "CamearDeviceManager.h"

#import "FilePathManager.h"
#import "VideoPartDeleteButton.h"
#import "VideoPregressBar.h"

@interface VideoStreamsViewController ()
<CamearDeviceManagerDelegate>

@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UIImageView *recordImageView;
@property (nonatomic ,strong) UIButton *nextStepButton;
@property (nonatomic ,strong) UIImageView *lastFrameImageView;

@property (strong, nonatomic) CamearDeviceManager *videoManager;

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

@implementation VideoStreamsViewController

- (instancetype)initWithCamearManager:(CamearDeviceManager *)camear
{
    self = [super init];
    
    if (self)
    {
        _videoManager = camear;
//        _videoManager = [CamearDeviceManager standardCamearDeviceManager];
        _videoManager.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.lastFrameImageView];
    [self.view addSubview:self.recordImageView];
    [self.view addSubview:self.progressBar];
    [_progressBar startShining];
    [self.view addSubview:self.partDeleteButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_videoManager startRunning];
    [self.view addSubview:_videoManager.streamesView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view bringSubviewToFront:_lastFrameImageView];
    [_videoManager loadLastImageCom:^(UIImage *image)
     {
         _lastFrameImageView.image = image;
    }];

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

- (UIImageView *)lastFrameImageView
{
    if (_lastFrameImageView == nil)
    {
        _lastFrameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
    }
    
    return _lastFrameImageView;
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
    _cancelVideoStreamsClick();
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
    
    [_videoManager mergeVideoFiles];//合并视频文件
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
        
        [_videoManager startRecordingToOutputFileURL:fileUrl];
    }
    else if  (longPressGesture.state == UIGestureRecognizerStateEnded)
    {
        _recordImageView.image = [UIImage imageNamed:@"camera_Photo"];

        
        if (_isProcessingData)
        {
            return;
        }
        //停止录制
        [_videoManager stopCurrentVideoRecording];
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    else if  (longPressGesture.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"UIGestureRecognizerStateCancelled");
    }
}


- (void)pressCloseButton
{
    if ([_videoManager getVideoCount] > 0)
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
        
        if ([_videoManager getVideoCount] > 0)
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
    [_videoManager deleteAllVideo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除最后一段视频
- (void)deleteLastVideo
{
    if ([_videoManager getVideoCount] > 0)
    {
        [_videoManager deleteLastVideo];
    }
}


#pragma mark - SBVideoRecorderDelegate

//recorder开始录制一段视频时
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL
{
    NSLog(@"正在录制视频: %@", fileURL);
    
    [self.progressBar addProgressView];
    [_progressBar stopShining];
    
    [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
}

//recorder完成一段视频的录制时
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error)
    {
        NSLog(@"录制视频错误:%@", error);
    }
    else
    {
        NSLog(@"录制视频完成: %@", outputFileURL);
    }
    
    [_progressBar startShining];
    
    if (totalDur >= MAX_VIDEO_DUR)
    {
        [self nextStepButtonClick];
    }
}

//recorder  删除最后一段视频段视频
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error
{
    if (error)
    {
        NSLog(@"删除视频错误: %@", error);
    }
    else
    {
        NSLog(@"删除了视频: %@", fileURL);
        NSLog(@"现在视频长度: %f", totalDur);
    }
    
    //删除完成后 ，更新删除按钮界面
    if ([_videoManager getVideoCount] > 0)
    {
        [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleNormal];
    }
    else
    {
        [_partDeleteButton setButtonStyle:VideoPartDeleteButtonStyleDisable];
    }
    
    
    if (totalDur >= MIN_VIDEO_DUR && _nextStepButton.enabled == NO)
    {
        [_nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _nextStepButton.enabled = YES;
    }
    else
    {
        [_nextStepButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        _nextStepButton.enabled = NO;

    }
}

//recorder正在录制的过程中
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur
{
    [_progressBar setLastProgressToWidth:videoDuration / MAX_VIDEO_DUR * _progressBar.frame.size.width];
    
    
    if (videoDuration + totalDur >= MIN_VIDEO_DUR && _nextStepButton.enabled == NO)
    {
        [_nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        _nextStepButton.enabled = YES;
    }
    
}

//recorder完成视频的合成
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL
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
    _nextStepVideoStreamsClick(model);
    
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

@end
