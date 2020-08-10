//
//  KindViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define Collection_Cell_Weight  (ScreenWidth - 2 )/ 3.0
#define Collection_Cell_Height  Collection_Cell_Weight
#define Collection_Cell_Identifer @"HomeCollectionCell"

#define SegmentedViewHeight 45.0f

#import "KindViewController.h"

#import "ScanLifeViewController.h"


#import "SingleProductCollectionCell.h"
#import "KindListVC.h"

#import "SearchResultVC.h"

@interface KindViewController ()

<UISearchResultsUpdating,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

{
    UISearchController *_searchController;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_tempsArray;
    
    
}

@property (nonatomic ,strong) NSMutableArray<KindModel *> *secondLevelTitleArray;
@property (nonatomic ,strong) NSMutableArray<KindModel *> *dataArray;
@property (nonatomic ,strong) NSMutableArray<KindModel *> *firstDataArray;
@property (nonatomic ,strong) UISegmentedControl *segmentedControl;
@property (nonatomic ,strong) UICollectionView *kindCollectionView;




@property (nonatomic ,strong) UIBarButtonItem *carItem;
@property (nonatomic ,strong) UIBarButtonItem *barCodeItem;


@property (nonatomic ,strong) UIScrollView *segmentedView;

@end

@implementation KindViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self customNavBar];
    
    [self.view addSubview:self.kindCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = _searchController.searchBar;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.titleView = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    
    [self setSearchController];

    
    self.navigationItem.leftBarButtonItem = self.barCodeItem;
    self.navigationItem.rightBarButtonItem = self.carItem;

    
}

- (UIBarButtonItem *)carItem
{
    if (_carItem == nil)
    {
        
        UIButton *carButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [carButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [carButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
        [carButton addTarget:self action:@selector(carButtonClick) forControlEvents:UIControlEventTouchUpInside];
        carButton.adjustsImageWhenHighlighted = NO;
        carButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        carButton.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *carItem = [[UIBarButtonItem alloc]initWithCustomView:carButton];

        _carItem = carItem;
    }
    
    return _carItem;
}


- (UIBarButtonItem *)barCodeItem
{
    if (_barCodeItem == nil)
    {
        
        UIButton *barcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [barcodeButton setImage:[UIImage imageNamed:@"navBar_BarCode"] forState:UIControlStateNormal];
        [barcodeButton addTarget:self action:@selector(barcodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        barcodeButton.adjustsImageWhenHighlighted = NO;
        barcodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        barcodeButton.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *barCodeItem = [[UIBarButtonItem alloc]initWithCustomView:barcodeButton];

        _barCodeItem = barCodeItem;
    }
    
    return _barCodeItem;
}



-(void)carButtonClick
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

- (void)barcodeButtonClick
{
    ScanLifeViewController *scanVC = [[ScanLifeViewController alloc]init];
    scanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil)
    {
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"男士", @"女士",nil]];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = [UIColor lightGrayColor];
        _segmentedControl.layer.cornerRadius = 5;
        _segmentedControl.clipsToBounds = YES;
        [_segmentedControl addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.frame = CGRectMake((ScreenWidth - 200 ) / 2.0, -90, 200, 30);
    }
    
    return _segmentedControl;
}

- (void)segmentedControlClick:(UISegmentedControl *)sender
{
    NSLog(@"sender.selectedSegmentIndex ==== %ld",sender.selectedSegmentIndex);
    
    
    if (sender.selectedSegmentIndex == 0)
    {
        //男士
        [self.firstDataArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if ([obj.catName isEqualToString:@"男士"])
            {
                
                self.secondLevelTitleArray = obj.nextLevelListArray;
                [self reloadSegmentedViewDataWithArray:self.secondLevelTitleArray];

                * stop = YES;
            }
        }];
        
        
        
        
//        [self requestNetworkGetSecondLevelDataWith:@"1"];
        
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        //女士
        [self.firstDataArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([obj.catName isEqualToString:@"女士"])
             {
                 self.secondLevelTitleArray = obj.nextLevelListArray;
                 [self reloadSegmentedViewDataWithArray:self.secondLevelTitleArray];
                 * stop = YES;
             }
         }];

//        [self requestNetworkGetSecondLevelDataWith:@"2"];
        
    }
    
}

- (UIScrollView *)segmentedView
{
    if (_segmentedView == nil)
    {
        _segmentedView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,-50 , ScreenWidth, SegmentedViewHeight)];
        _segmentedView.showsVerticalScrollIndicator = NO;
        _segmentedView.showsHorizontalScrollIndicator = NO;
        _segmentedView.pagingEnabled = NO;
        _segmentedView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *grayLable1 = [[UILabel alloc]initWithFrame:CGRectMake(-ScreenWidth, 0, ScreenWidth * 5, 1)];
        grayLable1.backgroundColor = GrayColor;
        [_segmentedView addSubview:grayLable1];
        UILabel *grayLable2 = [[UILabel alloc]initWithFrame:CGRectMake(-ScreenWidth, SegmentedViewHeight - 1, ScreenWidth * 5, 1)];
        grayLable2.backgroundColor = GrayColor;
        [_segmentedView addSubview:grayLable2];
        

    }
    
    return _segmentedView;
}

- (void)reloadSegmentedViewDataWithArray:(NSMutableArray<KindModel *> *)titleArray
{
    CGFloat buttonWidth = ScreenWidth / 4.0;
    self.secondLevelTitleArray = titleArray;
    [self.segmentedView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if (obj.tag > 9)
         {
             [obj removeFromSuperview];
         }
    }];
    
    
    [titleArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, SegmentedViewHeight);
        button.tag = idx + 10;
        [button addTarget:self action:@selector(switchKindSegmentedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIColor *color = idx == 0 ? RGBA(141, 31, 203,1) : [UIColor lightGrayColor];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitle:obj.catName forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_segmentedView addSubview:button];

    }];
    
    KindModel *model = titleArray[0];
    
    
    self.dataArray = model.nextLevelListArray;
    [self.kindCollectionView reloadData];
    
    _segmentedView.contentSize = CGSizeMake(buttonWidth * titleArray.count, SegmentedViewHeight);
}

- (void)switchKindSegmentedButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    UIView *segmentedView = sender.superview;
    
    for (UIView *view in segmentedView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [(UIButton *)view setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    
    [sender setTitleColor:RGBA(141, 31, 203,1) forState:UIControlStateNormal];
    
    
    KindModel *model = self.secondLevelTitleArray[index];
    
    
    self.dataArray = model.nextLevelListArray;
    [self.kindCollectionView reloadData];
    
//    [self requestNetworkGetThreeLevelDataWith:model.catId];
}

- (UICollectionView *)kindCollectionView
{
    if (_kindCollectionView == nil)
    {
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        
        _kindCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight - 64) collectionViewLayout:flowLayout];
        _kindCollectionView.delegate = self;
        _kindCollectionView.dataSource = self;
        _kindCollectionView.showsVerticalScrollIndicator = NO;
        _kindCollectionView.showsHorizontalScrollIndicator = NO;
        _kindCollectionView.backgroundColor = [UIColor whiteColor];
        _kindCollectionView.scrollEnabled = YES;

        
        //自定义单元格
        [_kindCollectionView registerNib:[UINib nibWithNibName:@"SingleProductCollectionCell" bundle:nil] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        [_kindCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        
        
        
        _kindCollectionView.contentInset = UIEdgeInsetsMake(95, 0, 49, 0);
        [_kindCollectionView addSubview:self.segmentedControl];
        [_kindCollectionView addSubview:self.segmentedView];

    }
    
    return _kindCollectionView;
}

- (void)setSearchController
{
    _searchResultArray = [NSMutableArray array];
    for (int i = 1; i < 11 ; i ++)
    {
        NSString *str = [NSString stringWithFormat:@"测试数据%d",i];
        [_searchResultArray addObject:str];
    }
    _tempsArray = [NSMutableArray array];
    
    self.definesPresentationContext = YES;

    
    
    SearchResultVC *resultTVC = [[SearchResultVC alloc] init];
    resultTVC.view.frame = CGRectMake(0,- 80 , ScreenWidth, ScreenHeight);

    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:resultTVC];
    
    [_searchController.searchBar sizeToFit];
    _searchController.searchResultsUpdater = self;
    
    
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
//    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;

//    _searchController.searchBar.frame = CGRectMake(45, 0, ScreenWidth - 90, 44);
    _searchController.searchBar.delegate = self;
    
   
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    SearchResultVC *resultVC = (SearchResultVC *)_searchController.searchResultsController;
    NSLog(@"searchResultsController == %@",_searchController.searchResultsController.view);
    
    [self filterContentForSearchText:_searchController.searchBar.text];
    resultVC.resultsArray = _tempsArray;
    [resultVC.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    [_tempsArray removeAllObjects];
    for (int i = 0; i < _searchResultArray.count; i++)
    {
        NSString *title = _searchResultArray[i];
        NSRange storeRange = NSMakeRange(0, title.length);
        NSRange foundRange = [title rangeOfString:searchText options:searchOptions range:storeRange];
        
        if (foundRange.length)
        {
            [_tempsArray addObject:_searchResultArray[i]];
        }
    }

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
    
    
    self.navigationItem.leftBarButtonItem = self.barCodeItem;
    self.navigationItem.rightBarButtonItem = self.carItem;

    return YES;
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (yOffset <= -45)
    {
        _segmentedView.frame = CGRectMake(0, -50, ScreenWidth, SegmentedViewHeight);
    }
    else
    {
        _segmentedView.frame = CGRectMake(0, yOffset, ScreenWidth, 45);
    }

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
    SingleProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    KindModel *model = self.dataArray[indexPath.item];
    
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@",ImageUrl,model.style];
    
    
    [cell.singleImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KindModel *model = self.dataArray[indexPath.item];

    KindListVC *listVC = [[KindListVC alloc]initWithModel:model];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (NSMutableArray<KindModel *> *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray<KindModel *> *)secondLevelTitleArray
{
    if (_secondLevelTitleArray == nil)
    {
        _secondLevelTitleArray = [NSMutableArray array];

    }
    return _secondLevelTitleArray;
}

- (void)requestNetworkGetData
{
    //默认是男士
    [self.httpManager getAllKindCompletionBlock:^(NSMutableArray<KindModel *> *listArray, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {

            self.firstDataArray = listArray;
            
            [self.firstDataArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 if ([obj.catName isEqualToString:@"男士"])
                 {
                     
                     self.secondLevelTitleArray = obj.nextLevelListArray;
                     [self reloadSegmentedViewDataWithArray:self.secondLevelTitleArray];
                     
                     * stop = YES;
                 }
             }];
            
        }
    }];
    
    
//    [self requestNetworkGetSecondLevelDataWith:@"1"];
}

/*
 * 根据性别 拿到二级分类列表
 *
 * sexString : 1 是男 2 是女
 */
- (void)requestNetworkGetSecondLevelDataWith:(NSString *)sexString
{
    NSDictionary *dict = @{@"cur_page":@"1",@"cur_size":@"20",@"parent_id":sexString};
    __weak __typeof__(self) weakSelf = self;

    [self.httpManager getCommodityKindWithParameterDict:dict CompletionBlock:^(NSMutableArray<KindModel *> *listArray, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            if (listArray && listArray.count)
            {
                [weakSelf reloadSegmentedViewDataWithArray:listArray];
                
                KindModel *kind = [listArray firstObject];
                NSString *cateID = kind.catId;
                [weakSelf requestNetworkGetThreeLevelDataWith:cateID];
            }
        }

    }];
    
}

/*
 * 根据二级列表 拿到三级分类列表
 *
 * cateIDString
 */
- (void)requestNetworkGetThreeLevelDataWith:(NSString *)cateIDString
{
    NSDictionary *dict = @{@"cur_page":@"1",@"cur_size":@"20",@"parent_id":cateIDString};
    __weak __typeof__(self) weakSelf = self;
    [self.httpManager getCommodityKindWithParameterDict:dict CompletionBlock:^(NSMutableArray<KindModel *> *listArray, NSError *error)
     {
         if (error)
         {
             
         }
         else
         {
             
             weakSelf.dataArray = listArray;
             [weakSelf.kindCollectionView reloadData];
         }
     }];
}

@end
