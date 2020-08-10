//
//  PhotoFilerChooseView.m
//  SURE
//
//  Created by 王玉龙 on 16/12/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"PhotoFilerChooseCollectionCell"
#define ItemWidth ScreenWidth / 4.0
#define ItemHeight (ItemWidth + 20.0)


#import "PhotoFilerChooseView.h"
#import "FilerManager.h"
#import <Masonry.h>

@interface PhotoFilerChooseCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UILabel *filerNameLable;
@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation PhotoFilerChooseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.filerNameLable];
        [self addSubview:self.imageView];
        
        
        
        __weak __typeof__(self) weakSelf = self;
        [self.filerNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.height.mas_equalTo(@20);
             make.right.mas_equalTo(@0);
         }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_filerNameLable.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.width.mas_equalTo(weakSelf.imageView.mas_height).multipliedBy(1);
         }];

    }
    
    return self;
}

- (UILabel *)filerNameLable
{
    if (_filerNameLable == nil)
    {
        _filerNameLable = [[UILabel alloc]init];
        _filerNameLable.textColor = TextColor149;
        _filerNameLable.font = [UIFont systemFontOfSize:13];
        _filerNameLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _filerNameLable;
}

- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

@end








@interface PhotoFilerChooseView()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray<NSDictionary *> *filerArray;

@end

@implementation PhotoFilerChooseView

- (instancetype)initWithFrame:(CGRect)frame ThumbnailImage:(UIImage *)thumbnailImage
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        __weak __typeof__(self) weakSelf = self;

        [FilerManager loadFilerWithOriginalImage:thumbnailImage CompletionBlock:^(NSMutableArray<NSDictionary *> *filerListArray)
        {
            weakSelf.filerArray = filerListArray;
            [weakSelf.collectionView reloadData];
        }];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        [_collectionView registerClass:[PhotoFilerChooseCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filerArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoFilerChooseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    NSDictionary *dict = _filerArray[indexPath.item];
    
    cell.filerNameLable.text = [dict objectForKey:FilerNameKey];
    cell.imageView.image = [dict objectForKey:FilerImageKey];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoFilerChooseCollectionCell *cell = (PhotoFilerChooseCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    _didSelectItemAtIndexPath(indexPath,cell.imageView.image);
}


@end
