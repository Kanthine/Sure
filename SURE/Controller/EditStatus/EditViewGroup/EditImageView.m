//
//  EditImageView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/1.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define MaxSCale 6.0  //最大缩放比例
#define MinScale 1.0  //最小缩放比例

#import "EditImageView.h"

#import "FWApplyFilter.h"
#import "CustomTagView.h"
#import "TimeStamp.h"
#import "FilePathManager.h"

//裁图 裁图时回复到原图状态，裁图结束后再附上滤镜
@interface CropImageView : UIView

{
    CGFloat _currentScale;
}

@property (nonatomic ,strong) UIImageView *cropImageView;

@end

@implementation CropImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.clipsToBounds = YES;
        
        self.cropImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _cropImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_cropImageView layoutIfNeeded];
        _cropImageView.backgroundColor = [UIColor blackColor];
        _cropImageView.clipsToBounds = YES;
        [self addSubview:_cropImageView];
        self.cropImageView.userInteractionEnabled = YES;
        self.cropImageView.multipleTouchEnabled = YES;
        
        _currentScale = 1;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageVie:)];
        [_cropImageView addGestureRecognizer:pinchRecognizer];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_cropImageView addGestureRecognizer:pan];
    }
    
    
    return self;
}

// 缩放
-(void)scaleImageVie:(UIPinchGestureRecognizer *)pinchGesture
{
    CGFloat scale = pinchGesture.scale;
    
    
    //放大情况
    if(scale > 1.0)
    {
        if(_currentScale > MaxSCale) return;
    }
    
    //缩小情况
    if (scale < 1.0)
    {
        if (_currentScale < MinScale) return;
    }
    
    self.cropImageView.transform = CGAffineTransformScale(self.cropImageView.transform, scale, scale);
    _currentScale *= scale;
    pinchGesture.scale = 1.0;
    
}


//拖动手势处理方法
- (void)panGestureAction:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        //移动的偏移向量
        CGPoint offset = [pan translationInView:pan.view.superview];
        
        if(  (offset.x < 0 && (CGRectGetWidth(_cropImageView.frame) + _cropImageView.frame.origin.x) < ScreenWidth + 5 )
           || (offset.x > 0 && _cropImageView.frame.origin.x > -5)
           || (offset.y < 0 && (CGRectGetHeight(_cropImageView.frame) + _cropImageView.frame.origin.y) < ScreenWidth + 5 )
           || (offset.y > 0 && _cropImageView.frame.origin.y > -5)  )//向左移动
        {
            return;
        }
        
        //做位移变换
        pan.view.transform = CGAffineTransformTranslate(pan.view.transform, offset.x, offset.y);
        //需要重置向量属性，为下一次调用进行初始化，恢复原来的值，
        //注意：如果不重置，偏移量值将会叠加
        [pan setTranslation:CGPointZero inView:pan.view.superview];
    }
    
    
    NSLog(@"_cropImageView == %@",[NSValue valueWithCGRect:_cropImageView.frame]);
    
}

//获取裁剪后的图片
- (UIImage *)currentCroppedImage
{
    
    CGRect rect = CGRectMake( - _cropImageView.frame.origin.x,- _cropImageView.frame.origin.x, ScreenWidth, ScreenWidth);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([_cropImageView.image CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage*)captureScreen
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth, ScreenWidth), NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end









@interface ShowVideoView : UIView

<UIAlertViewDelegate>

{
    NSString * _pathToMovie;
    GPUImageMovie * movieFile;
    GPUImageOutput<GPUImageInput> * pixellateFilter;
    GPUImageMovieWriter * movieWriter;
    NSURL * _videoUrl;
    
    
    
    GPUImageView *filterView;
    
    
    
    
    NSURL *_videoURL;
    
    UIButton *_playButton;
    AVPlayerItem *_playerItem;
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;

}

- (void)setPlayViewWithVideoPath:(NSString *)videoPathString;

@end

@implementation ShowVideoView


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    return self;
}

- (void)setPlayViewWithVideoURL:(NSURL *)videoURL
{
    [_playButton removeFromSuperview];
    _playButton = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    _playerItem = nil;
    
    
    _videoURL = videoURL;
    
        
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    
    
    _playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [_playButton setImage:[UIImage imageNamed:@"playVideo"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    
}

- (void)playVideoButtonClick:(UIButton *)button
{
    
    NSLog(@"length ======= %lu",[NSData dataWithContentsOfURL:_videoURL].length);
    
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem)
    {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^
    {
        _playButton.alpha = 1.0f;
    }];
}
@end











@interface EditImageView ()
<CustomTagViewDelegate>

@property (nonatomic ,strong) UILabel *filerNameLable;
@property (nonatomic ,strong) UIImageView *showImageView;

@property (nonatomic ,strong) ShowVideoView *showVideoView;

//给视频添加滤镜
@property (nonatomic ,strong) GPUImageMovie *movieFile;
//@property (nonatomic ,strong) GPUImageMovieWriter *movieWriter;

@end

@implementation EditImageView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder: aDecoder];
    if(self)
    {
        [self setSubViews];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    if (self)
    {
        [self setSubViews];
    }
    
    
    return self;
}

- (void)setSubViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector        (notificationCenterUpdateUI) name:@"FilerViewDidSelectedFiler" object:nil];

    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.showImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    _showImageView.backgroundColor = [UIColor blackColor];
    _showImageView.clipsToBounds = YES;
    [self addSubview:_showImageView];

    
    self.showVideoView = [[ShowVideoView alloc]initWithFrame:self.bounds];
    _showVideoView.hidden = YES;
    _showVideoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_showVideoView];
    
    
    self.filerNameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 20)];
    _filerNameLable.textColor = [UIColor lightGrayColor];
    _filerNameLable.textAlignment = NSTextAlignmentCenter;
    _filerNameLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:_filerNameLable];
    
    
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeGestureClick)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_showImageView addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeGestureClick)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [_showImageView addGestureRecognizer:rightSwipeGesture];
    _showImageView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
}

#pragma mark - 重写 Set  Get

- (void)setIsCropSucceed:(BOOL)isCropSucceed
{
    _isCropSucceed = isCropSucceed;
    
    if (isCropSucceed)
    {
        CropImageView *cropView = [self viewWithTag:98];
        _imageModel.originalImage = [cropView captureScreen];
        
        
        if (_imageModel.isFiler)
        {
            [self switchFilerWithFilerIndex:_imageModel.filerIndex CompletionBlock:^(NSString *string, UIImage *newImage)
            {
                _imageModel.filerImage = newImage;
                [self setImageModel:_imageModel];
            }];
        }
        else
        {
            [self setImageModel:_imageModel];
        }
    }
}

- (void)setState:(EditImageViewState)state
{
    _state = state;
    _showImageView.hidden = NO;
    _filerNameLable.hidden = NO;
    
    
    CropImageView *cropView = [self viewWithTag:98];
    if (cropView)
    {
        [cropView removeFromSuperview];
        cropView = nil;
    }
    
    switch (state)
    {
        case EditImageViewStateNormal:
            break;
        case EditImageViewStateCropImage:
        {
            _showImageView.hidden = YES;
            _filerNameLable.hidden = YES;
            
            
            CropImageView *cropView = [[CropImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - ScreenWidth ) / 2.0, ScreenWidth, ScreenWidth)];
            cropView.tag = 98;
            cropView.cropImageView.image = _imageModel.originalImage;
            [self addSubview:cropView];
        }
            break;
        case EditImageViewStateFilerImage:
            break;
        default:
            break;
    }
}

- (void)setImageModel:(EditImageModel *)imageModel
{
    _imageModel = imageModel;
    
    
    
    if (_imageModel.modelType == EditImageModelTypePhoto)
    {
        _showImageView.hidden = NO;
        _showVideoView.hidden = YES;
        [self updateImageModel];
    }
    else
    {
        _showImageView.hidden = YES;
        _showVideoView.hidden = NO;
        [self updateVideoModel];
    }
}


- (void)updateVideoModel
{
    
    if (_imageModel.isFiler && _imageModel.filerVideoURL)
    {
        [_showVideoView setPlayViewWithVideoURL:_imageModel.filerVideoURL];
    }
    else
    {
        [_showVideoView setPlayViewWithVideoURL:_imageModel.resourceURL];
    }
}


- (void)updateImageModel
{
    if (_showImageView.image != nil)
    {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.7;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromRight;
        [_showImageView.layer addAnimation:animation forKey:@"animation"];
    }
    
    
    if (_imageModel.isFiler)
    {
        _filerNameLable.hidden = NO;
        _filerNameLable.text = _imageModel.filerName;
        _showImageView.image = _imageModel.filerImage;
        
    }
    else
    {
        _filerNameLable.hidden = YES;
        _showImageView.image = _imageModel.originalImage;
    }
    
    if (_imageModel.isAddTag)
    {
        [self adddTagView];
    }
    else
    {
        [self removeTagView];
    }

}

- (CGRect)allowAddRect
{
    CGRect allowRect = [self getFrameSizeForImage:_showImageView.image inImageView:_showImageView];
    
    return  allowRect;
}

- (void)adddTagView
{
    for (NSMutableDictionary *dict in _imageModel.tagArray)
    {
        CGFloat widthRate = [[dict objectForKey:WidthRateKey] floatValue];
        CGFloat heightRate = [[dict objectForKey:HeightRateKey] floatValue];
        NSString *titleString = [dict objectForKey:TagTitle];
        
        CGSize imageSize = _imageModel.originalImage.size;
        
        NSLog(@"allowAddRect%@",[NSValue valueWithCGRect: self.allowAddRect]);

        
        CustomTagView * tagView = [[CustomTagView alloc]initWithFrame:CGRectMake(self.allowAddRect.origin.x + self.allowAddRect.size.width * widthRate, self.allowAddRect.origin.y + self.allowAddRect.size.height * heightRate, 80, HEIGHT) Title:titleString];
        
        tagView.allowPanRect = self.allowAddRect;
        tagView.isEdit = NO;
        tagView.delegate = self;
        tagView.backgroundColor = [UIColor clearColor];
        [self addSubview:tagView];
        
    }
}

- (void)updateTagViewFrame:(CGRect)frame Title:(NSString *)titleString
{    
    CGFloat widthRate = (frame.origin.x - self.allowAddRect.origin.x )/ self.allowAddRect.size.width;
    CGFloat heightRate =(frame.origin.y - self.allowAddRect.origin.y )/ self.allowAddRect.size.height;

    
    for (int i = 0;  i < _imageModel.tagArray.count; i ++)
    {
        NSMutableDictionary *dict = _imageModel.tagArray[i];
        NSString *title = [dict objectForKey:TagTitle];
        if ([titleString isEqualToString:title])
        {
            [dict setObject:@(widthRate) forKey:WidthRateKey];
            [dict setObject:@(heightRate) forKey:HeightRateKey];
            [_imageModel.tagArray replaceObjectAtIndex:i withObject:dict];
            break;
        }
    }
}

- (void)deleteTagClick:(CustomTagView *)tagView
{
    [tagView removeFromSuperview];
    tagView = nil;
}


- (void)removeTagView
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[CustomTagView class]])
        {
            [subView removeFromSuperview];
        }
    }
}

//获取当前Image在ImageView的坐标，限制标签的移动范围
- (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView
{
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}


#pragma  mark - Gesture Click

- (void)leftSwipeGestureClick
{
    [self switchFilterWithLeft:YES];
}

- (void)rightSwipeGestureClick
{
    [self switchFilterWithLeft:NO];
}

- (void)switchFilterWithLeft:(BOOL)isLeft
{
    
    if (_state != EditImageViewStateNormal || _imageModel.modelType == EditImageModelTypeVideo)
    {
        return;
    }
    
    static NSInteger nowFilerIndex = FilerCount * 100 + 1;
    _filerNameLable.hidden = NO;
    
    UIImage *image = _imageModel.originalImage;
    
    if (_imageModel.isFiler)
    {
        nowFilerIndex = _imageModel.filerIndex + FilerCount * 100 + 1;
    }
    else
    {
        nowFilerIndex = FilerCount * 100 + 1;
    }
    
    NSLog(@"image == %@",image);
    NSLog(@"filerIndex == %ld",nowFilerIndex % FilerCount);
    
    
    [self switchFilerWithFilerIndex:nowFilerIndex % FilerCount CompletionBlock:^(NSString *string, UIImage *newImage)
    {
        _imageModel.filerName  = string;
        _imageModel.filerIndex = nowFilerIndex % FilerCount;
        _imageModel.isFiler = YES;
        _imageModel.filerImage = newImage;
        
        _filerNameLable.text = string;
        _showImageView.image = newImage;
        
        
        
        if (isLeft)
        {
            nowFilerIndex -- ;
        }
        else
        {
            nowFilerIndex ++ ;
        }
        
        
        //  添加滤镜之后，更新按钮
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadScrollViewWithIndex:)])
        {
            [self.delegate reloadScrollViewWithIndex:_currentIndexImage];
        }
        
        
    }];
}


#pragma mark - 开始 合成 视频

//注意 1：视频处理后输出到 GPUImageView 预览时不支持播放声音，需要自行添加声音播放功能。
//注意 2：关注CPU和内存占用问题

- (void)notificationCenterUpdateUI
{
    //滤镜 列表选择后 更新 主图 和上面 图片
    [self switchFilerWithFilerIndex:_imageModel.filerIndex CompletionBlock:^(NSString *string, UIImage *newImage)
     {
         _filerNameLable.text = string;
         _showImageView.image = newImage;
         
         
         _imageModel.filerName  = string;
         _imageModel.isFiler = YES;
         _imageModel.filerImage = newImage;
         
         
         //  添加滤镜之后，更新按钮
         if (self.delegate && [self.delegate respondsToSelector:@selector(reloadScrollViewWithIndex:)])
         {
             [self.delegate reloadScrollViewWithIndex:_currentIndexImage];
         }
     }];
    
    
    if (_imageModel.modelType == EditImageModelTypeVideo)
    {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"开始合成视频...";
        
        
        NSLog(@"_imageModel.resourceURL=========== %@",_imageModel.resourceURL);

        [self filterVideoCompletionBlock:^(NSURL *pathURL)
         {
             _imageModel.filerVideoURL = pathURL;
             NSLog(@"视频编辑完成啦 : %@",_movieFile);
             
             
             NSData *data = [NSData dataWithContentsOfURL:pathURL];
             
             NSLog(@"filerMovieURL ====== %@",pathURL);
             
             NSLog(@"length ====== %lu",data.length);
             
             
             [hud hide:YES];
             
             NSLog(@"updateVideoModel ======= %@",[NSThread currentThread]);

             
             [self updateVideoModel];
        }];
        
    }
}


- (void)switchFilerWithFilerIndex:(NSInteger)index CompletionBlock:(void (^) ( NSString*string  ,UIImage *newImage))block
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
   {
    UIImage *image = _imageModel.originalImage;
    
       if (image == nil)
       {
           image = _imageModel.thumbnailImage;
       }
    
    NSString *filerNameString = nil;
    
    
    switch (index)
    {
        case 0:
            filerNameString = @"原始图片";
            break;
        case 1:
            filerNameString = @"MissetikateFilter";
            image = [FWApplyFilter applyMissetikateFilter:image];
            break;
        case 2:
            filerNameString = @"SoftEleganceFilter";
            image = [FWApplyFilter applySoftEleganceFilter:image];
            break;
        case 3:
            filerNameString = @"NashvilleFilter";
            image = [FWApplyFilter applyNashvilleFilter:image];
            break;
        case 4:
            filerNameString = @"LordKelvinFilter";
            image = [FWApplyFilter applyLordKelvinFilter:image];
            break;
        case 5:
            filerNameString = @"AmaroFilter";
            image = [FWApplyFilter applyAmaroFilter:image];
            break;
        case 6:
            filerNameString = @"RiseFilter";
            image = [FWApplyFilter applyRiseFilter:image];
            break;
        case 7:
            filerNameString = @"HudsonFilter";
            image = [FWApplyFilter applyHudsonFilter:image];
            break;
        case 8:
            filerNameString = @"XproIIFilter";
            image = [FWApplyFilter applyXproIIFilter:image];
            break;
        case 9:
            filerNameString = @"1977Filter";
            image = [FWApplyFilter apply1977Filter:image];
            break;
        case 10:
            filerNameString = @"ValenciaFilter";
            image = [FWApplyFilter applyValenciaFilter:image];
            break;
        case 11:
            filerNameString = @"WaldenFilter";
            image = [FWApplyFilter applyWaldenFilter:image];
            break;
        case 12:
            filerNameString = @"LomofiFilter";
            image = [FWApplyFilter applyLomofiFilter:image];
            break;
        case 13:
            filerNameString = @"InkwellFilter";
            image = [FWApplyFilter applyInkwellFilter:image];
            break;
        case 14:
            filerNameString = @"SierraFilter";
            image = [FWApplyFilter applySierraFilter:image];
            break;
        case 15:
            filerNameString = @"EarlybirdFilter";
            image = [FWApplyFilter applyEarlybirdFilter:image];
            break;
        case 16:
            filerNameString = @"SutroFilter";
            image = [FWApplyFilter applySutroFilter:image];
            break;
        case 17:
            filerNameString = @"ToasterFilter";
            image = [FWApplyFilter applyToasterFilter:image];
            break;
        case 18:
            filerNameString = @"BrannanFilter";
            image = [FWApplyFilter applyBrannanFilter:image];
            break;
        case 19:
            filerNameString = @"SketchFilter";
            image = [FWApplyFilter applySketchFilter:image];
            break;
        case 20:
            filerNameString = @"HefeFilter";
            image = [FWApplyFilter applyHefeFilter:image];
            break;
        case 21:
            filerNameString = @"AmatorkaFilter";
            image = [FWApplyFilter applyAmatorkaFilter:image];
            break;
        default:
            break;
    }
       
//       NSDictionary *dict=@{@"filerName":filerNameString,@"image":image};
    
       
       
       
       dispatch_async(dispatch_get_main_queue(),^{
          
           block(filerNameString ,image);
         
          
       });
  });

}

-(void)filterVideoCompletionBlock:(void (^) (NSURL *pathURL))block
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//   {
       //设置 滤镜
       NSString *filerNameString = nil;
       GPUImageOutput<GPUImageInput> * pixellateFilter;
       
       
       switch (_imageModel.filerIndex)
       {
           case 0:
               filerNameString = @"原始视频";
               pixellateFilter = [[GPUImageFilter alloc] init]; //默认
               break;
           case 1:
               filerNameString = @"MissetikateFilter";
               pixellateFilter = [[GPUImageMissEtikateFilter alloc] init];
               break;
           case 2:
               filerNameString = @"SoftEleganceFilter";
               pixellateFilter = [[GPUImageSoftEleganceFilter alloc] init];
               break;
           case 3:
               filerNameString = @"NashvilleFilter";
               pixellateFilter =  [[FWNashvilleFilter alloc] init];
               break;
           case 4:
               filerNameString = @"LordKelvinFilter";
               pixellateFilter = [[FWLordKelvinFilter alloc] init];
               break;
           case 5:
               filerNameString = @"AmaroFilter";
               pixellateFilter = [[FWAmaroFilter alloc] init];
               break;
           case 6:
               filerNameString = @"RiseFilter";
               pixellateFilter = [[FWRiseFilter alloc] init];
               break;
           case 7:
               filerNameString = @"HudsonFilter";
               pixellateFilter = [[FWHudsonFilter alloc] init];
               break;
           case 8:
               filerNameString = @"XproIIFilter";
               pixellateFilter = [[FWXproIIFilter alloc] init];
               break;
           case 9:
               filerNameString = @"1977Filter";
               pixellateFilter = [[FW1977Filter alloc] init];
               break;
           case 10:
               filerNameString = @"ValenciaFilter";
               pixellateFilter = [[FWValenciaFilter alloc] init];
               break;
           case 11:
               filerNameString = @"WaldenFilter";
               pixellateFilter =[[FWWaldenFilter alloc] init];
               break;
           case 12:
               filerNameString = @"LomofiFilter";
               pixellateFilter = [[FWLomofiFilter alloc] init];
               break;
           case 13:
               filerNameString = @"InkwellFilter";
               pixellateFilter = [[FWInkwellFilter alloc] init];
               break;
           case 14:
               filerNameString = @"SierraFilter";
               pixellateFilter = [[FWSierraFilter alloc] init];
               break;
           case 15:
               filerNameString = @"EarlybirdFilter";
               pixellateFilter =[[FWEarlybirdFilter alloc] init];
               break;
           case 16:
               filerNameString = @"SutroFilter";
               pixellateFilter = [[FWSutroFilter alloc] init];
               break;
           case 17:
               filerNameString = @"ToasterFilter";
               pixellateFilter = [[FWToasterFilter alloc] init];
               break;
           case 18:
               filerNameString = @"BrannanFilter";
               pixellateFilter = [[FWBrannanFilter alloc] init];
               break;
           case 19:
               filerNameString = @"SketchFilter";
               pixellateFilter =  [[GPUImageSketchFilter alloc] init];
               break;
           case 20:
               filerNameString = @"HefeFilter";
               pixellateFilter = [[FWHefeFilter alloc] init];
               break;
           case 21:
               filerNameString = @"AmatorkaFilter";
               pixellateFilter = [[GPUImageAmatorkaFilter alloc] init];
               break;
           default:
               break;
       }
    
    if (_movieFile)
    {
        _movieFile = nil;
    }

       _movieFile = [[GPUImageMovie alloc] initWithURL:_imageModel.resourceURL];
//       _movieFile.runBenchmark = YES;
       [_movieFile addTarget:pixellateFilter];
       _movieFile.playAtActualSpeed = YES;
       [_movieFile startProcessing];

       
       NSString *filerPath = [FilePathManager getFilerVideoFilePathString];
       NSURL *filerMovieURL = [NSURL fileURLWithPath:filerPath];
       if ([[NSFileManager defaultManager] fileExistsAtPath:filerPath])
       {
           NSError *error;
           [[NSFileManager defaultManager] removeItemAtPath:filerPath error:&error];
           
           NSLog(@"error: %@",error);
       }
       

    
    AVAsset *asset = [AVAsset assetWithURL:_imageModel.resourceURL];
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:filerMovieURL size:assetTrack.naturalSize];
       [pixellateFilter addTarget:movieWriter];
    
    
    NSLog(@"currentThread ======= %@",[NSThread currentThread]);
    
       movieWriter.shouldPassthroughAudio = YES;
       //    movieFile.audioEncodingTarget = movieWriter;
       

       
       [_movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
       [movieWriter startRecording];
       
       __weak GPUImageOutput<GPUImageInput> * weakpixellateFilter = pixellateFilter;
       __weak GPUImageMovieWriter * weakmovieWriter = movieWriter;
       [movieWriter setCompletionBlock:^
        {
            [weakpixellateFilter removeTarget:weakmovieWriter];
            [weakmovieWriter finishRecording];
//            _movieFile = nil;

            [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

            
            NSLog(@"视频合成结束");
            dispatch_async(dispatch_get_main_queue(), ^
           {
               block(filerMovieURL);
           });

        }];
       
//   });
}

@end
