//
//  AlbumLibraryPhotoVC.m
//  SURE
//
//  Created by 王玉龙 on 17/1/12.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"AllPhotosCollectionCell"
#define ItemWidth (ScreenWidth - 3) / 4.0
#define ItemHeight ItemWidth

#import "AlbumLibraryPhotoVC.h"
#import "PhotoCropViewController.h"
#import "AllPhotosCollectionCell.h"

@interface AlbumLibraryPhotoVC ()
<UICollectionViewDelegate,UICollectionViewDataSource>

/** collectionView 图片列表*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 存放改文件夹下的所有图片 */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *fetchArray;

@end

@implementation AlbumLibraryPhotoVC

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection
{
    self = [super init];
    
    if (self)
    {
        [self loadAssetWithAssetCollection:assetCollection];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight - 64) collectionViewLayout:layout];
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
    PHAsset *currentAsset = self.fetchArray[indexPath.item];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:currentAsset targetSize:CGSizeMake(ScreenWidth * 2.0, ScreenWidth * 2.0) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
     {
         
         BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
         
         if (downloadFinined)
         {
             PhotoCropViewController *cropVC = [[PhotoCropViewController alloc]initWithImage:result cropFrame:CGRectMake(0, (ScreenHeight - 64 - self.cropSize.height) / 2.0, self.cropSize.width, self.cropSize.height) limitScaleRatio:3];
             [self.navigationController pushViewController:cropVC animated:YES];
         }
     }];
}


- (NSMutableArray<PHAsset *>*)fetchArray
{
    if (_fetchArray == nil)
    {
        _fetchArray = [NSMutableArray array];
    }
    return _fetchArray;
}

- (void)loadAssetWithAssetCollection:(PHAssetCollection *)assetCollection
{
    __weak __typeof__(self) weakSelf = self;

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
               [self.fetchArray addObject:asset];
           }
           
           NSString *titleStr = [self getchineseAlbum:assetCollection.localizedTitle];
           
           dispatch_async(dispatch_get_main_queue(), ^
              {
                  weakSelf.navigationItem.title = titleStr;
                  [weakSelf.collectionView reloadData];
              });
       });


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


@end
