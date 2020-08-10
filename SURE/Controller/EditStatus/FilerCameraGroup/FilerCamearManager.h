//
//  FilerCamearManager.h
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GPUImageFilterGroup;
/**
 *  闪光灯模式
 */
typedef NS_ENUM(NSInteger, FilerCamearManagerFlashMode)
{
    
    FilerCamearManagerFlashModeAuto, //自动
    
    FilerCamearManagerFlashModeOff, //关闭
    
    FilerCamearManagerFlashModeOn //打开
};

/**
 *  摄像头模式
 */
typedef NS_ENUM(NSInteger, FilerCamearManagerDevicePosition)
{
    
    FilerCamearManagerDevicePositionBack, //后摄像头
    
    FilerCamearManagerDevicePositionFront //前摄像头
};

@interface FilerCamearManager : NSObject

//    摄像头位置
@property (nonatomic , assign) FilerCamearManagerDevicePosition cameraPosition;
//    闪光灯模式
@property (nonatomic , assign) FilerCamearManagerFlashMode flashMode;

@property (nonatomic , strong) GPUImageStillCamera *camera;//GPU 相机


- (id)initWithFrame:(CGRect)frame superview:(UIView *)superview;
//    设置对焦的图片
- (void)setfocusImage:(UIImage *)focusImage;

//    拍照
- (void)snapshotSuccess:(void(^)(UIImage *image))success
        snapshotFailure:(void (^)(void))failure;


//    添加滤镜组
- (void)addFilters:(NSArray *)filtersArray;
//    设置滤镜
- (void)setFilterAtIndex:(NSInteger)filerIndex;


@end

