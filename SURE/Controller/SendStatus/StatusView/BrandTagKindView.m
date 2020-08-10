//
//  BrandTagKindView.m
//  SURE
//
//  Created by 王玉龙 on 17/1/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define HeaderIdentifer @"TableSectionHeaderView"
#define CellIdentifer @"BrandTagKindTableCell"

#import "BrandTagKindView.h"
#import <Masonry.h>

#pragma mark -  TableSectionHeaderView

@interface BrandTagKindTableSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic ,strong) UILabel *brandKindLable;
@property (nonatomic ,strong) UIButton *foldedButton;
@end
@implementation BrandTagKindTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.foldedButton];
        [self.contentView addSubview:self.brandKindLable];
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        __weak __typeof(self)weakSelf = self;
        [self.foldedButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.mas_equalTo(@0);
             make.left.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
         }];
        [self.brandKindLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.mas_equalTo(@10);
         }];
        
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@0);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
         }];
    }
    
    return self;
}


- (UILabel *)brandKindLable
{
    if (_brandKindLable == nil)
    {
        _brandKindLable = [[UILabel alloc]init];
        _brandKindLable.backgroundColor = [UIColor clearColor];
        _brandKindLable.font = [UIFont systemFontOfSize:14];
        _brandKindLable.textColor = TextColorBlack;
        _brandKindLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _brandKindLable;
}


- (UIButton *)foldedButton
{
    if (_foldedButton == nil)
    {
        _foldedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _foldedButton.backgroundColor = [UIColor clearColor];
    }
    
    return _foldedButton;
}

@end


#pragma mark -  BrandTagKindTableCell

@interface BrandTagKindTableCell : UITableViewCell

@property (nonatomic ,strong) UILabel *kindLable;

@end

@implementation BrandTagKindTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.kindLable];
        __weak __typeof(self)weakSelf = self;
        [self.kindLable mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(weakSelf);
             make.left.mas_equalTo(@15);
         }];
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayLineColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(@15);
             make.right.mas_equalTo(@0);
             make.bottom.mas_equalTo(@0);
             make.height.mas_equalTo(@1);
         }];
        
    }
    
    return self;
}


- (UILabel *)kindLable
{
    if (_kindLable == nil)
    {
        _kindLable = [[UILabel alloc]init];
        _kindLable.backgroundColor = [UIColor clearColor];
        _kindLable.font = [UIFont systemFontOfSize:14];
        _kindLable.textColor = TextColor149;
        _kindLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _kindLable;
}


@end






























#pragma mark - BrandTagKindView

@interface BrandTagKindView()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray<KindModel *> *listArray;
@property (nonatomic ,strong) CALayer *tableBackLayer;

@end

@implementation BrandTagKindView


- (instancetype)initWithKindList:(NSMutableArray<KindModel *> *)kindArray
{
    self = [super init];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1f];
        
        NSLog(@"kindArray ======= %@",kindArray);
        
        self.listArray = kindArray;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(dismissMySelfView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        [self addSubview:self.tableView];
        
        
        
    }
    
    return self;
}

#pragma mark - Public Method

- (void)showToSuperView:(UIView *)superView
{
    [superView addSubview:self];
        
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
    _tableView.frame = CGRectMake(ScreenWidth, 105, ScreenWidth / 2.0, ScreenHeight - 105);
    _tableBackLayer.frame = CGRectMake(ScreenWidth, 105, ScreenWidth / 2.0, ScreenHeight - 105);
    
    [UIView animateWithDuration:.3f animations:^
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.1f];
        
        _tableView.frame = CGRectMake(ScreenWidth / 2.0, 105, ScreenWidth / 2.0, ScreenHeight - 105);
        _tableBackLayer.frame = CGRectMake(ScreenWidth / 2.0, 105, ScreenWidth / 2.0, ScreenHeight - 105);

        
    } completion:^(BOOL finished)
    {
        [self.layer insertSublayer:self.tableBackLayer atIndex:1];
    }];
}


- (void)dismissMySelfView
{
    [UIView animateWithDuration:.3f animations:^
     {
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
         _tableView.frame = CGRectMake(ScreenWidth, 105, ScreenWidth / 2.0, ScreenHeight - 105);
         _tableBackLayer.frame =  CGRectMake(ScreenWidth, 105, ScreenWidth / 2.0, ScreenHeight - 105);

         
     } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

#pragma mark - Private Method

- (CALayer *)tableBackLayer
{
    if (_tableBackLayer == nil)
    {
        _tableBackLayer = [CALayer layer];
        
        _tableBackLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        _tableBackLayer.frame = CGRectMake(ScreenWidth / 2.0, 105, ScreenWidth / 2.0, ScreenHeight - 105);
        _tableBackLayer.masksToBounds=NO;
        _tableBackLayer.shadowColor=[UIColor blackColor].CGColor;
        _tableBackLayer.shadowOffset = CGSizeMake(- 5,0);
        _tableBackLayer.shadowOpacity = .5f;
        _tableBackLayer.shadowRadius=3;
    }
    
    return _tableBackLayer;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth / 2.0, 105, ScreenWidth / 2.0, ScreenHeight - 105) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.clipsToBounds = YES;
        

        
        
        [_tableView registerClass:[BrandTagKindTableCell class] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerClass:[BrandTagKindTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KindModel *model  = _listArray[section];
    
    if (model.isFolded == YES)
    {
        return 0;
    }
    else
    {
        return model.nextLevelListArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BrandTagKindTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    KindModel *model  = _listArray[section];

    headerView.brandKindLable.text = model.catName;
    headerView.foldedButton.tag = section;
    [headerView.foldedButton addTarget:self action:@selector(foldedTableViewCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandTagKindTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    KindModel *model  = _listArray[indexPath.section];
    KindModel *kindmodel  = model.nextLevelListArray[indexPath.row];

    cell.kindLable.text = kindmodel.catName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    KindModel *model  = _listArray[indexPath.section];
    KindModel *kindmodel  = model.nextLevelListArray[indexPath.row];    
    self.didSelectBrandKind(kindmodel);
    
}

- (void)foldedTableViewCellButtonClick:(UIButton *)sender
{
    [_listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        KindModel *model = obj;
        
        NSLog(@"nextLevelListArray ====== %@",model.nextLevelListArray);
        
        
        if (idx == sender.tag)
        {
            model.isFolded = !model.isFolded;
        }
        else
        {
            model.isFolded = YES;
        }
    }];
    
    [_tableView reloadData];
}



@end
