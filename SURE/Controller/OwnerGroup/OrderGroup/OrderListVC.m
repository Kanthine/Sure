//
//  OrderListVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"OrderListCell"
#define HeaderIdentifer @"OrderListTableSectionHeaderView"
#define FooterIdentifer @"OrderListTableSectionFooterView"


#import "OrderListVC.h"

#import "OrderListTableSectionHeaderView.h"
#import "OrderListTableSectionFooterView.h"
#import "OrderListCell.h"

#import "SearchViewController.h"

#import "MJRefresh.h"
#import "DIYRefreshView.h"

#import "OrderDetailsVC.h"

//#import "MainTabBarController.h"

@interface OrderListVC ()
<UITableViewDataSource,UITableViewDelegate>


{
    UIButton *_rightNavBarButton;
    NSMutableArray *_listArray;
    NSInteger _currentPage;
}

@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *emptyDataTipView;

@end

@implementation OrderListVC

- (void)dealloc
{
    NSLog(@"ShopCarVC   dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _currentPage = 1;
    
    [self customNavBar];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    
    [self setTableViewRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"我的订单";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Search"] forState:UIControlStateNormal];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Search"] forState:UIControlStateHighlighted];
    [_rightNavBarButton addTarget:self action:@selector(navBar_SearchButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navBar_SearchButtonEditClick:(UIButton *)button
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:NO];
}

- (UIView *)headerView
{
    if (_headerView == nil)
    {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [self.view addSubview:_headerView];
        
        
        CGFloat buttonWidth = ScreenWidth / 5.0;
        CGFloat buttonHeight = 40;
        
        NSArray *titleArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"待SURE"];
        
        for (int i = 0; i < titleArray.count ; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(switchOrderListState:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 1 + i;
            [button setTitleColor:TextColor149 forState:UIControlStateNormal];
            
            if (_orderType == i)
            {
                [button setTitleColor:TextColorPurple forState:UIControlStateNormal];
            }
            
            [_headerView addSubview:button];
        }
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        grayLable.backgroundColor = GrayColor;
        [_headerView addSubview:grayLable];
        

    }
    
    
    
    return _headerView;
}

- (void)switchOrderListState:(UIButton *)button
{
    for (UIView *view in _headerView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *but = (UIButton *)view;
            [but setTitleColor:TextColor149 forState:UIControlStateNormal];
        }
    }
    
    [button setTitleColor:TextColorPurple forState:UIControlStateNormal];

    
    _orderType = button.tag - 1;
//    [_tableView reloadData];
    [self pullDownRefreshData];
}


- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 64 - 40) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = OrderListCellHeight;
        
        [_tableView registerClass:[OrderListTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        [_tableView registerClass:[OrderListTableSectionFooterView class] forHeaderFooterViewReuseIdentifier:FooterIdentifer];

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
        
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData_Order"]];
        imageview.frame = CGRectMake((ScreenWidth - 80) / 2.0, 100, 80, 80);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [_emptyDataTipView addSubview:imageview];
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, ScreenWidth - 40, 20)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = TextColorBlack;
        lable.text = @"你没有相关订单";
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

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderModel *listModel = _listArray[section];

    return listModel.goodsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return OrderListHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return OrderListFooterViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderListTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    OrderModel *listModel = _listArray[section];
    [headerView updateHeaderInfoWithProductModel:listModel];

    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderListTableSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterIdentifer];
    footerView.orderState = _orderType - 1;
    
    OrderModel *listModel = _listArray[section];
    
    
    if ([listModel.shippingFee floatValue] <= 0)
    {
        footerView.describeLable.text = [NSString stringWithFormat:@"共%d件商品 合计￥%.2f(不含运费)",[listModel.goodsListNumber intValue], [listModel.totalFee floatValue]];
    }
    else
    {
        footerView.describeLable.text = [NSString stringWithFormat:@"共%d件商品 合计￥%.2f(含运费￥%.2f)",[listModel.goodsListNumber intValue],[listModel.totalFee floatValue],[listModel.shippingFee floatValue]];
    }
    
    

    footerView.orderIDStr = listModel.orderId;
    footerView.currentViewController = self;
    
    if (_orderType == OrderStateAll)
    {
        footerView.orderState = 0;
    }
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil)
    {
        cell = [[OrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    OrderModel *listModel = _listArray[indexPath.section];
    OrderProductModel *productModel = listModel.goodsList[indexPath.row];
    
    [cell updateCellInfoWithProductModel:productModel];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailsVC *detaileVC = [[OrderDetailsVC alloc]init];
    OrderModel *listModel = _listArray[indexPath.section];
    
    detaileVC.orderModel = listModel;
    detaileVC.orderType = _orderType;
    [self.navigationController pushViewController:detaileVC animated:YES];
    
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

//    _tableView.mj_footer.hidden = YES;
//    _tableView.mj_footer = [DIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpLoadData)];
//    _tableView.mj_footer.automaticallyChangeAlpha = YES;

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
    
    if (_currentPage == 0)
    {
        _currentPage = 1;
    }
    
    
    NSString *all_status = nil;
    switch (_orderType)
    {
        case OrderStateAll:
        {
            all_status = @"0";
        }
            break;
        case OrderStateWaitPay:
        {
            all_status = @"WAIT_PAY";
        }
            break;
        case OrderStateWaitSendGoods:
        {
            all_status = @"WAIT_SHIP";
        }
            break;
        case OrderStateReceiveGoods:
        {
            all_status = @"WAIT_GET";
        }
            break;
        case OrderStateWaitSure:
        {
            all_status = @"WAIT_SURE";
        }
            break;
        default:
            break;
    }
    
    
    
    
    NSString *currentPageString = [NSString stringWithFormat:@"%ld",_currentPage];
    
    /*
     all_status :
     全部 0，待付款 WAIT_PAY，待发货 WAIT_SHIP，待收货 WAIT_GET，待SURE WAIT_SURE 
     */
    NSDictionary *parameterDict = @{@"user_id":account.userId,@"cur_page":currentPageString,@"cur_size":@"10",@"all_status":all_status,@"u_token":account.uToken};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSLog(@"parameterDict ===== %@",parameterDict);
    
    [self.httpManager getOrderListParameterDict:parameterDict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
    {
        [hud hideAnimated:YES];
        
        if (error == nil)
        {
            if (_currentPage == 1)
            {
                _listArray = listArray;
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
        else
        {
             [self stopRefreshWithMoreData:YES];
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
    
}


@end
