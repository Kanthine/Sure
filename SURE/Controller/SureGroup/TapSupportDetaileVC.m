//
//  TapSupportDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/24.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellIndetifer @"TapSupportDetaileCell"


#import "TapSupportDetaileVC.h"
#import "TapSupportDetaileCell.h"


#import "SearchResultVC.h"

@interface TapSupportDetaileVC ()

<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>

{
    UISearchController *_searchController;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_tempsArray;
    
    NSMutableArray *_listArray;
    
    UIButton *_rightNavBarButton;
}

@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation TapSupportDetaileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];
    [self.view addSubview:self.tableView];
    
    [self setSearchController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = self.titleString;
    
    //navBar_LeftButton_Back_Pressed
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    [_rightNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightBtnAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 40;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TapSupportDetaileCell class] forCellReuseIdentifier:CellIndetifer];
    }
    return _tableView;
}

#pragma mark - 

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
    resultTVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:resultTVC];
    
    [_searchController.searchBar sizeToFit];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    
    UIView *view = _searchController.searchBar.subviews[0];
    
    for (UIView *subView in view.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            subView.backgroundColor = [UIColor whiteColor];
            [subView removeFromSuperview];
        }
        else if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
        {
            subView.backgroundColor = RGBA(141, 44, 200,1);
            subView.alpha = .3f;
        }
    }
    

    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = YES;
    //搜索时，背景变模糊
    //_searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    _searchController.searchBar.frame = CGRectMake(0, 0, ScreenWidth, 45);
    _searchController.searchBar.delegate = self;
    _tableView.tableHeaderView = _searchController.searchBar;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    SearchResultVC *resultVC = (SearchResultVC *)_searchController.searchResultsController;
    
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



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TapSupportDetaileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifer forIndexPath:indexPath];
    
    cell.optionButton.tag = indexPath.row + 10;
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    TapUserModel *userModel = _listArray[indexPath.row];
    if ([userModel.isOptioned isEqualToString:@"1"])
    {
        cell.optionButton.selected = YES;
    }
    else
    {
        cell.optionButton.selected = NO;
    }
    
    
    cell.userNameLable.text = userModel.userName;
    [cell.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:userModel.userHeader] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)optionButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    

    
    
    
}


#pragma mark - 

- (void)requestNetworkGetData
{
    NSDictionary *paraDict = @{@"user_id":_userID,@"parent_id":_attentionedID,@"follow_type":_type};
    __weak __typeof__(self) weakSelf = self;

    [self.httpManager attentionListWithParameterDict:paraDict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
    {
        
        NSLog(@"listArray ==========  %@",listArray);
        
        if (error)
        {
            weakSelf.navigationItem.title = weakSelf.titleString;
        }
        else
        {
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",weakSelf.titleString,listArray.count];
            _listArray = listArray;
            [_tableView reloadData];
        }
        
    }];
}


@end
