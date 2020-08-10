//
//  FilerView.m
//  SURE
//
//  Created by 王玉龙 on 16/11/2.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define Collection_Cell_Weight  50
#define Collection_Cell_Height  80
#define Collection_Cell_Identifer @"FilerCell"
#define FilerCount 21

#import "FilerView.h"
#import "EditImageModel.h"
#import "FWApplyFilter.h"



@interface FilerCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) UIImage *thumbnailImage;
@property (nonatomic ,assign) NSInteger currentIndex;

- (void)reloadImage;

@end

@implementation FilerCollectionViewCell

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
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageview.tag = 10;
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.backgroundColor = [UIColor blackColor];
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    
    
    UILabel *filerNameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 30)];
    filerNameLable.tag = 11;
    filerNameLable.textColor = [UIColor lightGrayColor];
    filerNameLable.textAlignment = NSTextAlignmentCenter;
    filerNameLable.font = [UIFont systemFontOfSize:15];
    [self addSubview:filerNameLable];
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        UIImageView *imageview = (UIImageView *)[self viewWithTag:10];
        imageview.layer.borderWidth = 3;
        imageview.layer.borderColor = [UIColor redColor].CGColor;
    }
    else
    {
        UIImageView *imageview = (UIImageView *)[self viewWithTag:10];
        imageview.layer.borderWidth = 0;
    }
}

- (void)reloadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
    
    UIImage *image = _thumbnailImage;
    NSString *filerNameString = nil;
    
    
    
    switch (_currentIndex)
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
                      
    UIImageView *imageview = (UIImageView *)[self viewWithTag:10];
    UILabel *filerNameLable = (UILabel *)[self viewWithTag:11];
    filerNameLable.text = filerNameString;
    imageview.image = image;
                       });
                       
                       
                       
        });
}

@end





@interface FilerView ()
<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout >

{
    CGRect _frame;
}

@property (nonatomic ,strong) UICollectionView *collectionView;
/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;
@end

@implementation FilerView

// 出现
- (void)showInView:(UIView *)superView
{
    [superView  addSubview:self];
}

- (void)dismissFilerView
{
    [_coverButton removeFromSuperview];
    [_collectionView removeFromSuperview];
    _coverButton = nil;
    _collectionView = nil;
    [self removeFromSuperview];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _frame = frame;
        [self addSubview:self.coverButton];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UIButton *)coverButton
{
    if (_coverButton == nil)
    {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverButton.backgroundColor = [UIColor clearColor];
//        [_coverButton addTarget:self action:@selector(dismissFilerView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _coverButton;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:5];
        [flowLayout setMinimumLineSpacing:5];
        
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_frame), CGRectGetHeight(_frame)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[FilerCollectionViewCell class] forCellWithReuseIdentifier:Collection_Cell_Identifer];

    }
    
    return _collectionView;
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return FilerCount;
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
    FilerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    
    
    cell.thumbnailImage = _imageModel.thumbnailImage;
    cell.currentIndex = indexPath.row;
    
    [cell reloadImage];
    cell.selected= NO;
    if (indexPath.row == _imageModel.filerIndex)
    {
        cell.selected= YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilerCollectionViewCell *agoCell = (FilerCollectionViewCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_imageModel.filerIndex inSection:0]];
    agoCell.selected = NO;
    
    _imageModel.filerIndex = indexPath.row;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FilerViewDidSelectedFiler" object:self];
    
}

- (void)setImageModel:(EditImageModel *)imageModel
{
    _imageModel = imageModel;
     [_collectionView reloadData];
}


@end
