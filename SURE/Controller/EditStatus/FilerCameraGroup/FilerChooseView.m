//
//  FilerChooseView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/3.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define Collection_Cell_Weight  100
#define Collection_Cell_Height  130.0f
#define Collection_Cell_Identifer @"FilerChooseCell"



#import "FilerChooseView.h"

#import "CustomCamearFilers.h"

@interface FilerChooseViewCell : UICollectionViewCell

{
    GPUImageView *_gpuImageView;
    GPUImageFilterGroup *_filerGroup;
}

@property (nonatomic , strong) UILabel *filerNameLable;


- (void)setFilter:(GPUImageFilterGroup *)filter;

- (GPUImageFilterGroup *)getFilter;

@end

@implementation FilerChooseViewCell

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUI];
    }
    
    return self;
}

- (void)setUI
{
//    _gpuImageView = [[GPUImageView alloc] initWithFrame:self.bounds];
//    _gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    [self addSubview:_gpuImageView];
//    
//    _filerNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _gpuImageView.bounds.size.height - 20, _gpuImageView.bounds.size.width, 20)];
//    _filerNameLable.textAlignment = NSTextAlignmentCenter;
//    _filerNameLable.textColor = [UIColor whiteColor];
//    _filerNameLable.font = [UIFont systemFontOfSize:12];
//    [_gpuImageView addSubview:_filerNameLable];
}


- (void)setFilter:(GPUImageFilterGroup *)filter
{
    
    if (_gpuImageView != nil)
    {
        [_gpuImageView removeFromSuperview];
        _gpuImageView = nil;
    }
    
    
    _gpuImageView = [[GPUImageView alloc] initWithFrame:self.bounds];
    _gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self addSubview:_gpuImageView];
    
    _filerNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _gpuImageView.bounds.size.height - 20, _gpuImageView.bounds.size.width, 20)];
    _filerNameLable.textAlignment = NSTextAlignmentCenter;
    _filerNameLable.textColor = [UIColor whiteColor];
    _filerNameLable.font = [UIFont systemFontOfSize:12];
    [_gpuImageView addSubview:_filerNameLable];
    
    
    [filter removeAllTargets];
    [filter addTarget:_gpuImageView];
    
    NSLog(@"filter ----- %@",filter);
    NSLog(@"targets ==== %@",filter.targets);
    
    _filerGroup = filter;
    _gpuImageView.layer.borderColor = filter.color.CGColor;
    self.filerNameLable.backgroundColor = filter.color;
    self.filerNameLable.text = filter.title;
}

- (GPUImageFilterGroup *)getFilter
{
    return _filerGroup;
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.layer.borderWidth = 3;
        self.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        self.layer.borderWidth = 0;
    }
}

@end


@interface FilerChooseView ()

<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout >

{
    UICollectionView *_collectionView;

    NSArray *_filtersArray;
    NSInteger _currentSelectIndex;
    
}
@end

@implementation FilerChooseView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:5];
        [flowLayout setMinimumLineSpacing:5];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[FilerChooseViewCell class] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        
    }
    
    
    return self;
}


- (void)addFilters:(NSArray *)filtersArray
{
    _currentSelectIndex = 0;
    
    _filtersArray = filtersArray;
    
    
    [_collectionView reloadData];
//    FilerChooseViewCell *cell_0 = (FilerChooseViewCell *) [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    cell_0.selected = YES;
//    [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
}


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_filtersArray.count)
    {
        return _filtersArray.count;
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilerChooseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];

    
    
//    if (_currentSelectIndex ==0 && indexPath.row == 0)
//    {
//        cell.selected = YES;
//    }
    
    GPUImageFilterGroup *filters = _filtersArray[indexPath.row];
    [cell setFilter:filters];
    
    NSLog(@"row ====== %ld",indexPath.row);
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _currentSelectIndex)
    {
        
        if (_filterChooserBlock)
        {
            _filterChooserBlock(nil ,0);
        }
        
        return ;
    }
    
    
 
    
    FilerChooseViewCell *cell_0 = (FilerChooseViewCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (indexPath.row != 0 && cell_0.selected)
    {
        cell_0.selected = NO;
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    
    FilerChooseViewCell *cell = (FilerChooseViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

    
    _currentSelectIndex = indexPath.row;
    
    if (_filterChooserBlock)
    {
        _filterChooserBlock(cell.getFilter ,indexPath.row);
    }
}

- (void)addSelectedEvent:(FilerChooseBlock)filterChooseBlock
{
    _filterChooserBlock = [filterChooseBlock copy];
}


@end
