//
//  CollectBrandVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"CollectBrandTableCell"


#import "CollectBrandVC.h"

#import "TapSupportDetaileCell.h"
#import "CollectBrandTableCell.h"

#import <MJRefresh.h>

@interface CollectBrandVC ()
<UITableViewDataSource,UITableViewDelegate>


{
    UIButton *_rightNavBarButton;
    
    
    NSInteger _currentPage;
    
}

@property (nonatomic ,strong) NSMutableArray<CollectBrandModel *> *listArray;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *emptyDataTipView;


@end

@implementation CollectBrandVC

- (NSMutableArray *)listArray
{
    if (_listArray == nil)
    {
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self customNavBar];
    
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"收藏品牌";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    [_rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
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



- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.rowHeight = 50;
        
        [_tableView registerClass:[CollectBrandTableCell class] forCellReuseIdentifier:CellIdentifer];
        
        [self setTableViewRefresh];
        [_tableView addSubview:self.emptyDataTipView];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectBrandTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    CollectBrandModel *brandModel = self.listArray[indexPath.row];
    
    [cell.brandLogoImageView sd_setImageWithURL:[NSURL URLWithString:brandModel.imageStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    NSLog(@"%@",brandModel.imageStr);
    
    cell.brandNameLable.text = brandModel.brandName;
    cell.optionButton.selected = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

    NSDictionary *dict = @{@"cur_page":currentPageString,@"cur_size":@"10",@"user_id":account.userId,@"parent_id":@"",@"follow_type":@"2"};
    
    
    
    [self.httpManager attentionListWithParameterDict:dict CompletionBlock:^(NSMutableArray<CollectBrandModel *> *listArray, NSError *error)
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
    
    NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":model.productID,@"follow_type":@"2"};
    
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
}



@end
