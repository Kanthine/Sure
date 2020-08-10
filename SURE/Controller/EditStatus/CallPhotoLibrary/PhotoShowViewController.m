//
//  PhotoShowViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define kAssetViewCellIdentifier           @"AssetViewCellIdentifier"

#define kPopoverContentSize CGSizeMake(ScreenWidth, ScreenHeight - 44 - 49)
#define kThumbnailLength    (ScreenWidth - 5 * 2 )/ 4.0   //78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)


#import "PhotoShowViewController.h"

#import "PhotoLibraryViewController.h"
#import "AssetViewCell.h"

@interface PhotoShowViewController ()

<AssetViewCellDelegate>

{
    int columns;
    
    float minimumInteritemSpacing;
    float minimumLineSpacing;
    
    BOOL unFirst;
}

@property (nonatomic, strong) NSMutableArray *assetsArray; //分组 具体照片 数组
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

@implementation PhotoShowViewController

- (id)init
{
    _indexPathsForSelectedItemsArray = [[NSMutableArray alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
    minimumInteritemSpacing = 2;
    minimumLineSpacing = 2;
    
    if (self = [super init])
    {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
    }
    
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    PhotoLibraryViewController *vc = (PhotoLibraryViewController *)self.navigationController;
    NSLog(@"indexPathsForSelectedItemsArray ===== %@",vc.indexPathsForSelectedItemsArray);
    
    
    
    
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    if (unFirst == NO)
    {
        columns = floor(ScreenWidth / (kThumbnailSize.width + minimumInteritemSpacing));
        
        [self setupAssets];
        
        unFirst = YES;
    }
}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing=2;
        minimumLineSpacing=2;
    }
    else
    {
        self.tableView.contentInset=UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        minimumInteritemSpacing=2;
        minimumLineSpacing=2;
    }
    
    columns=floor(ScreenWidth / (kThumbnailSize.width + minimumInteritemSpacing));
    
    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupViews
{
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)setupButtons
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navBar_LeftButton"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"继续"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
}

- (void)leftBarButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;
    
    if (self.assetsArray == nil)
    {
        self.assetsArray = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.assetsArray removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        
        if (asset)
        {
            [self.assetsArray addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        else if (self.assetsArray.count > 0)
        {
            [self.tableView reloadData];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self.assetsArray.count*1.0/columns)  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - UITableView DataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 最后一行 几张图片几个视频
    if (indexPath.row == ceil(self.assetsArray.count * 1.0 / columns))
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
            cell.textLabel.font=[UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        NSString *title;
        
        if (_numberOfVideos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
        else if (_numberOfPhotos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
        else
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        
        cell.textLabel.text=title;
        return cell;
    }
    
    
    NSMutableArray *tempAssetsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < columns; i ++)
    {
        if ((indexPath.row * columns + i) < self.assetsArray.count)
        {
            [tempAssetsArray addObject:[self.assetsArray objectAtIndex:indexPath.row*columns + i]];
        }
    }
    
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    PhotoLibraryViewController *picker = (PhotoLibraryViewController *)self.navigationController;
    
    AssetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell = [[AssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.selfNavBarController = self.navigationController;
    [cell bind:tempAssetsArray selectionFilter:picker.selectionFilter minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing columns:columns assetViewX:(ScreenWidth - kThumbnailSize.width * tempAssetsArray.count - minimumInteritemSpacing * (tempAssetsArray.count - 1)) / 2];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.assetsArray.count * 1.0 / columns) + 1;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ceil(self.assetsArray.count * 1.0 / columns))
    {
        return 44;
    }
    

    return kThumbnailSize.height + minimumLineSpacing;
}


#pragma mark - ZYQAssetViewCell Delegate

// 选中照片之后的操作
- (BOOL)shouldSelectAsset:(ALAsset *)asset
{
    PhotoLibraryViewController *vc = (PhotoLibraryViewController *)self.navigationController;
    
    BOOL selectable = [vc.selectionFilter evaluateWithObject:asset];
    if (_indexPathsForSelectedItemsArray.count > vc.maximumNumberOfSelection)
    {
        if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)])
        {
            [vc.delegate assetPickerControllerDidMaximum:vc];
        }
    }
    

    
    // 一直返回YES
    return (selectable && _indexPathsForSelectedItemsArray.count < vc.maximumNumberOfSelection);
}

// 选中照片
- (void)didSelectAsset:(ALAsset *)asset
{
    [_indexPathsForSelectedItemsArray addObject:asset];
    
    PhotoLibraryViewController *vc = (PhotoLibraryViewController *)self.navigationController;
    
    vc.indexPathsForSelectedItemsArray = _indexPathsForSelectedItemsArray;
    
    if (vc.delegate != nil && [vc.delegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)])
        [vc.delegate assetPickerController:vc didSelectAsset:asset];
    
    //设置标题
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItemsArray];
}

//取消选中状态
- (void)didDeselectAsset:(ALAsset *)asset
{
    [_indexPathsForSelectedItemsArray removeObject:asset];
    
    PhotoLibraryViewController *vc = (PhotoLibraryViewController *)self.navigationController;
    
    vc.indexPathsForSelectedItemsArray = _indexPathsForSelectedItemsArray;
    
    if (vc.delegate!=nil&&[vc.delegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)])
        [vc.delegate assetPickerController:vc didDeselectAsset:asset];
    
    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItemsArray];
}

#pragma mark - Title

//设置导航栏标题
- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (int i=0; i<indexPaths.count; i++)
    {
        ALAsset *asset = indexPaths[i];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
        
    }
    
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    
    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    
    self.title = [NSString stringWithFormat:format, (long)indexPaths.count];
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender
{
    if (_indexPathsForSelectedItemsArray.count == 0)
    {
        return;
    }
    
    PhotoLibraryViewController *picker = (PhotoLibraryViewController *)self.navigationController;
    
    if (_indexPathsForSelectedItemsArray.count < picker.minimumNumberOfSelection)
    {
        if (picker.delegate!=nil&&[picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)])
        {
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }
    
//    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingImageArray:)])
//    {
//        NSMutableArray *imageArray = [NSMutableArray array];
//        for (int i=0; i< _indexPathsForSelectedItemsArray.count; i++)
//        {
//            ALAsset *asset= _indexPathsForSelectedItemsArray[i];
//            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            [imageArray addObject:tempImg];
//        }
//        
//        [picker.delegate assetPickerController:picker didFinishPickingImageArray:imageArray];
//    }
    
    
    if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
    {
        [picker.delegate assetPickerController:picker didFinishPickingAssets:_indexPathsForSelectedItemsArray];
    }
    
}

@end
