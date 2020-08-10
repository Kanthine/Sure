//
//  SBVideoRecorder.h
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SBVideoRecorder;
@protocol SBVideoRecorderDelegate <NSObject>

@optional
//recorder开始录制一段视频时
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didStartRecordingToOutPutFileAtURL:(NSURL *)fileURL;

//recorder完成一段视频的录制时
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration totalDur:(CGFloat)totalDur error:(NSError *)error;

//recorder正在录制的过程中
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRecordingToOutPutFileAtURL:(NSURL *)outputFileURL duration:(CGFloat)videoDuration recordedVideosTotalDur:(CGFloat)totalDur;

//recorder删除了某一段视频
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didRemoveVideoFileAtURL:(NSURL *)fileURL totalDur:(CGFloat)totalDur error:(NSError *)error;

//recorder完成视频的合成
- (void)videoRecorder:(SBVideoRecorder *)videoRecorder didFinishMergingVideosToOutPutFileAtURL:(NSURL *)outputFileURL ;

@end

@interface SBVideoRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>

@property (weak, nonatomic) id <SBVideoRecorderDelegate> delegate;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preViewLayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;



- (CGFloat)getTotalVideoDuration;
- (void)stopCurrentVideoRecording;//停止录制
- (void)startRecordingToOutputFileURL:(NSURL *)fileURL;//那倒存储地址 开始录制

- (void)deleteLastVideo;//调用delegate
- (void)deleteAllVideo;//不调用delegate

- (NSUInteger)getVideoCount;//得到视频总长度

- (void)mergeVideoFiles;//合并视频文件

- (BOOL)isCameraSupported;//
- (BOOL)isFrontCameraSupported;
- (BOOL)isTorchSupported;

- (void)switchCamera;//切换摄像头
- (void)openTorch:(BOOL)open;//闪光灯

- (void)focusInPoint:(CGPoint)touchPoint;//聚焦

@end

//大致思路 ： 点击开始录制 松开录制结束保存本地 多段视频最后合并为一个视频

//http://www.jianshu.com/p/4701d006b514/comments/2862389  详细讲解
//http://blog.sina.com.cn/s/blog_d0c0c80c0102xbo0.html
//http://www.360doc.com/content/15/0723/10/20918780_486825036.shtml
