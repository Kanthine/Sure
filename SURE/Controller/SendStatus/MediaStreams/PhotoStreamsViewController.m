//
//  PhotoStreamsViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "PhotoStreamsViewController.h"
#import "SurePhotoModel.h"
#import "PhotosManager.h"
#import "CamearDeviceManager.h"

@interface PhotoStreamsViewController ()

@property (nonatomic ,strong) CamearDeviceManager *deviceManager;
@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UIButton *photoButton;
@property (nonatomic ,strong) UIImageView *lastFrameImageView;



@end

@implementation PhotoStreamsViewController

- (instancetype)initWithCamearManager:(CamearDeviceManager *)camear
{
    self = [super init];
    
    if (self)
    {
        _deviceManager = camear;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lastFrameImageView];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.photoButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_deviceManager startRunning];
    [self.view addSubview:_deviceManager.streamesView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view bringSubviewToFront:_lastFrameImageView];
    [_deviceManager loadLastImageCom:^(UIImage *image)
     {
         _lastFrameImageView.image = image;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)lastFrameImageView
{
    if (_lastFrameImageView == nil)
    {
        _lastFrameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
    }
    
    return _lastFrameImageView;
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
        titleLable.text = @"拍照";
        [_navBarView addSubview:titleLable];
    }
    return _navBarView;
}

- (void)cancelButtonClick
{
    _cancelPhotoStreamsClick();
}

- (UIButton *)photoButton
{
    if (_photoButton == nil)
    {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(ScreenWidth * 1/2.0 - 30,ScreenHeight - 44 - 80, 60, 60);
        [_photoButton setImage:[UIImage imageNamed:@"camera_Photo"] forState: UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(shutterCameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photoButton;
}

#pragma mark - 照片

- (void)shutterCameraClick
{
    AVCaptureConnection * videoConnection = [_deviceManager.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection)
    {
        NSLog(@"take photo failed!");
        return;
    }
    
    [_deviceManager.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         if (imageDataSampleBuffer == NULL)
         {
             return;
         }
         
         //照相成功 展示于界面 并保存至相册
         NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         UIImage *image = [UIImage imageWithData:imageData];
         image = [image fixOrientation];//检查修改照片方向问题
         image = [image cropCameraImage];//裁剪 1：1
         
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
         
         
     }];
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error)
    {
        msg = @"保存图片失败";
    }
    else
    {
        msg = @"保存图片成功" ;
        [PhotosManager fetchLatestAssetCompletionBlock:^(PHAsset *asset)
        {
            NSLog(@"asset ===%@",asset);
            
            PHImageManager *imageManager = [PHImageManager defaultManager];
            [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
             {
                 
                 NSLog(@"info ===%@",info);
                 BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                 
                 if (downloadFinined)
                 {
                     SurePhotoModel *model = [[SurePhotoModel alloc]init];
                     model.modelType = SureModelTypePhoto;
                     model.originalImage = result;
                     [model compressOriginalImageLength];
                     _nextStepPhotoStreamsClick(model);
                 }

             }];
        }];
    }
}

@end
