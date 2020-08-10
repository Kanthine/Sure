//
//  RecommendCellTwo.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define ItemWidth ( ScreenWidth - 30 ) / 2.0
#define ItemHeight ItemWidth
#define ItemIdentifer @"RecommendTwoCollectionCell"


#import "RecommendCellTwo.h"


#import "BrandDetaileVC.h"





#import <Masonry.h>

@interface RecommendTwoCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imageVi;

@end

@implementation RecommendTwoCollectionCell

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






































@interface RecommendCellTwo()

<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIButton *headerButton;


@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation RecommendCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headerButton];
        [self.contentView addSubview:self.collectionView];
    }
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_TwoCell_Weight,Collection_TwoCell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeZero;//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:10];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  Collection_TwoCell_Height + 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        
        
        
        
        //自定义单元格
        [_collectionView registerClass:[RecommendTwoCollectionCell class] forCellWithReuseIdentifier:ItemIdentifer];
        
        
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
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTwoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifer forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    NSString *image = dict[@"brand_img"];
    image = [NSString stringWithFormat:@"%@/%@",ImageUrl,image];
    
    [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *brandID = dict[@"supplier_id"];
    
    BrandDetaileVC *detaileVC = [[BrandDetaileVC alloc]init];
    detaileVC.hidesBottomBarWhenPushed = YES;
    detaileVC.brandIDString = brandID;
    [detaileVC requestNetworkGetData];
    [self.currentViewControler.navigationController pushViewController:detaileVC animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)updateRecommendCellTwoWithDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"supplier_list"];

    
    if (array && array.count)
    {
        [self.dataArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (idx < 10)
             {
                 [self.dataArray addObject:obj];
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
