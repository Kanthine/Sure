//
//  StaticFilerChooseView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/23.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define Collection_Cell_Weight  100
#define Collection_Cell_Height  130.0f
#define Collection_Cell_Identifer @"FilerChooseCell"
#define FilersCount 22

#import "StaticFilerChooseView.h"

#import "CustomCamearFilers.h"

#import "FWApplyFilter.h"


@interface StaticFilerChooseCell : UICollectionViewCell

{
    UIImageView *_imageView;
}

@property (nonatomic , strong) UILabel *filerNameLable;

@end

@implementation StaticFilerChooseCell

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
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_imageView];

    _filerNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bounds.size.height - 20, _imageView.bounds.size.width, 20)];
    _filerNameLable.textAlignment = NSTextAlignmentCenter;
    _filerNameLable.textColor = [UIColor whiteColor];
    _filerNameLable.font = [UIFont systemFontOfSize:12];
    [_imageView addSubview:_filerNameLable];
}

- (void)reloadImageWithIndex:(NSInteger)currentIndex
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       UIImage *image = [UIImage imageNamed:@"filerBack"];
                       NSString *filerNameString = nil;
                       
                       
                       
                       switch (currentIndex)
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
                       
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          
                                          _filerNameLable.text = filerNameString;
                                          _imageView.image = image;
                                      });
                       
                       
                       
                   });
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



@interface StaticFilerChooseView ()

<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout >

{
    UICollectionView *_collectionView;
    
    NSInteger _currentSelectIndex;
    
}
@end

@implementation StaticFilerChooseView

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
        
        [_collectionView registerClass:[StaticFilerChooseCell class] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        
    }
    
    
    return self;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return FilersCount;
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
    StaticFilerChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    

    [cell reloadImageWithIndex:indexPath.row];
    
    NSLog(@"row ====== %ld",indexPath.row);
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _currentSelectIndex)
    {
        
        if (_filterChooserBlock)
        {
            _filterChooserBlock(0);
        }
        
        return ;
    }
    
    
    
    
    StaticFilerChooseCell *cell_0 = (StaticFilerChooseCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (indexPath.row != 0 && cell_0.selected)
    {
        cell_0.selected = NO;
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    
    StaticFilerChooseCell *cell = (StaticFilerChooseCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    
    _currentSelectIndex = indexPath.row;
    
    if (_filterChooserBlock)
    {
        _filterChooserBlock(indexPath.row);
    }
}

- (void)addSelectedEvent:(FilerChooseBlock)filterChooseBlock
{
    _filterChooserBlock = [filterChooseBlock copy];
}


@end
