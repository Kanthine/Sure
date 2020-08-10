//
//  SureAdvertisementTableCell.m
//  SURE
//
//  Created by 王玉龙 on 16/12/23.
//  Copyright © 2016年 longlong. All rights reserved.
//



#define CellIdentifer @"SureAdvertisementCollectionCell"

#define CellWidth (ScreenWidth / 3.7)
#define ImageWidth ( CellWidth - 30)
#define LableHeight 20.0f
#define CellHeight ( 10 + ImageWidth + LableHeight + (CellWidth - 20) * 0.33 + 10)


#import "SureAdvertisementTableCell.h"
#import <Masonry.h>

#import "BrandDetaileVC.h"




typedef NS_ENUM(NSUInteger ,BrandOppotionType)
{
    BrandOppotionTypeOppotioned = 0,
    BrandOppotionTypeOppotionNo
};


@interface SureAdvertisementCollectionCell : UICollectionViewCell

@property (nonatomic ,assign) BrandOppotionType optionType;

@property (nonatomic ,strong) UIView *imageContentView;
@property (nonatomic ,strong) UIImageView *brandImageView;
@property (nonatomic ,strong) UILabel *brandNameLable;
@property (nonatomic ,strong) UIButton *optionButton;

@end

@implementation SureAdvertisementCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = GrayLineColor.CGColor;
        
        [self.contentView addSubview:self.imageContentView];
        [self.contentView addSubview:self.brandNameLable];
        [self.contentView addSubview:self.optionButton];
        
        __weak __typeof__(self) weakSelf = self;
        
        [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@10);
             make.left.mas_equalTo(15);
             make.right.mas_equalTo(@-15);
             make.height.mas_equalTo(weakSelf.imageContentView.mas_width).multipliedBy(1);
         }];
        
        [self.brandNameLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.imageContentView.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.height.mas_equalTo(@(LableHeight));
         }];
        
        [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(weakSelf.brandNameLable.mas_bottom).with.offset(0);
             make.left.mas_equalTo(@10);
             make.right.mas_equalTo(@-10);
             make.height.mas_equalTo(weakSelf.optionButton.mas_width).multipliedBy(0.33);
             //             make.bottom.mas_equalTo(@-10);
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
        _imageContentView.layer.borderWidth = borderWidth;
        _imageContentView.layer.borderColor = TextColorPurple.CGColor;
        
        borderWidth = borderWidth + 1.5;
        [_imageContentView addSubview:self.brandImageView];
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
        _brandNameLable.backgroundColor = [UIColor whiteColor];
        _brandNameLable.textAlignment = NSTextAlignmentCenter;
        _brandNameLable.font = [UIFont systemFontOfSize:13];
        _brandNameLable.textColor = TextColorBlack;
    }
    
    return _brandNameLable;
}

- (void)setOptionType:(BrandOppotionType)optionType
{
    _optionType = optionType;
    
    
    if (optionType == BrandOppotionTypeOppotioned)
    {
        [_optionButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_optionButton setTitleColor:RGBA(230, 97, 224, 1) forState:UIControlStateNormal];
        _optionButton.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        [_optionButton setTitle:@"关注" forState:UIControlStateNormal];
        [_optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_optionButton setAttributedTitle:[self setAttributeText] forState:UIControlStateNormal];
        _optionButton.backgroundColor = RGBA(230, 97, 224, 1);
    }
    
}


- (UIButton *)optionButton
{
    if (_optionButton == nil)
    {
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _optionButton.layer.borderWidth = 1.5;
        _optionButton.layer.cornerRadius = 5;
        _optionButton.clipsToBounds = YES;
        _optionButton.layer.borderColor = RGBA(230, 97, 224, 1).CGColor;
    }
    
    return _optionButton;
}


- (NSMutableAttributedString *)setAttributeText
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"+ 关注"];

    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, @"+".length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, @"+".length)];
    
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(@"+".length, @"+ 关注".length - @"+".length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(@"+".length, @"+ 关注".length - @"+".length)];
    
    //设置文字对齐
    [string addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (28 - 13)) range:NSMakeRange(0, @"+".length)];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (32 - 13)) range:NSMakeRange(@"+".length, @"+ 关注".length - @"+".length)];
    return string;
}


@end












@interface SureAdvertisementTableCell()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UILabel *titleLable;
@property (nonatomic ,strong) NSMutableArray<BrandDetaileModel *>  *brnadArray;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation SureAdvertisementTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.contentView.backgroundColor = RGBA(250, 250, 250, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak __typeof__(self) weakSelf = self;

        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@10);
             make.height.mas_equalTo(@40);
         }];
        
        
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

- (void)refreshBrandListScrollViewWithBrandArray:(NSMutableArray *)brandArray
{
    
    
    
    if (brandArray && brandArray.count)
    {
        [self.brnadArray removeAllObjects];
        
        [brandArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [self.brnadArray addObject:obj];
        }];
        
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
    

}

- (NSMutableArray<BrandDetaileModel *>  *)brnadArray
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
        _titleLable.text = @"推荐品牌";
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
        collectionFlowLayout.minimumLineSpacing = 5;
        collectionFlowLayout.minimumInteritemSpacing = 5;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:collectionFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[SureAdvertisementCollectionCell class] forCellWithReuseIdentifier:CellIdentifer];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 10);
        
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
    SureAdvertisementCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    BrandDetaileModel *model = _brnadArray[indexPath.item];
    
    
    [cell.brandImageView sd_setImageWithURL:[NSURL URLWithString:model.brandLogoUrlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    cell.brandNameLable.text =  model.brandNameStr;

    
    if (model.isAttention)
    {
        cell.optionType = BrandOppotionTypeOppotioned;
    }
    else
    {
        cell.optionType = BrandOppotionTypeOppotionNo;
    }
    
    cell.optionButton.tag = indexPath.item + 1;
    [cell.optionButton addTarget:self action:@selector(optionBrandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetaileModel *model = _brnadArray[indexPath.item];
    BrandDetaileVC *detaileVC = [[BrandDetaileVC alloc]init];
    detaileVC.brandDataModel = model;
    detaileVC.hidesBottomBarWhenPushed = YES;
    [detaileVC requestNetworkGetData];
    [self.currentViewController.navigationController pushViewController:detaileVC animated:YES];
    
}

- (void)optionBrandButtonClick:(UIButton *)sender
{
    
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self.currentViewController];
        
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    
    
    SureAdvertisementCollectionCell *cell = sender.superview.superview;
    
    
    NSInteger index = sender.tag - 1;
    
    BrandDetaileModel *model = _brnadArray[index];

    if (model.isAttention)
    {
        // 关注 --- > 取消关注
        
        
        NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":model.brandIDStr,@"follow_type":@"2"};
        cell.optionType = BrandOppotionTypeOppotionNo;
        model.isAttention = NO;
        sender.userInteractionEnabled = NO;
        [self.currentViewController.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
         {
             sender.userInteractionEnabled = YES;
             if (error)
             {
                 model.isAttention = YES;
                 cell.optionType = BrandOppotionTypeOppotioned;
                 NSLog(@"error.domain ===== %@",error.domain);
             }
             else
             {
                 NSLog(@"取消关注");
                 
             }
         }];
        
    }
    else
    {
        
        // 未关注 --- > 关注

        NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":model.brandIDStr,@"follow_type":@"2"};
        model.isAttention = YES;
        cell.optionType = BrandOppotionTypeOppotioned;
        sender.userInteractionEnabled = NO;

        [self.currentViewController.httpManager attentionWithParameterDict:dict CompletionBlock:^(NSError *error)
         {
             sender.userInteractionEnabled = YES;
             if (error)
             {
                 model.isAttention = NO;
                 cell.optionType = BrandOppotionTypeOppotionNo;

                 NSLog(@"error.domain ===== %@",error.domain);
             }
             else
             {
                 NSLog(@"成功关注");
             }
         }];

    }
}


@end
