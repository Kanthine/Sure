//
//  FilerCamearManager.m
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "FilerCamearManager.h"



@interface FilerCamearManager ()

<CAAnimationDelegate>

{
    CGRect _frame;
    CALayer *_focusLayer;
}

@property (nonatomic , strong) NSArray *filtersArray;

/*
 将GPUImageStillCamera对象捕获的图像打印在GPUImageView的层。
 */
@property (nonatomic , strong) GPUImageView *cameraScreen;


@property (nonatomic , strong) GPUImageFilterGroup *currentGroup; //当前滤镜

@end



@implementation FilerCamearManager

- (id)initWithFrame:(CGRect)frame superview:(UIView *)superview
{
    self = [super init];
    if (self)
    {
        _frame = frame;
        [self setFlashMode:FilerCamearManagerFlashModeOff];
        [superview addSubview:self.cameraScreen];
        
    }
    return self;
}



#pragma mark - 摄像头
- (GPUImageStillCamera *)camera
{
    if (!_camera)
    {
        GPUImageStillCamera *camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720
                                                                          cameraPosition:AVCaptureDevicePositionBack];
        camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        camera.horizontallyMirrorFrontFacingCamera = YES;
        _camera = camera;
    }
    return _camera;
}


#pragma mark - 输出视图 预览图层

- (GPUImageView *)cameraScreen
{
    if (!_cameraScreen)
    {
        GPUImageView *cameraScreen = [[GPUImageView alloc] initWithFrame:_frame];
        cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        _cameraScreen = cameraScreen;
        
    }
    return _cameraScreen;
}

#pragma mark 设置对焦图片

- (void)setfocusImage:(UIImage *)focusImage
{
    if (!focusImage) return;
    
    if (!_focusLayer)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focus:)];
        [self.cameraScreen addGestureRecognizer:tap];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [self.cameraScreen.layer addSublayer:layer];
    _focusLayer = layer;
    
}

#pragma mark 摄像头位置

- (void)setCameraPosition:(FilerCamearManagerDevicePosition)cameraPosition
{
    _cameraPosition = cameraPosition;
    
    switch (cameraPosition)
    {
        case FilerCamearManagerDevicePositionBack:
        {
            if (self.camera.cameraPosition != AVCaptureDevicePositionBack)
            {
                [self.camera pauseCameraCapture];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [self.camera rotateCamera];
                    [self.camera resumeCameraCapture];
                    
                });
                [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
            }
            
        }
            
            break;
        case FilerCamearManagerDevicePositionFront:
        {
            if (self.camera.cameraPosition != AVCaptureDevicePositionFront)
            {
                [self.camera pauseCameraCapture];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [self.camera rotateCamera];
                    [self.camera resumeCameraCapture];
                    
                });
                [self performSelector:@selector(animationCamera) withObject:self afterDelay:0.2f];
            }
        }
            
            break;
        default:
            break;
    }

    
}


- (void) animationCamera
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.cameraScreen.layer addAnimation:animation forKey:nil];
    
}


#pragma mark 闪光灯


- (void)setFlashMode:(FilerCamearManagerFlashMode)flashMode
{
    _flashMode = flashMode;
    
    switch (flashMode)
    {
        case FilerCamearManagerFlashModeAuto:
        {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeAuto];
            [self.camera.inputCamera unlockForConfiguration];
        }
            break;
        case FilerCamearManagerFlashModeOff:
        {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.camera.inputCamera unlockForConfiguration];
        }
            
            break;
        case FilerCamearManagerFlashModeOn:
        {
            [self.camera.inputCamera lockForConfiguration:nil];
            [self.camera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.camera.inputCamera unlockForConfiguration];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 对焦

- (void)focus:(UITapGestureRecognizer *)tap
{
    self.cameraScreen.userInteractionEnabled = NO;
    CGPoint touchPoint = [tap locationInView:tap.view];
    [self layerAnimationWithPoint:touchPoint];
    touchPoint = CGPointMake(touchPoint.x / tap.view.bounds.size.width, touchPoint.y / tap.view.bounds.size.height);
    
    if ([self.camera.inputCamera isFocusPointOfInterestSupported] && [self.camera.inputCamera isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([self.camera.inputCamera lockForConfiguration:&error]) {
            [self.camera.inputCamera setFocusPointOfInterest:touchPoint];
            
            [self.camera.inputCamera setFocusMode:AVCaptureFocusModeAutoFocus];
            
            if([self.camera.inputCamera isExposurePointOfInterestSupported] && [self.camera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.camera.inputCamera setExposurePointOfInterest:touchPoint];
                [self.camera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [self.camera.inputCamera unlockForConfiguration];
            
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}

#pragma mark 对焦动画
- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer)
    {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
    }
}

#pragma mark 拍照

- (void)snapshotSuccess:(void(^)(UIImage *image))success
        snapshotFailure:(void (^)(void))failure {
    
    [self.camera capturePhotoAsImageProcessedUpToFilter:self.currentGroup withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        if (!processedImage){
            failure();
        }else {
            success(processedImage);
        }
        
    }];
    
}

#pragma mark 添加滤镜组

- (void)addFilters:(NSArray *)filtersArray
{
    __weak FilerCamearManager *weakSelf = self;
    [filtersArray enumerateObjectsUsingBlock:^(GPUImageFilterGroup * _Nonnull filter, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [weakSelf.camera addTarget:filter];
    }];
    self.filtersArray = filtersArray;
    [self setFilterAtIndex:0];
}

#pragma mark 设置滤镜 (将滤镜添加至预览图层)

- (void)setFilterAtIndex:(NSInteger)index
{
    [self.currentGroup removeTarget:self.cameraScreen];
    GPUImageFilterGroup *filter = self.filtersArray[index];
    [filter addTarget:self.cameraScreen];
    self.currentGroup = filter;
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //1秒钟延时
    [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:1.0f];
}

#pragma mark focusLayer回到初始化状态
- (void)focusLayerNormal
{
    self.cameraScreen.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

@end

