//
//  RecommendCellOne.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//





#define Collection_Cell_Identifer @"RecommendOneCollectionCell"


#import "RecommendCellOne.h"

#import "RecommendOneCollectionCell.h"
#import "SingleProductDetaileVC.h"

#import "UIImage+Extend.h"

@interface RecommendCellOne()

<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIButton *headerButton;


@end

@implementation RecommendCellOne

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.headerButton];
        [self addSubview:self.collectionView];
    }
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}



- (UIButton *)headerButton
{
    if (_headerButton == nil)
    {
        _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerButton.frame = CGRectMake(0, 0, ScreenWidth, HeaderHeight);
        _headerButton.adjustsImageWhenDisabled = NO;
        _headerButton.adjustsImageWhenHighlighted = NO;
        
        
        _headerButton.clipsToBounds = YES;
        _headerButton.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
    }
    
    return _headerButton;
    
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:10];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HeaderHeight, ScreenWidth,  Collection_Cell_Height + 20) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = YES;
        [self addSubview:_collectionView];
        _collectionView.contentSize = CGSizeMake(ScreenWidth * 8, Collection_Cell_Height + 20);
        
        
        
        
        //自定义单元格
        [_collectionView registerNib:[UINib nibWithNibName:@"RecommendOneCollectionCell" bundle:nil] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height );
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CellSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CellSpace;
}

//设置头视图高度
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
    return UIEdgeInsetsMake(CellSpace, CellSpace, CellSpace, CellSpace);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendOneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    
    NSDictionary *dict = self.dataArray[indexPath.item];
    
    
    [cell updateCellWithData:dict];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *goodIDString = dict[@"goods_id"];
    
    SingleProductDetaileVC *singleVC = [[SingleProductDetaileVC alloc]init];
    singleVC.hidesBottomBarWhenPushed = YES;
    singleVC.goodIDString = goodIDString;
    [singleVC requestNetworkGetData];
    [self.currentViewControler.navigationController pushViewController:singleVC animated:YES];

}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)updateRecommendCellOneWithDict:(NSDictionary *)dict
{
    NSString *headerImage = [NSString stringWithFormat:@"%@/data/afficheimg/%@",ImageUrl,dict[@"ad_code"]];


    [_headerButton sd_setImageWithURL:[NSURL URLWithString:headerImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
         UIImage *newImage  = [image scaleToSize916];
         NSLog(@"%@ ---------- %@",newImage , imageURL);
         [_headerButton setImage:newImage forState:UIControlStateNormal];
    }];
    
    
    self.dataArray = dict[@"goods_list"];
    
}

@end
