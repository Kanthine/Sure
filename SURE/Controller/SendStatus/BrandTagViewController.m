//
//  BrandTagViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/20.
//  Copyright © 2016年 longlong. All rights reserved.
//


#import "BrandTagViewController.h"


#import "BrandTagTableSectionHeaderView.h"
#import "BrandTagTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "BrandTagKindView.h"

#import "MJRefresh.h"
#import "DIYRefreshView.h"
#import "KindListVC.h"


typedef NS_ENUM(NSUInteger ,UserType)
{
    UserTypeNormal = 0,
    UserTypeSigner,
};



@interface BrandTagViewController ()

<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

{
    NSInteger _currentPage;
}


@property (nonatomic ,assign) UserType userType;

@property (nonatomic ,strong) NSMutableArray<KindModel *> *kindListArray;
@property (nonatomic ,strong) NSMutableArray *brandListArray;
@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation BrandTagViewController

- (instancetype)init
{
     self = [super init];
    
    if (self)
    {
        
        // 判定账户类型：普通用户、签约用户
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.isFenxiao isEqualToString:@"1"])
        {
            _userType = UserTypeSigner;

        }
        else
        {
            _userType = UserTypeNormal;
        }
        
        
        
        if (_userType == UserTypeSigner)
        {
            [self requestKindData];
        }

        [self pullDownRefreshData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.backImageView];
    
    [self.view addSubview:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 60, 44);
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:cancelButton];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_ExitPurple"]];
        imageView.frame = CGRectMake(10, 14, 16, 16);
        [_navBarView addSubview:imageView];
        
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 120)/2.0, 0, 120, 44)];
        titleLable.textColor = [UIColor blackColor];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = @"选择标签链接";
        [_navBarView addSubview:titleLable];
        
        
        UIButton *searchButton =[UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(ScreenWidth - 50, 0, 50, 44);
        
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(12, 20, 12 ,10);
        [searchButton setImage:[UIImage imageNamed:@"navBar_Search_Purple"] forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"navBar_Search_Purple"] forState:UIControlStateHighlighted];
        [searchButton addTarget:self action:@selector(searchButtonEditClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:searchButton];
    }
    return _navBarView;
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchButtonEditClick
{
    if (_userType == UserTypeNormal)
    {
        _userType = UserTypeSigner;
    }
    else
    {
        _userType = UserTypeNormal;
    }
    
    [_tableView reloadData];
}

- (UIImageView *)backImageView
{
    if (_backImageView == nil)
    {
        _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenWidth)];
    }
    
    return _backImageView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil)
    {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _searchBar.placeholder = @"搜索品牌";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.95f];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (_userType == UserTypeNormal)
        {
            _tableView.rowHeight = BrandTagTableViewNormalCellHeight;
            [_tableView registerClass:[BrandTagTableViewCell class] forCellReuseIdentifier:BrandTagNormalCell];
            [_tableView registerClass:[BrandTagTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:BrandTagTableSectionNormalHeaderView];

        }
        else if (_userType == UserTypeSigner)
        {
            _tableView.rowHeight = BrandTagTableViewSignerCellHeight;
            [_tableView registerClass:[BrandTagTableViewCell class] forCellReuseIdentifier:BrandTagSignerCell];
            [_tableView registerClass:[BrandTagTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:BrandTagTableSectionsignedHeaderView];

        }
        
        _tableView.sectionFooterHeight = 1;

        
        _tableView.tableHeaderView = self.searchBar;
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_userType == UserTypeNormal)
    {
        return self.brandListArray.count;

    }
    else
    {
        return self.brandListArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_userType == UserTypeNormal)
    {
        OrderModel *listModel = _brandListArray[section];
        return listModel.goodsList.count;
    }
    else
    {
        NSDictionary *dict = self.brandListArray[section];

        NSArray *array = dict[@"brandList"];
        
        return array.count;
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_userType == UserTypeNormal)
    {
         return 30;
    }
    else
    {
         return 20;
    }   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_userType == UserTypeNormal)
    {
        BrandTagTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BrandTagTableSectionNormalHeaderView];
        
        OrderModel *listModel = _brandListArray[section];
        [headerView updateHeaderInfoWithProductModel:listModel];
        
        return headerView;

    }
    else
    {
        BrandTagTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BrandTagTableSectionsignedHeaderView];
        
        NSDictionary *dict = self.brandListArray[section];
        
        headerView.brandKindLable.text = dict[@"Initials"];
        return headerView;

    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userType == UserTypeNormal)
    {
        BrandTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandTagNormalCell forIndexPath:indexPath];
        
        OrderModel *listModel = _brandListArray[indexPath.section];
        OrderProductModel *productModel = listModel.goodsList[indexPath.row];
        
        [cell updateCellInfoWithProductModel:productModel];
        
        return cell;

    }
    else
    {
        BrandTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandTagSignerCell forIndexPath:indexPath];
        
        
        NSDictionary *dict = self.brandListArray[indexPath.section];

        NSMutableArray *miArray = dict[@"brandList"];
        
        BrandDetaileModel *brandModel = miArray[indexPath.row];
        
        cell.brandLable.text = brandModel.brandNameStr;
        
        return cell;
    }    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    __weak __typeof__(self) weakSelf = self;

    if (_userType == UserTypeNormal)
    {
        //正常用户
        
        OrderModel *listModel = _brandListArray[indexPath.section];
        OrderProductModel *productModel = listModel.goodsList[indexPath.row];
        
        
        [self dismissViewControllerAnimated:YES completion:^
         {
             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectedBrandTagWithSign:BrandID:GoodsID:LocationPoint:)])
             {
                 [weakSelf.delegate selectedBrandTagWithSign:listModel.brandNameString BrandID:listModel.brandIDString GoodsID:productModel.goodsId LocationPoint:weakSelf.tapPoint];
             }
         }];
    }
    else
    {
        //签约用户
        BrandTagKindView *kindView = [[BrandTagKindView alloc]initWithKindList:self.kindListArray];
        [kindView showToSuperView:self.view];
        kindView.didSelectBrandKind = ^(KindModel *kindMod)
        {
            [weakSelf brandTagKindViewDidSelectBrandKind:kindMod];
        };
        
    }    

}

- (void)brandTagKindViewDidSelectBrandKind:(KindModel *)kind
{
    __weak __typeof__(self) weakSelf = self;

    KindListVC *listVC = [[KindListVC alloc]initWithModel:kind];
    listVC.isBrandTagChoose = YES;
    listVC.didSelectKindListCommodity = ^(NSString *brandString,NSString *brandIDStr,NSString *goodIDString)
    {
        
        if (brandString == nil)
        {
            brandString = @"";
        }
        if (brandIDStr == nil)
        {
            brandIDStr = @"";
        }
        if (goodIDString == nil)
        {
            goodIDString = @"";
        }
        
        NSLog(@"brandString === %@",brandString);
        NSLog(@"brandIDStr === %@",brandIDStr);
        NSLog(@"goodIDString === %@",goodIDString);

        
        [weakSelf dismissViewControllerAnimated:YES completion:^
         {
             if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectedBrandTagWithSign:BrandID:GoodsID:LocationPoint:)])
             {
                 [weakSelf.delegate selectedBrandTagWithSign:brandString BrandID:brandIDStr GoodsID:goodIDString LocationPoint:weakSelf.tapPoint];
             }
         }];

    };
    [self.navigationController pushViewController:listVC animated:YES];

}

- (NSMutableArray *)brandListArray
{
    if (_brandListArray == nil)
    {
        _brandListArray = [NSMutableArray array];
    }
    
    return _brandListArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 下拉刷新  上拉加载

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                            {
                                [weakSelf pullDownRefreshData];
                            }];
    
    
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
    
}

- (void)pullDownRefreshData
{
    _currentPage = 1;
    
    if (_tableView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        _tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    
    [self requestNetworkGetData];
}

- (void)pullUpLoadData
{
    _currentPage ++;
    [self requestNetworkGetData];
}

- (void)requestNetworkGetData
{
    if (_userType == UserTypeNormal)
    {
        [self requestOrderData];
    }
    else
    {
        [self requestBrandData];
    }
    
    
}

- (void)requestOrderData
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    if (_currentPage == 0)
    {
        _currentPage = 1;
    }
    
    
    
    NSString *currentPageString = [NSString stringWithFormat:@"%ld",_currentPage];
    
    /*
     all_status :
     全部 0，待付款 WAIT_PAY，待发货 WAIT_SHIP，待收货 WAIT_GET，待SURE WAIT_SURE
     */
    NSDictionary *parameterDict = @{@"user_id":account.userId,@"cur_page":currentPageString,@"cur_size":@"10",@"all_status":@"0"};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [self.httpManager getOrderListParameterDict:parameterDict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             if (_currentPage == 1)
             {
                 _brandListArray = listArray;
                 [self stopRefreshWithMoreData:YES];
             }
             else
             {
                 if (listArray && listArray.count)
                 {
                     [_brandListArray addObjectsFromArray:listArray];
                     [self stopRefreshWithMoreData:YES];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             
             
             [_tableView reloadData];
         }
         else
         {
             [self stopRefreshWithMoreData:YES];
         }
     }];
}

- (void)requestBrandData
{
    NSString *uID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        uID = account.userId;
    }
    
    
    if (_currentPage == 0)
    {
        _currentPage = 1;
    }
    
    
    
    NSString *currentPageString = [NSString stringWithFormat:@"%ld",_currentPage];
    

    
    NSDictionary *parDict = @{@"cur_page":currentPageString,@"cur_size":@"20",@"user_id":uID};
    
    [self.httpManager getBrandListDataWithParametersDict:parDict CompletionBlock:^(NSMutableArray<BrandDetaileModel *> *brandModelArray, NSError *error)
     {
         if (error)
         {
             [self stopRefreshWithMoreData:YES];

             UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"错误提示" message:error.domain preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"了解了" style:UIAlertActionStyleDefault handler:nil];
             [alertView addAction:cancelAction];
             [self presentViewController:alertView animated:YES completion:nil];
         }
         else
         {
             NSMutableArray *array = [BrandListModel bassInitialsSortWithArray:brandModelArray];
             
             
             if (_currentPage == 1)
             {
                 _brandListArray = array;
                 [self stopRefreshWithMoreData:YES];
             }
             else
             {
                 if (array && array.count)
                 {
                     [_brandListArray addObjectsFromArray:array];
                     [self stopRefreshWithMoreData:YES];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             
             
             [_tableView reloadData];

         }
         
     }];
}

- (void)requestKindData
{
    [self.httpManager getAllKindCompletionBlock:^(NSMutableArray<KindModel *> *listArray, NSError *error)
    {
        if (error)
        {
            [self stopRefreshWithMoreData:YES];
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"错误提示" message:error.domain preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"了解了" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else
        {
            NSString *sex = @"1";
            if ([AuthorizationManager isAuthorization])
            {
                AccountInfo *account = [AccountInfo standardAccountInfo];
                sex = account.sex;
            }
            
            if ([sex isEqualToString:@"1"])
            {
                [listArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    
                    
                    NSLog(@"catName ===== %@",obj.catName);
                    
                    if ([obj.catName isEqualToString:@"男士"])
                    {
                        
                        self.kindListArray = obj.nextLevelListArray;
                        * stop = YES;
                    }
                    
                }];
            }
            else
            {
                [listArray enumerateObjectsUsingBlock:^(KindModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
                 {
                     
                     NSLog(@"catName ------ %@",obj.catName);

                     if ([obj.catName isEqualToString:@"女士"])
                     {
                         
                         self.kindListArray = obj.nextLevelListArray;
                         * stop = YES;
                     }
                     
                 }];

            }


            
        }

    }];
    

    

    
}


- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    
    if ([_tableView.mj_header isRefreshing])
    {
        [_tableView.mj_header endRefreshing];
        
    }
    
    if ([_tableView.mj_footer isRefreshing])
    {
        
        if (isMoreData)
        {
            [_tableView.mj_footer endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (_brandListArray.count < 8)
    {
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    else
    {
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
}

@end
