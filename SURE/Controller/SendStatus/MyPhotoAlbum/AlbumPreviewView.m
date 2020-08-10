//
//  AlbumPreviewView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "AlbumPreviewView.h"
#import "AlbumImageCropView.h"


@interface AlbumPreviewTitleView: UIView

@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) UIImageView *indicateImageView;
@property (nonatomic ,strong) UIButton *albumButton;

@end

/*
 *标题视图
 */

@implementation AlbumPreviewTitleView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self addSubview:self.titleLable];
        [self addSubview:self.indicateImageView];
        [self addSubview:self.albumButton];
    }
    
    return self;
}

- (void)layoutIfNeeded
{
    CGFloat textWidth = [_titleLable.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLable.font} context:nil].size.width;
    textWidth = textWidth + 5.0;
    _titleLable.frame = CGRectMake(0, 12, textWidth, 20);
    _indicateImageView.frame = CGRectMake(textWidth + 5, 15, 15, 15);
    _albumButton.frame = CGRectMake(0, 0, textWidth + 20, 44);
    

    CGFloat x = ( ScreenWidth - textWidth - 20 ) / 2.0;
    self.frame = CGRectMake(x, 0, textWidth + 20, 44);
    
    
    
    [super layoutIfNeeded];
}

- (UIImageView *)indicateImageView
{
    if (_indicateImageView == nil)
    {
        _indicateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_DownButton"]];
        _indicateImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _indicateImageView;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil)
    {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textAlignment = NSTextAlignmentRight;
    }
    
    return _titleLable;
}

- (UIButton *)albumButton
{
    if (_albumButton == nil)
    {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _albumButton.backgroundColor = [UIColor clearColor];
    }
    
    return _albumButton;
}

@end




@interface AlbumPreviewView()
<UIScrollViewDelegate>

@property (nonatomic ,strong) AlbumPreviewTitleView *titleView;
@property (nonatomic ,strong) UIView *topView;


@property (nonatomic ,strong) UIView *previewView;
@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIImageView *coverImageView;

@end
/*
 *图片预览图层
 */

@implementation AlbumPreviewView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.topView];
        [self addSubview:self.previewView];
    }
    
    return self;
}

- (AlbumPreviewTitleView *)titleView
{
    if (_titleView == nil)
    {
        _titleView = [[AlbumPreviewTitleView alloc]init];
        _titleView.titleLable.text = @"相机胶卷";
        [_titleView.albumButton addTarget:self action:@selector(albumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView layoutIfNeeded];
    }
    
    return _titleView;
}

- (UIView *)topView
{
    if (_topView == nil)
    {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        
        [_topView addSubview:self.cancelButton];
        [_topView addSubview:self.nextStepButton];
        [_topView addSubview:self.titleView];
    }
    
    return _topView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil)
    {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 0, 60, 44);
        cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        
        _cancelButton = cancelButton;
    }
    
    return _cancelButton;
}

- (UIButton *)nextStepButton
{
    if (_nextStepButton == nil)
    {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton.frame = CGRectMake(ScreenWidth - 70, 0, 60, 44);
        _nextStepButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStepButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _nextStepButton;
}

- (void)nextStepButtonClick
{
//    UIImage *cropImage = [self finishCroppingImage];
    UIImage *cropImage = [self captureScreen];
    _nextStepCropImageButtonClick(cropImage);
    
}

#pragma mark - 

- (UIView *)previewView
{
    if (_previewView == nil)
    {
        _previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
        _previewView.clipsToBounds = YES;
        _previewView.backgroundColor = [UIColor whiteColor];
        
        
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        scrollView.tag = 342;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.minimumZoomScale = 1.0f;
        scrollView.maximumZoomScale = 5.0f;
        scrollView.bouncesZoom = YES;
        scrollView.clipsToBounds = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentMode = UIViewContentModeCenter;
        scrollView.scrollEnabled = YES;
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenWidth);
        [scrollView addSubview:self.imageView];
        
        
        [_previewView addSubview:scrollView];
        [_previewView addSubview:self.coverImageView];

    }
    
    return _previewView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    }
    return _imageView;
}

- (UIImageView *)coverImageView
{
    if (_coverImageView == nil)
    {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _coverImageView.image = [UIImage imageNamed:@"photoCover"];
    }
    return _coverImageView;
}


- (void)resetPreviewImage:(UIImage *)selectedImage
{
    NSLog(@"size ======= %@",[NSValue valueWithCGSize:selectedImage.size]);

    CGSize imageSize = selectedImage.size;
    UIScrollView *scrollView = [_previewView viewWithTag:342];
    scrollView.zoomScale = 1.0;
    if (imageSize.width / imageSize.height <= 1.0 )
    {
        //宽 < 高 长方形图片
        CGFloat imageHeight = imageSize.height / imageSize.width * ScreenWidth;
        self.imageView.frame = CGRectMake(0, 0, ScreenWidth, imageHeight);
        scrollView.contentSize = CGSizeMake(ScreenWidth, imageHeight);
        
    }
    else
    {
        //宽 > 高 扁平图片
        CGFloat imageWidth = imageSize.width / imageSize.height * ScreenWidth;
        self.imageView.frame = CGRectMake(0, 0, imageWidth, ScreenWidth);
        scrollView.contentSize = CGSizeMake(imageWidth, ScreenWidth);
    }
    scrollView.contentOffset = CGPointMake(0, 0);
    
    self.imageView.image = selectedImage;
}


#pragma mark -

/*
 *选择相册
 */
- (void)albumButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    AlbumGroupView *groupView = [self.superview viewWithTag:6578];;
    if (sender.selected)
    {
        groupView = [[AlbumGroupView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44 - 50)];
        groupView.tag = 6578;
        __weak __typeof__(self) weakSelf = self;

        groupView.selectPhotoAlbumClick = ^(PHAssetCollection *assetCollection)
        {
            NSMutableArray *resultarray = [NSMutableArray array];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                //只加载图片
                PHFetchOptions *option = [[PHFetchOptions alloc] init];
                option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]]; //时间从近到远

                option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
                
                for (int i = 0; i < albumResult.count; i++)
                {
                    PHAsset *asset = albumResult[i];
                    [resultarray addObject:asset];
                }
                
                NSString *titleStr = [self getchineseAlbum:assetCollection.localizedTitle];
                
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    weakSelf.titleView.titleLable.text = titleStr;
                    [weakSelf.titleView layoutIfNeeded];
                    _selectPhotoAlbumClick(resultarray);
                });
            });
        };
        
        
        [self.superview addSubview:groupView];
        
        [groupView showAlbumGroupView];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI);
             [self.titleView.indicateImageView setTransform:rotate];
         }];
    }
    else
    {
        [groupView dismissAlbumGroupView];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             CGAffineTransform rotate = CGAffineTransformMakeRotation( - 0 );
             [self.titleView.indicateImageView setTransform:rotate];
         }];
    }
    
}

/**
 把英文的文件夹名称转换为中文
 */
- (NSString *)getchineseAlbum:(NSString *)name
{
    NSString *newName;
    
    if ([name rangeOfString:@"Roll"].location != NSNotFound)         newName = @"相机胶卷";
    else if ([name rangeOfString:@"Stream"].location != NSNotFound)  newName = @"我的照片流";
    else if ([name rangeOfString:@"Added"].location != NSNotFound)   newName = @"最近添加";
    else if ([name rangeOfString:@"Selfies"].location != NSNotFound) newName = @"自拍";
    else if ([name rangeOfString:@"shots"].location != NSNotFound)   newName = @"截屏";
    else if ([name rangeOfString:@"Videos"].location != NSNotFound)  newName = @"视频";
    else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)  newName = @"全景照片";
    else if ([name rangeOfString:@"Favorites"].location != NSNotFound)  newName = @"个人收藏";
    else if ([name rangeOfString:@"All Photos"].location != NSNotFound)  newName = @"所有照片";
    else newName = name;
    return newName;
}

#pragma mark - UIScrollView

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (UIImage *)finishCroppingImage
{
    UIScrollView *scrollView = [_previewView viewWithTag:342];
    float zoomScale = 1.0 / [scrollView zoomScale];
    
    
    
    NSLog(@"zoomScale ===== %f", [scrollView zoomScale]);
    
    
    NSLog(@"contentOffset ===== %@", [NSValue valueWithCGPoint:[scrollView contentOffset]]);
    
    NSLog(@"imageView ===== %@", [NSValue valueWithCGRect:self.imageView.frame]);


    
    CGRect rect;
    rect.origin.x = [scrollView contentOffset].x * zoomScale;
    rect.origin.y = [scrollView contentOffset].y * zoomScale;
    rect.size.width = [scrollView bounds].size.width * zoomScale;
    rect.size.height = [scrollView bounds].size.height * zoomScale;
    
    
 
    
    
    NSLog(@"rect ===== %@", [NSValue valueWithCGRect:rect]);

    NSLog(@"image.scale ===== %f",_imageView.image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([[_imageView image] CGImage], rect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage*)captureScreen
{
    _coverImageView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth, ScreenWidth), NO, 3.0);
    [_previewView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _coverImageView.hidden = NO;

    return viewImage;
}


@end
