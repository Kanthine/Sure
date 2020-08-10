//
//  CouponViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/11/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"CouponCell"

#import "CouponViewController.h"

#import "CouponCell.h"
#import <MJRefresh.h>

@interface CouponViewController ()

<UITableViewDataSource,UITableViewDelegate>


{
    UIButton *_rightNavBarButton;
    
    UIView *_tableHeaderView;
    
    NSInteger _currentPage;
    
    
    NSMutableArray *_usedArray;
    NSMutableArray *_outArray;
    NSMutableArray *_currentArray;
}

@property (nonatomic ,strong) NSMutableArray *listArray;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *emptyDataTipView;

@end

@implementation CouponViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];

    [self.view addSubview:self.tableView];
    
    [self customTableHeaderView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"优惠券";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
    [_rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];
    [_rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    //    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    
}

- (void)customTableHeaderView
{
    _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [self.view addSubview:_tableHeaderView];
    //_tableView.tableHeaderView = _tableHeaderView;
    
    
    CGFloat buttonWidth = ScreenWidth / 3.0;
    CGFloat buttonHeight = 40;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"未使用" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(couponClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    editButton.tag = 1;
    [editButton setTitleColor:TextColorPurple forState:UIControlStateNormal];
    [_tableHeaderView addSubview:editButton];
    
    UILabel *gray1Lable = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth, 8, 1, buttonHeight - 16)];
    gray1Lable.backgroundColor = GrayColor;
    [_tableHeaderView addSubview:gray1Lable];
    
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allButton setTitle:@"已使用" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(couponClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    allButton.titleLabel.font = [UIFont systemFontOfSize:14];
    allButton.tag = 2;
    allButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    [allButton setTitleColor:TextColor149 forState:UIControlStateNormal];
    [_tableHeaderView addSubview:allButton];
    
    
    UILabel *gray2Lable = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth * 2, 8, 1, buttonHeight - 16)];
    gray2Lable.backgroundColor = GrayColor;
    [_tableHeaderView addSubview:gray2Lable];
    
    UIButton *kindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [kindButton setTitle:@"已失效" forState:UIControlStateNormal];
    [kindButton setTitleColor:TextColor149 forState:UIControlStateNormal];
    kindButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [kindButton addTarget:self action:@selector(couponClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    kindButton.tag = 3;
    kindButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight);
    [_tableHeaderView addSubview:kindButton];
    
    
    
    UILabel *gray0Lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, ScreenWidth, 1)];
    gray0Lable.backgroundColor = GrayColor;
    [_tableHeaderView addSubview:gray0Lable];
    
    UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    grayLable.backgroundColor = GrayColor;
    [_tableHeaderView addSubview:grayLable];
    
    
}

- (void)couponClassButtonClick:(UIButton *)button
{
    UIButton * button1 = [_tableHeaderView viewWithTag:1];
    UIButton * button2 = [_tableHeaderView viewWithTag:2];
    UIButton * button3 = [_tableHeaderView viewWithTag:3];
    [button1 setTitleColor:TextColor149 forState:UIControlStateNormal];
    [button2 setTitleColor:TextColor149 forState:UIControlStateNormal];
    [button3 setTitleColor:TextColor149 forState:UIControlStateNormal];

    
    [button setTitleColor:TextColorPurple forState:UIControlStateNormal];
    
    switch (button.tag)
    {
        case 1://未使用
            _currentArray = _listArray;
            break;
        case 2://已使用
            _currentArray = _usedArray;
            break;
        case 3://已失效
            _currentArray = _outArray;
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
}

- (UIView *)emptyDataTipView
{
    if (_emptyDataTipView == nil)
    {
        _emptyDataTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40)];
        _emptyDataTipView.backgroundColor = [UIColor clearColor];
        _emptyDataTipView.hidden = YES;
        
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData_Coupon"]];
        imageview.frame = CGRectMake((ScreenWidth - 80) / 2.0, 100, 80, 80);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [_emptyDataTipView addSubview:imageview];
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, ScreenWidth - 40, 20)];
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = TextColorBlack;
        lable.text = @"你没有优惠券";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 40 - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = CellHeight;
        
        
        [self setTableViewRefresh];
        [_tableView addSubview:self.emptyDataTipView];
    }
    
    
    return _tableView;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:nil options:nil][0];
    }
    
    
    CouponModel *coupon = _listArray[indexPath.row];

    [cell updateCellInfoWithCouponModel:coupon];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Request Network


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
    AccountInfo *user = [AccountInfo standardAccountInfo];
    NSString *userID = user.userId;
    NSDictionary *parameterDict = @{@"user_id":userID,@"cur_page":@"1",@"cur_size":@"20"};

    [self.httpManager getCouponListWithParameterDict:parameterDict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
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
