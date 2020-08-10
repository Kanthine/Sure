//
//  EditImageView.h
//  SURE
//
//  Created by 王玉龙 on 16/11/1.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define FilerCount 21


#import "EditImageModel.h"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditImageViewState)
{
    EditImageViewStateNormal = 0,
    EditImageViewStateCropImage,
    EditImageViewStateFilerImage,
};


@protocol EditImageViewDelegate <NSObject>

@required

- (void)reloadScrollViewWithIndex:(NSInteger)index;

@end

// 自定义 一个 ImageView 滤镜功能 裁图功能  标签功能
@interface EditImageView : UIView

@property (nonatomic ,weak) id <EditImageViewDelegate> delegate;
@property (nonatomic,assign) EditImageViewState state;

@property (nonatomic ,strong) EditImageModel *imageModel;
@property (nonatomic ,assign) NSInteger currentIndexImage;

@property (nonatomic ,assign) CGRect allowAddRect;

@property (nonatomic ,assign) BOOL isCropSucceed;

@end



//- (void)filerView
//{
//    /* 下面尝试使用GPUImage来给视频加上滤镜。
//     */
//    GPUImageContrastFilter *secondFilter = [[GPUImageContrastFilter alloc] init];
//    
//    [secondFilter setContrast:1.80];
//    
//    GPUImageBrightnessFilter *firstFilter = [[GPUImageBrightnessFilter alloc] init];
//    
//    [firstFilter setBrightness:0.1];
//    
//    //GPUImageColorBurnBlendFilter
//    GPUImageRGBFilter *filter = [[GPUImageRGBFilter alloc] init];
//    filter.red = 0.8;
//    filter.green = 1;
//    filter.blue = 1.2;
//    
//    NSURL *vedioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"s2" ofType:@"mp4"]];
//    
//    GPUImageMovie *movie = [[GPUImageMovie alloc] initWithURL:vedioURL];
//    
//    
//    
//    /**
//     *  This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
//     *
//     *  这使当前视频处于基准测试的模式，记录并输出瞬时和平均帧时间到控制台
//     *
//     *  每隔一段时间打印： Current frame time : 51.256001 ms，直到播放或加滤镜等操作完毕
//     */
//    movie.runBenchmark = YES;
//    
//    //[movie addTarget:filter];
//    [movie addTarget:secondFilter];
//    
//    
//    
//    
//    
//    GPUImageMovieWriter *vedioWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:@"/Users/huazai/Desktop/t/t16.mov"] size:CGSizeMake(1280, 800)];
//    
//    movie.audioEncodingTarget = nil;
//    
//    vedioWriter.shouldPassthroughAudio = YES;
//    
//    /**
//     *  控制GPUImageView预览视频时的速度是否要保持真实的速度。
//     *  如果设为NO，则会将视频的所有帧无间隔渲染，导致速度非常快。
//     *  设为YES，则会根据视频本身时长计算出每帧的时间间隔，然后每渲染一帧，就sleep一个时间间隔，从而达到正常的播放速度。
//     */
//    movie.playAtActualSpeed = NO;
//    
//    [movie startProcessing];
//    
//    [filter addTarget:vedioWriter];
//    //[secondFilter addTarget:vedioWriter];
//    
//    [vedioWriter startRecording];
//    
//    [vedioWriter setCompletionBlock:^{
//        NSLog(@"已完成！！！");
//    }];
//}
//
//
