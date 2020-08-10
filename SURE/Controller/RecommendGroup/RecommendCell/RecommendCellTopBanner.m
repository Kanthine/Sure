//
//  RecommendCellTopBanner.m
//  SURE
//
//  Created by 王玉龙 on 17/1/18.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"RecommendTopBanaerCollectionCell"

#import "RecommendCellTopBanner.h"

#import <Masonry.h>

@interface RecommendTopBanaerCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *bannerImageView;


@end

@implementation RecommendTopBanaerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self.contentView addSubview:self.bannerImageView];
        
        [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
    }
    
    return self;
}

- (UIImageView *)bannerImageView
{
    if (_bannerImageView == nil)
    {
        _bannerImageView = [[UIImageView alloc]init];
        //        _bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _bannerImageView;
}

@end




















@interface RecommendCellTopBanner ()
<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic ,strong) NSMutableArray<NSDictionary *> *bannerArray;
@property (nonatomic ,strong) UICollectionView *bannerCollectionView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@end

@implementation RecommendCellTopBanner

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bannerCollectionView];
        [self.contentView addSubview:self.pageControl];
        
        __weak __typeof(self)weakSelf = self;
        
        [self.bannerCollectionView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(weakSelf);
             make.height.mas_equalTo(@20);
             make.width.mas_equalTo(@100);
             make.bottom.mas_equalTo(@-10);
         }];
        
    }
    
    return self;
}


- (UIPageControl *)pageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = RGBA(230, 97, 224, 1);
    }
    
    return _pageControl;
}

- (UICollectionView *)bannerCollectionView
{
    if (_bannerCollectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(ScreenWidth,RecommendTopBanaerViewHeight);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeZero;//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        
        
        _bannerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RecommendTopBanaerViewHeight) collectionViewLayout:flowLayout];
        _bannerCollectionView.delegate = self;
        _bannerCollectionView.dataSource = self;
        _bannerCollectionView.backgroundColor = [UIColor whiteColor];
        _bannerCollectionView.scrollEnabled = YES;
        _bannerCollectionView.pagingEnabled = YES;
        _bannerCollectionView.showsVerticalScrollIndicator = NO;
        _bannerCollectionView.showsHorizontalScrollIndicator = NO;
        
        
        [_bannerCollectionView registerClass:[RecommendTopBanaerCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
        
    }
    
    return _bannerCollectionView;
}

#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bannerArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTopBanaerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    NSDictionary *dict = self.bannerArray[indexPath.item];
    
    NSString *imageStr = dict[@"src"];
    imageStr = [NSString stringWithFormat:@"%@/%@",ImageUrl,imageStr];
    [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / ScreenWidth;
    _pageControl.currentPage = current;
}

- (NSMutableArray<NSDictionary *>  *)bannerArray
{
    if (_bannerArray == nil)
    {
        _bannerArray = [NSMutableArray array];
    }
    
    return _bannerArray;
}

- (void)reloadTopBannerViewWithArray:(NSMutableArray *)listArray
{
    
    if (listArray && listArray.count)
    {
        [self.bannerArray removeAllObjects];
        [listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [self.bannerArray addObject:obj];
         }];
        
        self.pageControl.numberOfPages = _bannerArray.count;
        _pageControl.currentPage = 0;
        [self.bannerCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    }
    
    
    
    
    
}

@end

