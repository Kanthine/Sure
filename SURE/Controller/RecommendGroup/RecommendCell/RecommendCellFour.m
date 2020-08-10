//
//  RecommendCellFour.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define ItemWidth ( ScreenWidth - 30 ) / 2.0
#define ItemHeight ItemWidth
#define ItemIdentifer @"RecommendFourCollectionCell"

#import "RecommendCellFour.h"

#import <Masonry.h>

@interface RecommendFourCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imageVi;

@end

@implementation RecommendFourCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.imageVi];
        
        [self.imageVi mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(@0);
            make.left.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
        }];
    }
    
    return self;
}

- (UIImageView *)imageVi
{
    if (_imageVi == nil)
    {
        _imageVi = [[UIImageView alloc]init];
    }
    
    return _imageVi;
}


@end














@interface RecommendCellFour()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *listArray;

@end

@implementation RecommendCellFour

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView addSubview:self.collectionView];
    }
    
    return self;
}




- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(ItemWidth,ItemHeight);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeZero;//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:10];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RecommendCellFourHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        
        
        
        //自定义单元格
        [_collectionView registerClass:[RecommendFourCollectionCell class] forCellWithReuseIdentifier:ItemIdentifer];
        
    }
    
    return _collectionView;
}

#pragma mark - UICollectionView

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifer forIndexPath:indexPath];
    
    
    NSDictionary *dict = self.listArray[indexPath.row];
    
    NSString *image = dict[@"goods_thumb"];
    image = [NSString stringWithFormat:@"%@/%@",ImageUrl,image];
    
    
    [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (NSMutableArray *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}



- (void)updateRecommendCellFourWithDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"goods_list"];
    
    
    if (array && array.count)
    {
        [self.listArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (idx < 10)
             {
                 [self.listArray addObject:obj];
             }
             else
             {
                 * stop = YES;
             }
             
        }];
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}


@end
