//
//  SureBrandListTableCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"SureBrandListCollectionCell"

#define CellWidth (ScreenWidth / 5.7)
#define CellHeight (CellWidth + 20)

#import "SureBrandListTableCell.h"
#import <Masonry.h>


#import "MySureViewController.h"

@interface SureBrandListCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIView *imageContentView;
@property (nonatomic ,strong) UIImageView *brandImageView;
@property (nonatomic ,strong) UILabel *brandNameLable;

@end

@implementation SureBrandListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.imageContentView];
        [self.contentView addSubview:self.brandNameLable];
        
        __weak __typeof__(self) weakSelf = self;

        [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@5);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(weakSelf.imageContentView.mas_width).multipliedBy(1);
         }];
        
        
        [self.brandNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.imageContentView.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@15);
         }];

    }
    
    return self;
}

- (UIView *)imageContentView
{
    if (_imageContentView == nil)
    {
        CGFloat borderWidth = 1.5;
        
        _imageContentView = [[UIView alloc]init];
//        _imageContentView.layer.borderWidth = borderWidth;
//        _imageContentView.layer.borderColor = TextColorPurple.CGColor;
//        _imageContentView.clipsToBounds = YES;
//        _imageContentView.layer.cornerRadius = CellWidth / 2.0;
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sure_Plus_Pressed"]];
        [_imageContentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@(0));
             make.left.mas_equalTo(@(0));
             make.bottom.mas_equalTo(@(0));
             make.right.mas_equalTo(@(0));
         }];
        
        
        borderWidth = borderWidth + 1.5;
        [_imageContentView addSubview:self.brandImageView];
        _brandImageView.layer.cornerRadius = (CellWidth - borderWidth * 2) / 2.0;
        [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@(borderWidth));
             make.left.mas_equalTo(@(borderWidth));
             make.bottom.mas_equalTo(@(-borderWidth));
             make.right.mas_equalTo(@(-borderWidth));
         }];
    }
    
    return _imageContentView;
}


- (UIImageView *)brandImageView
{
    if (_brandImageView == nil)
    {
        _brandImageView = [[UIImageView alloc]init];
        _brandImageView.contentMode = UIViewContentModeScaleAspectFit;
        _brandImageView.clipsToBounds = YES;
    }
    
    return _brandImageView;
}

- (UILabel *)brandNameLable
{
    if (_brandNameLable == nil)
    {
        _brandNameLable = [[UILabel alloc]init];
        _brandNameLable.backgroundColor = [UIColor clearColor];
        _brandNameLable.textAlignment = NSTextAlignmentCenter;
        _brandNameLable.font = [UIFont systemFontOfSize:13];
        _brandNameLable.textColor = TextColorBlack;
    }
    
    return _brandNameLable;
}

@end












@interface SureBrandListTableCell()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) NSMutableArray *brnadArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation SureBrandListTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.contentView.backgroundColor = RGBA(250, 250, 250, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.height.mas_equalTo(@30);
         }];

        __weak __typeof__(self) weakSelf = self;

        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.titleLable.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@(CellHeight + 10));
         }];
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@0.5);
         }];
    }
    
    return self;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)refreshBrandListScrollViewWithBrandArray:(NSMutableArray *)userArray
{
    
    if (userArray && userArray.count)
    {
        [self.brnadArray removeAllObjects];
        
        
        
        [userArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            [self.brnadArray addObject:obj];
        }];
        
        NSLog(@"%@",self.brnadArray);
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

    }

    
}

- (NSMutableArray *)brnadArray
{
    if (_brnadArray == nil)
    {
        _brnadArray = [NSMutableArray array];
    }
    return _brnadArray;
}

- (UILabel *)titleLable
{
    if (_titleLable == nil)
    {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = TextColorBlack;
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.text = @"推荐达人";
    }
    
    return _titleLable;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        
        UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionFlowLayout.itemSize = CGSizeMake(CellWidth, CellHeight);
        collectionFlowLayout.minimumLineSpacing = 10;
        collectionFlowLayout.minimumInteritemSpacing = 10;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[SureBrandListCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 10, 10);
        
    }
    
    return _collectionView;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.brnadArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SureBrandListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    AccountInfo *account = _brnadArray[indexPath.item];
    
    [cell.brandImageView sd_setImageWithURL:[NSURL URLWithString:account.headimg] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    cell.brandNameLable.text =  account.nickname;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AccountInfo *acount = _brnadArray[indexPath.item];
    
    [self pushOtherDetaileWithOptionUserID:acount.userId];
}


- (void)pushOtherDetaileWithOptionUserID:(NSString *)optionUserID
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        //未登录
        MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:optionUserID UserID:@"" UserType:SureUserTypeOtherNoAttention SureListType:SureListTypeSURE];
        detaileVC.hidesBottomBarWhenPushed = YES;
        [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
    }
    else
    {
        //已登录
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.userId isEqualToString:optionUserID])
        {
            // 判断当前状态用户是自己
            MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:optionUserID UserID:account.userId UserType:SureUserTypeMy SureListType:SureListTypeSURE];
            detaileVC.hidesBottomBarWhenPushed = YES;
            [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
        }
        else
        {
            // 判断当前状态用户不是自己
            MySureViewController *detaileVC = [[MySureViewController alloc]initWithParentID:optionUserID UserID:account.userId UserType:SureUserTypeOtherNoAttention SureListType:SureListTypeSURE];
            detaileVC.hidesBottomBarWhenPushed = YES;
            [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
            
        }
    }
    
}


@end
