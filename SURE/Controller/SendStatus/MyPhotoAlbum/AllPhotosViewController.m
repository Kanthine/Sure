//
//  AllPhotosViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/19.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"AllPhotosCollectionCell"
#define ItemWidth (ScreenWidth - 3) / 4.0
#define ItemHeight ItemWidth

#import "AllPhotosViewController.h"
#import "AllPhotosCollectionCell.h"
#import "AlbumPreviewView.h"
#import "PhotosManager.h"

#import "PhotoEditViewController.h"

@interface AllPhotosViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

/** 未授权时调用 计时器 */
@property (nonatomic, strong) NSTimer *authorizationTimer;

@property (nonatomic ,strong) UIScrollView *contentScrollView;

/** previewView 预览图片*/
@property (nonatomic, strong) AlbumPreviewView *previewView;

@property (nonatomic ,strong) PHAsset *currentAsset;
/** collectionView 图片列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 存放改文件夹下的所有图片 */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *fetchArray;

@end

@implementation AllPhotosViewController

- (void)dealloc
{
    _authorizationTimer = nil;
    _currentAsset = nil;
    _collectionView = nil;
    _fetchArray = nil;
    _contentScrollView = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self loadAllPhotosResource];
    }
    
    return self;
}

/*
 *默认 加载所有的照片
 */
- (void)loadAllPhotosResource
{
    __weak __typeof__(self) weakSelf = self;
    
    [PhotosManager loadAllPhotosCompletionBlock:^(NSMutableArray<PHAsset *> *listArray)
     {
         weakSelf.fetchArray = listArray;
         
         if (_previewView && listArray && listArray.count)
         {
             self.currentAsset = listArray[0];
             if (_collectionView)
             {
                 [_collectionView reloadData];
             }
         }
     }];
    
    if ([PhotosManager authorizationStateAuthorized] == NO)
    {
        //计时，每隔0.2s判断一次改程序是否被允许访问相册，当允许访问相册的时候，计时器停止工作
        self.authorizationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(authorizationStateChange) userInfo:nil repeats:YES];
    }
}

/*
 *计时器的方法，来监测改程序是否被授权访问相册，如果授权访问相册了，那么计时器停止工作
 */
- (void)authorizationStateChange
{
    if ([PhotosManager authorizationStateAuthorized])
    {
        //允许访问相册，计时器停止工作
        [self.authorizationTimer invalidate];
        self.authorizationTimer = nil;
        
        if (self.fetchArray.count == 0)
        {
            __weak __typeof__(self) weakSelf = self;

            [PhotosManager loadAllPhotosCompletionBlock:^(NSMutableArray<PHAsset *> *listArray)
             {
                 weakSelf.fetchArray = listArray;
                 
                 if (_previewView && listArray && listArray.count)
                 {
                     self.currentAsset = listArray[0];
                 }
                 if (_collectionView)
                 {
                     [_collectionView reloadData];
                 }
             }];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    
    
    [self.view addSubview:self.contentScrollView];
    [self.collectionView reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    _cancelAllPhotosButtonClick();
}

- (void)setCurrentAsset:(PHAsset *)currentAsset
{
    _currentAsset = currentAsset;
    
    NSLog(@"currentAsset ===== %@",currentAsset);
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:currentAsset targetSize:CGSizeMake(1500, 1500) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         [_previewView resetPreviewImage:result];
     }];
    
    if (_contentScrollView.contentOffset.y > 10)
    {
        CGFloat yPoint = _collectionView.contentOffset.y + _contentScrollView.contentOffset.y;
//        [self.collectionView setContentOffset:CGPointMake(0, yPoint) animated:YES];
    }
    [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil)
    {
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.scrollEnabled = YES;
        _contentScrollView.delegate = self;
        [_contentScrollView addSubview:self.previewView];
        [_contentScrollView addSubview:self.collectionView];
        _contentScrollView.contentSize = CGSizeMake(ScreenWidth , ScreenHeight + ScreenWidth - 49);
    }
    
    
    return _contentScrollView;
}

- (AlbumPreviewView *)previewView
{
    if (_previewView == nil)
    {
        _previewView = [[AlbumPreviewView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth + 44)];
        [_previewView.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];

        
        if (self.fetchArray && self.fetchArray.count)
        {
            self.currentAsset = self.fetchArray[0];
        }
        
        __weak __typeof__(self) weakSelf = self;
        _previewView.selectPhotoAlbumClick = ^(NSMutableArray<PHAsset *> *listArray)
        {
            weakSelf.fetchArray = listArray;
            [weakSelf.collectionView reloadData];
        };
        
        _previewView.nextStepCropImageButtonClick = ^(UIImage *image)
        {
            SurePhotoModel *model = [[SurePhotoModel alloc]init];
            model.originalImage = image;
            [model compressOriginalImageLength];
            model.modelType = SureModelTypePhoto;
            
            
            
            
            
            if ([AuthorizationManager isAuthorization] == NO)
            {
                [AuthorizationManager getAuthorizationWithViewController:weakSelf];
                
                return;
            }
            
            PhotoEditViewController *editVC = [[PhotoEditViewController alloc]initWithPhotoModel:model];
            editVC.navigationController.navigationBarHidden = YES;
            [weakSelf.navigationController pushViewController:editVC animated:YES];
            
//            weakSelf.nextStepAllPhotosButtonClick(model);
        };
    }
    
    return _previewView;
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenWidth + 45 ,ScreenWidth, ScreenHeight - 49 - 44) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        
        [_collectionView registerClass:[AllPhotosCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
    }
    
    return _collectionView;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllPhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchArray[indexPath.item];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(ItemWidth * 2.0, ItemHeight * 2.0) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
        cell.indexpath = indexPath;
        cell.assetImage = result;
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentAsset = self.fetchArray[indexPath.item];
}


- (NSMutableArray<PHAsset *>*)fetchArray
{
    if (_fetchArray == nil)
    {
        _fetchArray = [NSMutableArray array];
    }
    return _fetchArray;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPanGestureRecognizer *panGesture = scrollView.panGestureRecognizer;
    CGPoint translation = [panGesture translationInView:self.view];
    
    BOOL isUpwardGlideDirection = translation.y < 0 ? YES : NO;//YES向上滑动
    
    
    
    
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
    }
    else if ([scrollView isKindOfClass:[UIScrollView class]])
    {
        
        CGFloat yOffet = scrollView.contentOffset.y;
        
    }
    
}

@end
