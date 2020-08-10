//
//  CamearDeviceManager.h
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//


//#define <#macro#>



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/*
 * 闪光灯模式
 */
typedef NS_ENUM(NSInteger, CamearDeviceManagerFlashMode)
{
    
    CamearDeviceManagerFlashModeAuto, //自动
    
    CamearDeviceManagerFlashModeOff, //关闭
    
    CamearDeviceManagerFlashModeOn //打开
};

/*
 * 摄像头模式
 */
typedef NS_ENUM(NSInteger, CamearDeviceManagerDevicePosition)
{
    
    CamearDeviceManagerDevicePositionBack, //后摄像头
    
    CamearDeviceManagerDevicePositionFront //前摄像头
};

/*
 * 摄像模式
 */
typedef NS_ENUM(NSInteger, CamearDeviceManagerMediaStreamesTpye)
{
    
    CamearDeviceManagerMediaStreamesTpyePhoto, //拍照
    CamearDeviceManagerMediaStreamesTpyeVideo //摄像
};


@class CamearDeviceManager;
@protocol CamearDeviceManagerDelegate <NSObject>

@optional
//recorder开始录制一段视频时
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL;

//recorder完成一段视频的录制时
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error;

//recorder正在录制的过程中
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur;

//recorder删除了某一段视频
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error;

//recorder完成视频的合成
- (void)videoRecorder:(CamearDeviceManager *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL ;

@end





@interface CamearDeviceManager : NSObject


@property (nonatomic ,assign) id <CamearDeviceManagerDelegate> delegate;

/* 摄像模式 */
@property (nonatomic ,assign) CamearDeviceManagerMediaStreamesTpye mediaStreamesTpye;
/* 预览媒体流视图 */
@property (nonatomic ,strong) UIView *streamesView;
/* 图片输出 */
@property (nonatomic ,strong) AVCaptureStillImageOutput *ImageOutPut;
/* 视频输出 */
@property (nonatomic ,strong) AVCaptureMovieFileOutput *moiveOutPut;

- (UIImage*)captureTheLastFrame;
- (void)loadLastImageCom:(void(^)(UIImage *image))block;



/* 注：严重堵塞主线程 */
- (void)startRunning;
- (void)stopRunning;



/**
 判断是否授权，yes授权成功，no没有授权
 */
+ (BOOL)authorizationStateAuthorized;



#pragma mark - 拍照

// 拍照
//- (void)snapshotSuccess:(void(^)(UIImage *image))success snapshotFailure:(void (^)(void))failure;

#pragma mark - 分段录制视频

- (CGFloat)getTotalVideoDuration;
- (void)stopCurrentVideoRecording;//停止录制
- (void)startRecordingToOutputFileURL:(NSURL *)fileURL;//那倒存储地址 开始录制

- (void)deleteLastVideo;//调用delegate
- (void)deleteAllVideo;//不调用delegate

- (NSUInteger)getVideoCount;//得到视频总长度

- (void)mergeVideoFiles;//合并视频文件


@end



/*
 
 AVCaptureSession阻塞主线程问题

 - (void)startRunning
 - (void)stopRunning
 函数在 session 完全停止下来之前会始终阻塞线程
 
 因此这里必须放在后台线程中处理，否则，就会导致界面不响应，iOS8之后应该在这里做了优化，即使放在主线程做也没有很卡顿的现象，但 iOS7中，尤其是测试设备为4s，界面卡死问题很严重。

 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 DDLogDebug(@"Function: %s,line : %d 开启相机",__FUNCTION__,__LINE__);
 [[self.avCameraManager session] startRunning];
 });
 
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
 DDLogDebug(@"Function: %s,line : %d 关闭相机",__FUNCTION__,__LINE__);
 if ([[self.avCameraManager session] isRunning]) {
 [[self.avCameraManager session] stopRunning];
 }
 });
 
 这里除了使用系统提供的队列以外还可以自己创建 FIFO 类型后台线程进行管理，包括切换前后摄像头、改变闪光灯模式、切换拍照和录像等，都可以放入子线程操作。
 
 */
