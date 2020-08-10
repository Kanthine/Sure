//
//  RecommendCellFive.m
//  SURE
//
//  Created by 王玉龙 on 16/11/24.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellFiveSpace 0.5f
#define Collection_CellFive_Weight  (ScreenWidth - 3 * 1.0) / 4.0
#define Collection_CellFive_Height  (Collection_CellFive_Weight + 20)

#define Collection_Cell_Identifer @"RecommendFiveCollectionCell"


#import "RecommendCellFive.h"
#import "KindListVC.h"

#import <Masonry.h>

@interface RecommendFiveCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *imageVi;

@property (nonatomic ,strong) UILabel *nameLable;

@end

@implementation RecommendFiveCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.imageVi];
        
        [self.contentView addSubview:self.nameLable];
        __weak __typeof__(self) weakSelf = self;

        
        
        
        [self.imageVi mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.width.mas_equalTo(weakSelf.imageVi.mas_height).multipliedBy(1);
         }];
        
        [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.imageVi.mas_bottom).with.offset(0);
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

- (UILabel *)nameLable
{
    if (_nameLable == nil)
    {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = TextColor149;
        _nameLable.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLable;
}


@end











@interface RecommendCellFive()

<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIButton *headerButton;
@property (nonatomic ,strong) NSMutableArray *listArray;

@end

@implementation RecommendCellFive

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

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_CellFive_Weight,Collection_CellFive_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeZero;//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RecommendCellFiveHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGBA(250, 250, 255, 1);
        _collectionView.scrollEnabled = NO;

        
        
        //自定义单元格
        [_collectionView registerClass:[RecommendFiveCollectionCell class] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        
        
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
    RecommendFiveCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    
    
    NSDictionary *dict = self.listArray[indexPath.row];
    
    NSString *image = dict[@"style"];
    image = [NSString stringWithFormat:@"%@/%@",ImageUrl,image];
    NSString *name = dict[@"cat_name"];
    
    
    [cell.imageVi sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cell.nameLable.text = name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.listArray[indexPath.row];
    KindModel *model = [KindModel modelObjectWithDictionary:dict];
    KindListVC *listVC = [[KindListVC alloc]initWithModel:model];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.currentViewControler.navigationController pushViewController:listVC animated:YES];
}

- (NSMutableArray *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (void)updateRecommendCellFiveWithDict:(NSDictionary *)dict
{
    NSArray *array = dict[@"category"];
    

    
    if (array && array.count)
    {
        [self.listArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (idx < 12)
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

