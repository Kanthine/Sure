//
//  RefundListVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/10.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellIdentifer @"RefundListCell"
#define HeaderIdentifer @"OrderListTableSectionHeaderView"
#define FooterIdentifer @"OrderListTableSectionFooterView"


#import "RefundListVC.h"


#import "OrderListTableSectionHeaderView.h"
#import "OrderListTableSectionFooterView.h"
#import "OrderListCell.h"
#import "MessageCenterVC.h"


@interface RefundListVC ()

<UITableViewDataSource,UITableViewDelegate>


{
    
}


@property (nonatomic ,strong) UIView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;


@end

@implementation RefundListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customNavBar];
    [self.view addSubview:self.tableHeaderView];
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
    
    self.navigationItem.title = @"退款/售后";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    UIButton *rightNavBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
    [rightNavBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];
    [rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    MessageCenterVC *messageVC = [[MessageCenterVC alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        //_tableView.tableHeaderView = _tableHeaderView;
        
        
        CGFloat buttonWidth = ScreenWidth / 3.0;
        CGFloat buttonHeight = 40;
        
        NSArray *titleArray = @[@"全部",@"待处理",@"结束"];
        
        for (int i = 0; i < titleArray.count ; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(switchOrderListState:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, buttonHeight);
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 1 + i;
            [button setTitleColor:TextColor149 forState:UIControlStateNormal];
            
            if (_refundType == i)
            {
                [button setTitleColor:TextColorPurple forState:UIControlStateNormal];
            }
            
            [_tableHeaderView addSubview:button];
        }
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        grayLable.backgroundColor = GrayColor;
        [_tableHeaderView addSubview:grayLable];
        
    }
    
    return _tableHeaderView;
}

- (void)switchOrderListState:(UIButton *)button
{
    for (UIView *view in _tableHeaderView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *but = (UIButton *)view;
            [but setTitleColor:TextColor149 forState:UIControlStateNormal];
            
        }
    }
    
    [button setTitleColor:TextColorPurple forState:UIControlStateNormal];
    
    
    
    _refundType = button.tag - 1;
    [_tableView reloadData];
}



- (void)customTableView
{
    
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

    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    
    headerView.brandNameLable.text= @"ScreenWidth";
    headerView.orderStateLable.text = @"退款被拒";
    headerView.brandLogoImageView.image = [UIImage imageNamed:@"tou.jpg"];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderListTableSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:FooterIdentifer];
    
    footerView.refundState = _refundType - 1;
    
    if (_refundType == RefundStateAll)
    {
        footerView.refundState = 0;
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
    
    [cell updateCellInfoWithProductModel:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
