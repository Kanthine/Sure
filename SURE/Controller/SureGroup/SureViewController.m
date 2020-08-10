//
//  SureViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BrandCellIdentifer  @"SureBrandListTableCell"
#define SureCellIdentifer  @"SureMainTableCell"
#define AdvertisementCellIdentifer @"SureAdvertisementTableCell"
#define HeaderIdentifer @"SureTableSectionHeaderView"

#import "SureViewController.h"

#import "SureTableSectionHeaderView.h"
#import "SureMainTableCell.h"
#import "SureBrandListTableCell.h"
#import "SureAdvertisementTableCell.h"

#import "SurePlusButtonView.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "SingleProductDetaileVC.h"

#import "MySureViewController.h"
#import "TapSupportDetaileVC.h"
#import "ShareViewController.h"

// 调取相机相册
#import "AllPhotosViewController.h"
#import "PhotoStreamsViewController.h"
#import "VideoStreamsViewController.h"
#import "PhotoResourceVC.h"

#import "MJRefresh.h"

#import "HandleResultView.h"


@interface SureViewController ()
<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationControllerDelegate>

{
    UIImageView *_navBarImageView;
    UIImageView *_titleImageView;
    
    NSMutableArray<AccountInfo *> *_userListArray;
    NSMutableArray *_brandListArray;
    NSInteger _arcSection;

    
    UIButton *_rightNavBarButton;
    
    NSInteger _currentPage;

}

@property (nonatomic ,strong) SurePlusButtonView *plusButton;
@property (nonatomic ,strong) UIView *navBarView;



@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;

@end

@implementation SureViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.tableView];
    [self setPlusMenuButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefreshData) name:@"RefreshSureListData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenshotNotificationClick:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;

    [self.plusButton sureViewAppear];
    
    // 每次页面显示 刷新数据 有问题
    //[self pullDownRefreshData];
    
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.plusButton sureViewDisAppear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.delegate = self;
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.clipsToBounds = YES;
        _navBarView.tag = 9856;
        
        _navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        _navBarImageView.frame = _navBarView.bounds;
        [_navBarView addSubview:_navBarImageView];
        
        
        _titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_Sure"]];
        _titleImageView.frame = CGRectMake( (ScreenWidth - 73 ) / 2.0, 20 + 12, 73, 20);
        [_navBarView addSubview:_titleImageView];
        
        
        _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
        [_rightNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_rightNavBarButton];
    }
    
    return _navBarView;
}

- (void)setPlusMenuButton
{
    __weak typeof(self) weakSelf = self;
    self.plusButton = [[SurePlusButtonView alloc]initAndAddSuperView:self.view];
    self.plusButton.surePlusMenuButtonClick = ^(NSInteger contentType)
    {
        /* contentType =
         * 0 相机
         * 1 相册,
         * 2 录制视频
         */
        
//        switch (contentType)
//        {
//            case 0:
//            {
//                //相册
//                AllPhotosViewController *libraryVC = [[AllPhotosViewController alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:libraryVC];
//                nav.navigationBarHidden = YES;
//                libraryVC.hidesBottomBarWhenPushed = YES;
//                [weakSelf presentViewController:nav animated:YES completion:nil];
//            }
//            break;
//            case 1:
//            {
//                //相机
//                PhotoStreamsViewController *photoVC = [[PhotoStreamsViewController alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:photoVC];
//                nav.navigationBarHidden = YES;
//                photoVC.hidesBottomBarWhenPushed = YES;
//                [weakSelf presentViewController:nav animated:YES completion:nil];
//            }
//                break;
//            case 2:
//            {
//                //录制视频
//                VideoStreamsViewController *videoVC = [[VideoStreamsViewController alloc]init];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoVC];
//                nav.navigationBarHidden = YES;
//                videoVC.hidesBottomBarWhenPushed = YES;
//                [weakSelf presentViewController:nav animated:YES completion:nil];
//
//            }
//                break;
//
//                
//            default:
//                break;
//        }
        
        if (contentType >= 0)
        {
            PhotoResourceVC *tabbarVC = [[PhotoResourceVC alloc]initWithContentType:contentType];
            tabbarVC.joinType = PhotoResourceJoinTypePush;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabbarVC];
            nav.navigationBarHidden = YES;
            tabbarVC.hidesBottomBarWhenPushed = YES;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
    };

}

- (void)takeScreenshotNotificationClick:(NSNotification *)notification
{
    
//    ShareViewController *shareVC = [[ShareViewController alloc]init];
//    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:shareVC animated:NO completion:^
//     {
//         [shareVC showPlatView];
//     }];
    
    /*
     
     http://www.jianshu.com/p/1213f9f00fdd
     
     UIPasteboard是ios中访问粘贴板的原生控件，可分为系统等级的和app等级的，系统等级的独立于app，可以复制一个app的内容到另一个app；app等级的只能在app内进行复制和粘贴
     
     可以复制在粘贴板的数据类型有NSString、UIImage、NSURL、UIColor、NSData以及由这些类型元素组成的数组。可分别由它们的set方法将数据放在粘贴板中，如NSString：
     [pasteboard setString:@"复制的字符串内容"];
     
     */
    
    //+ (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
    
    NSLog(@"%@",notification.userInfo);
    
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)rightBtnAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

#pragma mark - UITableView Delegate

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 485;
        
        
        [_tableView registerClass:[SureMainTableCell class] forCellReuseIdentifier:SureCellIdentifer];
        [_tableView registerClass:[SureBrandListTableCell class] forCellReuseIdentifier:BrandCellIdentifer];
        [_tableView registerClass:[SureAdvertisementTableCell class] forCellReuseIdentifier:AdvertisementCellIdentifer];
        [_tableView registerClass:[SureTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        
        //滑动时导航栏收缩
        [self followScrollView:_tableView];
        [self setTableViewRefresh];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_userListArray && _userListArray.count && _brandListArray && _brandListArray.count)
    {
        return _sureListArray.count + 2;
    }
    
    
    if ((_userListArray && _userListArray.count) && !(_brandListArray && _brandListArray.count))
    {
        return _sureListArray.count + 1;

    }
    
    if (!(_userListArray && _userListArray.count) && (_brandListArray && _brandListArray.count))
    {
        return _sureListArray.count + 1;
        
    }

    
    return _sureListArray.count;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (_userListArray && _userListArray.count && section == 0)
    {
        return 0;
    }
    
    if (_brandListArray && _brandListArray.count && section == _arcSection)
    {
        return 0;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        return [tableView fd_heightForCellWithIdentifier:BrandCellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
                {
//                    [self congifCell:cell indexpath:indexPath];
                }];
    }
    else if (indexPath.section == _arcSection)
    {
        return [tableView fd_heightForCellWithIdentifier:AdvertisementCellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    //                    [self congifCell:cell indexpath:indexPath];
                }];
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:SureCellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    SureMainTableCell *mainCell = (SureMainTableCell *) cell;
                    SUREModel *model = nil;
                    if (_arcSection < indexPath.section && (indexPath.section - 2 < _sureListArray.count))
                    {
                        model = _sureListArray[indexPath.section - 2];
                    }
                    else if (_arcSection > indexPath.section && (indexPath.section - 1 < _sureListArray.count))
                    {
                        model = _sureListArray[indexPath.section - 1];
                    }
                    
                    [mainCell updateSureMainCellDataWithModel:model];
                }];
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SureTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    SUREModel *model = [self getSureModelWithSection:section];
    [headerView updateSectionHeaderInfoWith:model];
    headerView.section = section;
    headerView.currentViewController = self;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_userListArray && _userListArray.count && indexPath.section == 0)
    {
        SureBrandListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:BrandCellIdentifer forIndexPath:indexPath];
        [cell refreshBrandListScrollViewWithBrandArray:_userListArray];
        cell.currentViewController = self;
        return cell;
    }
    
    if (_brandListArray && _brandListArray.count && indexPath.section == _arcSection)
    {
        SureAdvertisementTableCell *cell = [tableView dequeueReusableCellWithIdentifier:AdvertisementCellIdentifer forIndexPath:indexPath];
        cell.currentViewController = self;
        [cell refreshBrandListScrollViewWithBrandArray:_brandListArray];

        return cell;
    }
    
    
    SureMainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SureCellIdentifer forIndexPath:indexPath];
    

    SUREModel *model = [self getSureModelWithSection:indexPath.section];
    [cell updateSureMainCellDataWithModel:model];
    cell.currentViewController = self;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (SUREModel *)getSureModelWithSection:(NSInteger)section
{
    SUREModel *model = nil;
    
    
    if (_userListArray && _userListArray.count && _brandListArray && _brandListArray.count)
    {
        if (_arcSection < section)
        {
            model = _sureListArray[section - 2];
        }
        else if (_arcSection > section)
        {
            model = _sureListArray[section - 1];
        }
    }
    else if (_userListArray && _userListArray.count && !(_brandListArray && _brandListArray.count))
    {
        model = _sureListArray[section - 1];
    }
    else if ( !(_userListArray && _userListArray.count) && (_brandListArray && _brandListArray.count))
    {
        if (_arcSection < section)
        {
            model = _sureListArray[section - 1];
        }
        else if (_arcSection > section)
        {
            model = _sureListArray[section];
        }
    }
    else if ( !(_userListArray && _userListArray.count) && !(_brandListArray && _brandListArray.count))
    {
        model = _sureListArray[section];
    }
    
    return model;
    
}

#pragma mark - Custom NavBar

- (void)followScrollView:(UITableView *)tableView
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.panGesture setDelegate:self];
    [tableView addGestureRecognizer:self.panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    if (_tableView.contentOffset.y <= 0 && _navBarView.frame.size.height)
    {
        return;
    }
    
    

    CGPoint translation = [gesture translationInView:[_tableView superview]];
    
    float delta = self.lastContentOffset - translation.y;//上滑 大于0 下滑 小于 0
    self.lastContentOffset = translation.y;
    
    NSLog(@"滑动方向 ======= %f",delta);
    
    
    if (delta >= 0)
    {
        //向上滑动时，导航栏收缩
        CGFloat height = _navBarView.frame.size.height;
        //滑动中
        if (height >= 20.0)
        {
            height = height - delta;
            
            height = height >= 20 ? height : 20.0;
            
            CGFloat scale = (height - 20 ) / 44.0;
            CGFloat newWidth = 73 * scale;
            CGFloat newHeight = 20 * scale;
            
            
            
            _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _navBarImageView.frame = _navBarView.bounds;
            
            
            _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
            _titleImageView.alpha = scale;
            
            
            _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
            _rightNavBarButton.alpha = scale;
            
            _tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
        }
        
    }
    else if (delta < 0)
    {
        //向下滑动时，导航栏展开
        CGFloat height = _navBarView.frame.size.height ;

        if (height <= 64.0)
        {
            height = height - delta;
            height = height <= 64.0 ? height : 64.0;
            
            CGFloat scale = (height - 20 ) / 44.0;
            CGFloat newWidth = 73 * scale;
            CGFloat newHeight = 20 * scale;
            
            _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
            _navBarImageView.frame = _navBarView.bounds;
            _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
            _titleImageView.alpha = scale;
            
            
            _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
            _rightNavBarButton.alpha = scale;
            
            _tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
            
        }
    }
    
    
    if ([gesture state] == UIGestureRecognizerStateEnded)
    {
        
        CGFloat height = _navBarView.frame.size.height ;
        
        if (height >= 44 && height < 64.0)
        {
            height = 64.0;
            [UIView animateWithDuration:.2f animations:^
             {
                 CGFloat scale = (height - 20 ) / 44.0;
                 CGFloat newWidth = 73 * scale;
                 CGFloat newHeight = 20 * scale;
                 
                 
                 
                 _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
                 _navBarImageView.frame = _navBarView.bounds;
                 
                 
                 _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
                 _titleImageView.alpha = scale;
                 
                 
                 _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
                 _rightNavBarButton.alpha = scale;
                 
                 _tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
                 
             }];
        }
        else if (height > 20 && height < 44)
        {
            height = 20.0;
            [UIView animateWithDuration:.2f animations:^
             {
                 CGFloat scale = (height - 20 ) / 44.0;
                 CGFloat newWidth = 73 * scale;
                 CGFloat newHeight = 20 * scale;
                 
                 
                 
                 _navBarView.frame = CGRectMake(0, 0, ScreenWidth, height);
                 _navBarImageView.frame = _navBarView.bounds;
                 
                 
                 _titleImageView.frame = CGRectMake((ScreenWidth - newWidth) / 2.0, 20 + (height - 20 - newHeight) / 2.0, newWidth, newHeight);
                 _titleImageView.alpha = scale;
                 
                 
                 _rightNavBarButton.frame = CGRectMake(ScreenWidth - 10 - 40 * scale, 20, 40 * scale, 40 * scale);
                 _rightNavBarButton.alpha = scale;
                 
                 _tableView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight - height);
             }];
        }
        
        
        self.lastContentOffset = 0;
    }
}

#pragma mark - Request NetWork Get Data

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
    if (_currentPage == 0)
    {
        _currentPage = 1;
    }
    NSString *currentPageString = [NSString stringWithFormat:@"%ld",_currentPage];

    
    NSString *userID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        userID = account.userId;
    }
    
    
    NSDictionary *dict = @{@"cur_page":currentPageString,@"cur_size":@"5",@"parent_id":@"",@"user_id":userID,@"good_user":@"1",@"good_supplier":@"1"};
    
    
    [self.httpManager sureMainListWithParameterDict:dict CompletionBlock:^(NSMutableArray<AccountInfo *> *userListArray, NSMutableArray<SUREModel *> *listArray, NSMutableArray<BrandDetaileModel *>  *brandListArray, NSInteger brandIndex, NSError *error)
    {
        
        if (error)
        {
            [self stopRefreshWithMoreData:YES];
        }
        else
        {
            
            if (userListArray && userListArray.count)
            {
                _userListArray = userListArray;
            }
            
            if (brandListArray && brandListArray.count)
            {
                _brandListArray = brandListArray;
                _arcSection = brandIndex;
            }
            
            NSLog(@"_brandListArray ====== %@",_brandListArray);
            
            if (_currentPage == 1)
            {
                _sureListArray = listArray;
                [self stopRefreshWithMoreData:YES];
            }
            else
            {
                if (listArray && listArray.count)
                {
                    [_sureListArray addObjectsFromArray:listArray];
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
    if (_sureListArray.count < 3)
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
