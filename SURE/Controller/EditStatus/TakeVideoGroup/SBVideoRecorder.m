//
//  SBVideoRecorder.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//



#import "SBVideoRecorder.h"
#import "SBCaptureDefine.h"

#import "FilePathManager.h"

@interface SBVideoData: NSObject//视频数据 时长 地址 两个属性

@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) NSURL *fileURL;

@end

@implementation SBVideoData

@end



#define COUNT_DUR_TIMER_INTERVAL 0.05

@interface SBVideoRecorder ()

@property (strong, nonatomic) NSTimer *countDurTimer;
@property (assign, nonatomic) CGFloat currentVideoDur;
@property (assign, nonatomic) NSURL *currentFileURL;
@property (assign ,nonatomic) CGFloat totalVideoDur;

@property (strong, nonatomic) NSMutableArray *videoFileDataArray;

@property (assign, nonatomic) BOOL isFrontCameraSupported;
@property (assign, nonatomic) BOOL isCameraSupported;
@property (assign, nonatomic) BOOL isTorchSupported;
@property (assign, nonatomic) BOOL isTorchOn;
@property (assign, nonatomic) BOOL isUsingFrontCamera;

@property (strong, nonatomic) AVCaptureDeviceInput *videoDeviceInput;

@end

@implementation SBVideoRecorder

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initalize];
    }
    
    return self;
}

- (void)initalize
{
    //缺少判断
    [self getAuthorization];
    
    self.videoFileDataArray = [[NSMutableArray alloc] init];
    self.totalVideoDur = 0.0f;
}


- (void)getAuthorization
{
    /*
     AVAuthorizationStatusNotDetermined = 0,// 未进行授权选择
     
     AVAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
     
     AVAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
     
     AVAuthorizationStatusAuthorized,　　　　// 已授权，可使用
     */
    //此处获取摄像头授权
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            NSLog(@"授权摄像头使用成功");
            [self initCapture];
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {    //用户授权成功
                     [self initCapture];
                     return;
                 }
                 else
                 {        //用户拒绝授权
                     //[self pop];
                     [self showMsgWithTitle:@"出错了" andContent:@"用户拒绝授权摄像头的使用权,返回上一页.请打开\n设置-->隐私/通用等权限设置"];
                     return;
                 }
             }];
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            //[self pop];
            [self showMsgWithTitle:@"出错了" andContent:@"拒绝授权,返回上一页.请检查下\n设置-->隐私/通用等权限设置"];
            break;
        }
    }
    
}

- (void)showMsgWithTitle:(NSString *)title andContent:(NSString *)content
{
    [[[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}


#pragma mark pop


- (void)initCapture
{
    //input
    AVCaptureDevice *frontCamera = nil;
    AVCaptureDevice *backCamera = nil;
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if (camera.position == AVCaptureDevicePositionFront)
        {
            frontCamera = camera;
        }
        else
        {
            backCamera = camera;
        }
    }
    
    if (!backCamera)
    {
        self.isCameraSupported = NO;
        return;
    }
    else
    {
        self.isCameraSupported = YES;
        
        if ([backCamera hasTorch])
        {
            self.isTorchSupported = YES;
        }
        else
        {
            self.isTorchSupported = NO;
        }
    }
    
    if (!frontCamera) {
        self.isFrontCameraSupported = NO;
    } else {
        self.isFrontCameraSupported = YES;
    }
    
    [backCamera lockForConfiguration:nil];
    if ([backCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [backCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }

    [backCamera unlockForConfiguration];
    
    //session---------------------------------
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //相机 设备
    self.videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
    [_captureSession addInput:_videoDeviceInput];
    [_captureSession addInput:audioDeviceInput];
    
    //output
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [_captureSession addOutput:_movieFileOutput];
    
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc]init];
    [_captureSession addOutput:imageOutput];
    
    //preset
    _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //preview layer------------------
    self.preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
//    [_captureSession startRunning];
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
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
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

- (AVCaptureDevice *)getCameraDevice:(BOOL)isFront
{
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionBack) {
            backCamera = camera;
        } else {
            frontCamera = camera;
        }
    }
    
    if (isFront) {
        return frontCamera;
    }
    
    return backCamera;
}

//convert 转变 得到焦点
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = _preViewLayer.bounds.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.preViewLayer;//需要按照项目实际情况修改
    
    if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResize]) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        
        for(AVCaptureInputPort *port in [self.videoDeviceInput ports]) {//需要按照项目实际情况修改，必须是正在使用的videoInput
            if([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspect]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if(point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if(point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if([[videoPreviewLayer videoGravity]isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if(viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

//对焦
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
    //    NSLog(@"focus point: %f %f", point.x, point.y);
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		AVCaptureDevice *device = [_videoDeviceInput device];
		NSError *error = nil;
		if ([device lockForConfiguration:&error]) {
			if ([device isFocusPointOfInterestSupported]) {
                [device setFocusPointOfInterest:point];
            }
            
            if ([device isFocusModeSupported:focusMode]) {
				[device setFocusMode:focusMode];
			}
            
			if ([device isExposurePointOfInterestSupported]) {
                [device setExposurePointOfInterest:point];
            }
            
            if ([device isExposureModeSupported:exposureMode]) {
				[device setExposureMode:exposureMode];
			}
            
			[device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
			[device unlockForConfiguration];
		} else {
            NSLog(@"对焦错误:%@", error);
        }
	});
}


#pragma mark - Method
//对焦
- (void)focusInPoint:(CGPoint)touchPoint
{
    CGPoint devicePoint = [self convertToPointOfInterestFromViewCoordinates:touchPoint];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}



- (void)openTorch:(BOOL)open
{
    self.isTorchOn = open;
    if (!_isTorchSupported) {
        return;
    }
    
    AVCaptureTorchMode torchMode;
    if (open) {
        torchMode = AVCaptureTorchModeOn;
    } else {
        torchMode = AVCaptureTorchModeOff;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        [device setTorchMode:torchMode];
        [device unlockForConfiguration];
    });
}

- (void)switchCamera
{
    if (!_isFrontCameraSupported || !_isCameraSupported || !_videoDeviceInput)
    {
        return;
    }
    
    if (_isTorchOn)
    {
        [self openTorch:NO];
    }
    
    [_captureSession beginConfiguration];
    
    [_captureSession removeInput:_videoDeviceInput];
    
    self.isUsingFrontCamera = !_isUsingFrontCamera;
    AVCaptureDevice *device = [self getCameraDevice:_isUsingFrontCamera];
    
    [device lockForConfiguration:nil];
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    }
    [device unlockForConfiguration];
    
    self.videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [_captureSession addInput:_videoDeviceInput];
    [_captureSession commitConfiguration];
}

- (BOOL)isTorchSupported
{
    return _isTorchSupported;
}

- (BOOL)isFrontCameraSupported
{
    return _isFrontCameraSupported;
}

- (BOOL)isCameraSupported
{
    return _isFrontCameraSupported;
}

//merge 合并
- (void)mergeVideoFiles
{
    NSMutableArray *fileURLArray = [[NSMutableArray alloc] init];
    for (SBVideoData *data in _videoFileDataArray)
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
    
    [_movieFileOutput startRecordingToOutputFileURL:fileURL recordingDelegate:self];
}
//停止录制
- (void)stopCurrentVideoRecording
{
    [self stopCountDurTimer];
    [_movieFileOutput stopRecording];
}

//不调用delegate
- (void)deleteAllVideo
{
    for (SBVideoData *data in _videoFileDataArray)
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
    
    SBVideoData *data = (SBVideoData *)[_videoFileDataArray lastObject];
    
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


#pragma mark - delegate method

//开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    self.currentFileURL = fileURL;
    
    self.currentVideoDur = 0.0f;
    [self startCountDurTimer];
    
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
    
    if (!error)
    {
        SBVideoData *data = [[SBVideoData alloc] init];
        data.duration = _currentVideoDur;
        data.fileURL = outputFileURL;
        
        [_videoFileDataArray addObject:data];
    }
    
    if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishRecordingToOutPutFileAtURL:duration:totalDur:error:)])
    {
        [_delegate videoRecorder:self didFinishRecordingToOutPutFileAtURL:outputFileURL duration:_currentVideoDur totalDur:_totalVideoDur error:error];
    }
}



@end
