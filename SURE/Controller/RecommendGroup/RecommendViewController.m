//
//  RecommendViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentiferTop @"RecommendCellTopBanner"
#define CellIdentiferOne @"RecommendCellOne"
#define CellIdentiferTwo @"RecommendCellTwo"
#define CellIdentiferThree @"RecommendCellThree"
#define CellIdentiferFour @"RecommendCellFour"
#define CellIdentiferFive @"RecommendCellFive"
#define CellIdentiferSix @"RecommendCellSix"
#define HeaderIdentifer @"RecommendTableSectionHeaderView"


#import "RecommendViewController.h"

#import "RecommendCellTopBanner.h"
#import "RecommendTableSectionHeaderView.h"

#import "UIImage+Extend.h"

#import "SignView.h"


#import <MJRefresh.h>

@interface RecommendViewController ()
<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

{
    NSInteger _currentPage;
}


@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *topBannerArray;


@end

@implementation RecommendViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.navBarView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;

//    [self requestNetworkGetData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;

        
        
        [_tableView registerClass:[RecommendCellTopBanner class] forCellReuseIdentifier:CellIdentiferTop];
        [_tableView registerClass:[RecommendCellOne class] forCellReuseIdentifier:CellIdentiferOne];
        [_tableView registerClass:[RecommendCellTwo class] forCellReuseIdentifier:CellIdentiferTwo];
        [_tableView registerNib:[UINib nibWithNibName:CellIdentiferThree bundle:nil] forCellReuseIdentifier:CellIdentiferThree];
        [_tableView registerClass:[RecommendCellFour class] forCellReuseIdentifier:CellIdentiferFour];
        [_tableView registerClass:[RecommendCellFive class] forCellReuseIdentifier:CellIdentiferFive];
        [_tableView registerNib:[UINib nibWithNibName:CellIdentiferSix bundle:nil] forCellReuseIdentifier:CellIdentiferSix];
        
        [_tableView registerClass:[RecommendTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        
        [self setRecommendTableViewRefresh];
    }
    return _tableView;
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.backgroundColor = [UIColor clearColor];
        _navBarView.clipsToBounds = YES;
        
        UIImageView *navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        navBarImageView.tag = 1;
        navBarImageView.frame = _navBarView.bounds;
        navBarImageView.alpha = 0;
        [_navBarView addSubview:navBarImageView];
        
        UIButton *rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        rightNavBarButton.tag = 2;
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateNormal];
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateHighlighted];
        [rightNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:rightNavBarButton];
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.delegate = self;

    return _navBarView;
}

-(void)rightBtnAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat alpha = yOffset / RecommendTopBanaerViewHeight;
    
    UIImageView *navBarImageView = [self.navBarView viewWithTag:1];
    UIButton *rightNavBarButton = [self.navBarView viewWithTag:2];
    
    navBarImageView.alpha = alpha;
    
    if (alpha < 0.5f)
    {
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateNormal];
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    }
}


#pragma mark -  UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return self.dataArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return RecommendTopBanaerViewHeight;
    }
    
    
    
    NSDictionary *dict = self.dataArray[indexPath.section - 1];
    
    NSString *cellCategory = dict[@"position_name"];
    
    
    if ([cellCategory containsString:RecommendCellOneCategory])
    {
        return RecommendCellOneHeight;
        
    }
    else if ([cellCategory containsString:RecommendCellTwoCategory])
    {
        return RecommendCellTwoHeight;

    }
    else if ([cellCategory containsString:RecommendCellThreeCategory])
    {
        return RecommendCellThreeHeight;
        
    }
    else if ([cellCategory containsString:RecommendCellFourCategory])
    {
        return RecommendCellFourHeight;
        
    }
    else if ([cellCategory containsString:RecommendCellFiveCategory])
    {
        return RecommendCellFiveHeight;
        
    }
    else if ([cellCategory containsString:RecommendCellSixCategory])
    {
        return RecommendCellSexHeight;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }

    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    
    return RecommendTableSectionHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RecommendTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    if (section == 0)
    {
        return nil;
    }

    
    NSDictionary *dict = self.dataArray[section - 1];
    
    headerView.currentViewControler = self;
    [headerView updateRecommendTableSectionHeaderViewWithDict:dict];

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        RecommendCellTopBanner *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferTop];
        [cell reloadTopBannerViewWithArray:self.topBannerArray];
        return cell;
    }
    
    
    
    
    
    
    
    NSDictionary *dict = self.dataArray[indexPath.section - 1];
    NSString *cellCategory = dict[@"position_name"];
    
    
    if ([cellCategory containsString:RecommendCellOneCategory])
    {
        RecommendCellOne *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferOne];
        cell.currentViewControler = self;

        [cell updateRecommendCellOneWithDict:dict];
        
        return cell;
    }
    else if ([cellCategory containsString:RecommendCellTwoCategory])
    {
        RecommendCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferTwo];
        cell.currentViewControler = self;

        [cell updateRecommendCellTwoWithDict:dict];
        
        return cell;

    }
    else if ([cellCategory containsString:RecommendCellThreeCategory])
    {
        RecommendCellThree *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferThree];
        cell.currentViewControler = self;

        [cell updateRecommendCellThreeWithDict:dict];
        
        return cell;
    }
    else if ([cellCategory containsString:RecommendCellFourCategory])
    {
        RecommendCellFour *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferFour];
        [cell updateRecommendCellFourWithDict:dict];
        
        return cell;

    }
    else if ([cellCategory containsString:RecommendCellFiveCategory])
    {
        RecommendCellFive *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferFive];
        cell.currentViewControler = self;
        [cell updateRecommendCellFiveWithDict:dict];
        
        return cell;
    }
    else if ([cellCategory containsString:RecommendCellSixCategory])
    {
        RecommendCellSix *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferSix];
        cell.currentViewControler = self;
        [cell updateRecommendCellSixWithDict:dict];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    return cell;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - RequestNetworkGetData

- (void)setRecommendTableViewRefresh
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
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_currentPage];
    
    NSDictionary *dict = @{@"cur_page":pageStr,@"cur_size":@"6"};
    __weak __typeof__(self) weakSelf = self;
    
    [self.httpManager getRecommendWithParameterDict:dict CompletionBlock:^(NSMutableArray<NSDictionary *> *topBannerArray, NSMutableArray<NSDictionary *> *listArray, NSError *error)
    {

        if (error)
        {
            // 停止刷新
            [weakSelf stopRefreshWithMoreData:YES];
        }
        else
        {
            if (_currentPage == 1)
            {
                weakSelf.dataArray = listArray;
            }
            else
            {
                [weakSelf.dataArray addObjectsFromArray:listArray];
            }
            
            weakSelf.topBannerArray = topBannerArray;
            
            [weakSelf.tableView reloadData];
            
            // 停止刷新
            if (listArray && listArray.count)
            {
                [weakSelf stopRefreshWithMoreData:YES];

            }
            else
            {
                [weakSelf stopRefreshWithMoreData:NO];
            }
            

            
        }
    }];
    
    
}

- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    
    
    
    NSLog(@"_tableView.mj_header ====%@",self.tableView.mj_header);
    NSLog(@"_tableView.mj_footer ====%@",self.tableView.mj_footer);

    
    NSLog(@"_tableView.mj_header ====%d",[self.tableView.mj_header isRefreshing]);

        
    if (self.tableView.mj_header)
    {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer)
    {
        if (isMoreData)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    
    }


//    if ([_tableView.mj_header isRefreshing])
//    {
//        [_tableView.mj_header endRefreshing];
//    }
//
//    if ([_tableView.mj_footer isRefreshing])
//    {
//    }
//    
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (_dataArray.count < 5)
    {
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    }
    else
    {
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
    
    
    
    if (_dataArray  && _dataArray.count > 0)
    {
//        _emptyDataTipView.hidden = YES;
    }
    else
    {
//        _emptyDataTipView.hidden = NO;
    }
    
}


@end
