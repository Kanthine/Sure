//
//  CollectProductVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"CollectProductCustomCell"
#define HeaderIdentifer @"CollectProductSectionHeaderView"


#import "CollectProductVC.h"

#import "CollectProductCell.h"
#import "CollectProductSectionHeaderView.h"
#import "MessageCenterVC.h"
#import "CollectModelDAO.h"

#import <MJRefresh.h>

@interface CollectProductVC ()
<UITableViewDataSource,UITableViewDelegate>

{
    UIButton *_rightNavBarButton;
    UIButton *_searchNavBarButton;
    
    NSInteger _currentPage;
    
}

@property (nonatomic ,strong) NSMutableArray *listArray;
@property (nonatomic ,strong) UIView *menuView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *emptyDataTipView;

@end

@implementation CollectProductVC

- (NSMutableArray *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _currentPage = 1;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];// Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self customNavBar_Normal];
    
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];// Dispose of any resources that can be recreated.
}

- (void)customNavBar_Normal
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"收藏单品";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    //navBar_Search _searchNavBarButton
    _searchNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_searchNavBarButton setImage:[UIImage imageNamed:@"navBar_Search"] forState:UIControlStateNormal];
    [_searchNavBarButton setImage:[UIImage imageNamed:@"navBar_Search"] forState:UIControlStateHighlighted];
    [_searchNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchRightItem=[[UIBarButtonItem alloc]initWithCustomView:_searchNavBarButton];
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];
    [_rightNavBarButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItems = @[rightItem,searchRightItem];
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{

}

- (void)messageButtonClick
{
    MessageCenterVC *messageVC = [[MessageCenterVC alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (UIView *)menuView
{
    if (_menuView == nil)
    {
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        
        
        CGFloat width = (ScreenWidth - 70) / 2.0;
        width = ScreenWidth / 2.0;
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allButton setTitle:@"全部宝贝" forState:UIControlStateNormal];
        allButton.titleLabel.font = [UIFont systemFontOfSize:14];
        allButton.frame = CGRectMake(0, 0, width, 40);
        [allButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
        [_menuView addSubview:allButton];
        
        
        UIButton *kindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [kindButton setTitle:@"宝贝分类" forState:UIControlStateNormal];
        kindButton.titleLabel.font = [UIFont systemFontOfSize:14];
        kindButton.frame = CGRectMake(width, 0, width, 40);
        [kindButton setTitleColor:TextColorBlack forState:UIControlStateNormal];
        [_menuView addSubview:kindButton];
        
        UILabel *gray0Lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth, 1)];
        gray0Lable.backgroundColor = GrayColor;
        [_menuView addSubview:gray0Lable];
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
        grayLable.backgroundColor = GrayColor;
        [_menuView addSubview:grayLable];
    }
    
    return _menuView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 40 - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CollectProductCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        [_tableView registerClass:[CollectProductSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 100;
        [self setTableViewRefresh];
        [_tableView addSubview:self.emptyDataTipView];
    }
    
    return _tableView;
}

- (UIView *)emptyDataTipView
{
    if (_emptyDataTipView == nil)
    {
        _emptyDataTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40)];
        _emptyDataTipView.backgroundColor = [UIColor clearColor];
        _emptyDataTipView.hidden = YES;
        
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData_SingleCommodity"]];
        imageview.frame = CGRectMake((ScreenWidth - 80) / 2.0, 100, 80, 80);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [_emptyDataTipView addSubview:imageview];
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, ScreenWidth - 40, 20)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = TextColorBlack;
        lable.text = @"你没有收藏商品";
        lable.font = [UIFont systemFontOfSize:15];
        lable.textAlignment = NSTextAlignmentCenter;
        [_emptyDataTipView addSubview:lable];
        
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 230, ScreenWidth - 40, 20)];
        lable1.backgroundColor = [UIColor clearColor];
        lable1.textColor = TextColor149;
        lable1.text = @"可以去随便逛逛";
        lable1.font = [UIFont systemFontOfSize:13];
        lable1.textAlignment = NSTextAlignmentCenter;
        [_emptyDataTipView addSubview:lable1];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(emptyDataButtonClick) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake((ScreenWidth - 150) / 2.0, 200, 150, 80);
        [_emptyDataTipView addSubview:button];
    }
    
    return _emptyDataTipView;
}

- (void)emptyDataButtonClick
{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    //    NSLog(@"viewControllers -======= %@",mainTabbar.viewControllers);
    
    [self.navigationController.tabBarController setSelectedIndex:0];
}



- (void)editButtonClick
{

    if (_tableView.editing == YES)
    {
        _tableView.editing = NO;
        [self customNavBar_Normal];
        [UIView animateWithDuration:.1f animations:^
        {
            _tableView.frame = CGRectMake(0, 40, ScreenWidth, ScreenHeight - 40 - 64);
            
        } completion:^(BOOL finished)
        {
            
        }];
        
    }
    else
    {
        _tableView.editing = YES;
//        [self customNavBar_Editing];
        [UIView animateWithDuration:.1f animations:^
         {
             _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
             
         } completion:^(BOOL finished)
         {
             
         }];
        
    }
    
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_listArray && _listArray.count)
    {
        NSArray *array = _listArray[section];
        
        return array.count;
    }
    
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CollectProductSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    
    if (section == 0)
    {
        headerView.timeLable.text = @"最近";
    }
    else
    {
        headerView.timeLable.text = [NSString stringWithFormat:@"%ld个月前",(long)section];
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.currentVC = self;
    
    
    if (_listArray && _listArray.count)
    {
        NSArray *array = _listArray[indexPath.section];
        [cell updateCellInfoWithProductModel:array[indexPath.row]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

//返回编辑状态的style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//完成编辑的触发事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //数组删除
        //数据库删除 本地删除
        //单元格删除
        [CollectProductModelDAO deleteLocalityJsonDataWithModel:_listArray[indexPath.section][indexPath.row]];
        [self cancelCollectWithProduct:_listArray[indexPath.section][indexPath.row]];
        [_listArray[indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [tableView reloadData];
    }
}

#pragma mark - requestNetworkGetData

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
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSString *currentPageString = [NSString stringWithFormat:@"%ld",_currentPage];
    
    NSDictionary *dict = @{@"cur_page":currentPageString,@"cur_size":@"10",@"user_id":account.userId,@"parent_id":@"",@"follow_type":@"3"};
    
    [self.httpManager attentionListWithParameterDict:dict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
     {
         if (error)
         {
             [self stopRefreshWithMoreData:NO];
         }
         else
         {
             if (_currentPage == 1)
             {
                 [self.listArray removeAllObjects];
                 [_listArray  addObjectsFromArray:listArray];
                 [self stopRefreshWithMoreData:YES];
             }
             else
             {
                 if (listArray && listArray.count)
                 {
                     [_listArray addObjectsFromArray:listArray];
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

- (void)cancelCollectWithProduct:(CollectProductModel *)model
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":model.productID,@"follow_type":@"3"};

    [self.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
     {
         if (error)
         {
             NSLog(@"error.domain ===== %@",error.domain);
         }
         else
         {
             NSLog(@"取消关注");
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
    if (_listArray.count < 5)
    {
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    else
    {
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
    
    
    
    if (_listArray  && _listArray.count > 0)
    {
        _emptyDataTipView.hidden = YES;
    }
    else
    {
        _emptyDataTipView.hidden = NO;
    }
    
    NSLog(@"_listArray ====== %lu",(unsigned long)_listArray.count);

    NSLog(@"_emptyDataTipView ====== %d",_emptyDataTipView.hidden);
}

@end
