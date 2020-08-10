//
//  MySureViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellIdentifer @"MySureCollectionCell"
#define HeaderIdentifer @"HeaderView"

#import "MySureViewController.h"

#import "MySureHeaderView.h"
#import "MySureCollectionCell.h"
#import "ShareViewController.h"
#import "SureDetaileViewController.h"

#import "MySureHeaderView.h"
#import <MJRefresh.h>


@interface MySureViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>


{
    NSString *_parserID;
    NSString *_userID;
    
    NSInteger _currentPage;
    
    OtherDetaileModel *_userModel;
}

@property (nonatomic ,strong) UIImageView *titleImageView;


@property (nonatomic ,strong) MySureHeaderView *headerView;
@property (nonatomic ,strong) UIView *segmentedView;


@property (nonatomic ,strong) UICollectionViewFlowLayout *tableFlowLayout;
@property (nonatomic ,strong) UICollectionViewFlowLayout *collectionFlowLayout;
@property (nonatomic ,strong) UICollectionView *collectionView;


@end

@implementation MySureViewController

- (instancetype)initWithParentID:(NSString *)parentID UserID:(NSString *)userID UserType:(SureUserType)userType SureListType:(SureListType )listType{
    self = [super init];
    
    if (self)
    {
        _currentPage = 1;
        _parserID = parentID;
        _userID = userID;
        _listType = listType;
        _userType = userType;
        [self requestNetworkGetData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavBar];
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar addSubview:self.titleImageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.titleImageView removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *carBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [carBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [carBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    carBarButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [carBarButton addTarget:self action:@selector(carBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *carButtonItem = [[UIBarButtonItem alloc]initWithCustomView:carBarButton];
    
    UIButton *shareButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    shareButton.imageEdgeInsets = carBarButton.imageEdgeInsets;
    [shareButton setImage:[UIImage imageNamed:@"sure_Share"] forState:UIControlStateNormal];
    
    shareButton.hidden = YES;
    
    [shareButton setImage:[UIImage imageNamed:@"sure_Share_Pressed"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItems = @[carButtonItem,shareButtonItem];
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)carBarButtonClick
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

- (void)shareButtonClick
{
    NSString *linkStr = @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *imageStr = _userModel.userHeader;
    NSString *descr = _userModel.userName;
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithLinkUrl:linkStr imageUrlStr:imageStr Descr:descr];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:^
     {
         [shareVC showPlatView];
     }];
}

- (UIImageView *)titleImageView
{
    if (_titleImageView == nil)
    {
        _titleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_Sure"]];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        _titleImageView.frame = CGRectMake( (ScreenWidth - 75 ) / 2.0, 12, 75, 20);
    }
    
    return _titleImageView;
}


- (MySureHeaderView *)headerView
{
    if (_headerView == nil)
    {
        if (_userType == SureUserTypeMy)
        {
            _headerView = [[MySureHeaderView alloc]initWithFrame:CGRectMake(0, -180, ScreenWidth, 150) IsMy:YES];
        }
        else
        {
            _headerView = [[MySureHeaderView alloc]initWithFrame:CGRectMake(0, -180, ScreenWidth, 150) IsMy:NO];
            [_headerView.optionButton addTarget:self action:@selector(addOptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        
        
        CGFloat height = [_headerView.signNameLable.text boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :_headerView.signNameLable.font } context:nil].size.height;
        
        _headerView.frame = CGRectMake(0, -(140 + height + 40), ScreenWidth, 140 + height);
    }
    
    return _headerView;
}

- (UIView *)segmentedView
{
    if (_segmentedView == nil)
    {
        _segmentedView = [[UIView alloc]initWithFrame:CGRectMake(0,-40 , ScreenWidth, 40)];
        _segmentedView.backgroundColor = [UIColor whiteColor];
        

        UILabel *grayLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        grayLable2.backgroundColor = GrayColor;
        [_segmentedView addSubview:grayLable2];
        
        
        NSMutableArray *segmentedTitleArray = [NSMutableArray arrayWithObjects:@"SURE",@"赞过的SURE",@"tag过的品牌", nil];
        CGFloat segmentedButtonWidth = ScreenWidth / 3.0;
        for (int i = 0; i < segmentedTitleArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(segmentedButtonWidth * i, 0, segmentedButtonWidth, CGRectGetHeight(_segmentedView.frame));
            button.tag = i + 10;
            [button addTarget:self action:@selector(switchSureSegmentedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UIColor *color = i == 0 ? RGBA(141, 31, 203,1) : [UIColor lightGrayColor];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitle:segmentedTitleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [_segmentedView addSubview:button];
        }
    }
    
    return _segmentedView;
}

- (void)switchSureSegmentedButtonClick:(UIButton *)sender
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
    
    
    
    
    switch (index)
    {
        case 0:
            // SURE
            if (_listType != SureListTypeSURE)
            {
                _currentPage = 1;
                self.listType = SureListTypeSURE;
                _collectionView.mj_footer.hidden = NO;
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                [self personalSURERequestData];
            }
            

            break;
        case 1:
            //赞过的 SURE
            if (_listType != SureListTypeTapedSure)
            {
                _currentPage = 1;
                _collectionView.mj_footer.hidden = NO;
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                self.listType = SureListTypeTapedSure;
                [self personalTapedSURERequestData];
            }
            

            break;
        case 2:
            //tag过的品牌
            if (_listType != SureListTypeTagBrand)
            {
                _currentPage = 1;
                _collectionView.mj_footer.hidden = NO;
                _collectionView.mj_footer.state = MJRefreshStateIdle;
                self.listType = SureListTypeTagBrand;
                [self personalTagedBrandRequestData];
            }
            

            break;
        default:
            break;
    }
    
    
    
}

-(void)changeStyle
{
//    if (_showType == SureShowTypeTable)
//    {
//        [self.collectionView setCollectionViewLayout:self.collectionFlowLayout];
//        [self.collectionView setScrollsToTop:YES];
//        _showType = SureShowTypeCollection;
//    }
//    else
//    {
//        [self.collectionView setCollectionViewLayout:self.tableFlowLayout];
//        [self.collectionView setScrollsToTop:YES];
//        _showType = SureShowTypeTable;
//    }
}

-(UICollectionViewFlowLayout *)tableFlowLayout
{
    if (_tableFlowLayout == nil)
    {
        _tableFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _tableFlowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenWidth);
        
        _tableFlowLayout.minimumInteritemSpacing = 1;
        
        _tableFlowLayout.minimumLineSpacing = 1;
    }
    return _tableFlowLayout;
}

- (UICollectionViewFlowLayout *)collectionFlowLayout
{
    
    if (_collectionFlowLayout == nil)
    {
        _collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (ScreenWidth - 2 )/ 3.0;
        _collectionFlowLayout.itemSize = CGSizeMake(width, width);
        _collectionFlowLayout.minimumLineSpacing = 1;
        _collectionFlowLayout.minimumInteritemSpacing = 1;
        
    }
    
    return _collectionFlowLayout;
    
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:self.collectionFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellWithReuseIdentifier:CellIdentifer];
        
        [_collectionView addSubview:self.headerView];
        [_collectionView addSubview:self.segmentedView];
        _collectionView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame) + 40, 0, 0, 0);

        NSLog(@"self.headerView.frame === %@",[NSValue valueWithCGRect:self.headerView.frame]);
        
        
        __weak __typeof(self) weakSelf = self;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                             {
                                                 [weakSelf pullUpLoadData];
                                             }];
        
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        _collectionView.mj_footer = footer;
        
    }
    
    return _collectionView;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_listType == SureListTypeSURE)
    {
        return _userModel.sureListArray.count;
    }
    else if (_listType == SureListTypeTapedSure)
    {
        return _userModel.tapSureListArray.count;
    }
    else if (_listType == SureListTypeTagBrand)
    {
        return _userModel.tagBrandListArray.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MySureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    
    if (_listType == SureListTypeSURE)
    {
        //发布 的 SURE
        SUREModel *sureModel = _userModel.sureListArray[indexPath.item];
        
        if (sureModel.imglistModelArray && sureModel.imglistModelArray.count)
        {
            
            SUREFileModel *fileModel = [sureModel.imglistModelArray firstObject];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fileModel.urlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
    else if (_listType == SureListTypeTapedSure)
    {
        //赞过的SURE
        SUREModel *sureModel = _userModel.tapSureListArray[indexPath.item];
        if (sureModel.imglistModelArray && sureModel.imglistModelArray.count)
        {
            
            SUREFileModel *fileModel = [sureModel.imglistModelArray firstObject];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fileModel.urlString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
    else if (_listType == SureListTypeTagBrand)
    {
        //tag过的品牌
    }
    
//    cell.imageView.image = [UIImage imageNamed:@"placeholderImage"];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_listType == SureListTypeSURE)
    {
        //发布 的 SURE
        SUREModel *sureModel = _userModel.sureListArray[indexPath.item];
        SureDetaileViewController *detaileVC = [[SureDetaileViewController alloc]initWithModel:sureModel];
        [self.navigationController pushViewController:detaileVC animated:YES];
    }
    else if (_listType == SureListTypeTapedSure)
    {
        //赞过的SURE
        SUREModel *sureModel = _userModel.tapSureListArray[indexPath.item];
        SureDetaileViewController *detaileVC = [[SureDetaileViewController alloc]initWithModel:sureModel];
        [self.navigationController pushViewController:detaileVC animated:YES];
    }
    else if (_listType == SureListTypeTagBrand)
    {
        //tag过的品牌
    }

    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    if (yOffset <= (-40))
    {
        _segmentedView.frame = CGRectMake(0, -40, ScreenWidth, 40);
    }
    else
    {
        _segmentedView.frame = CGRectMake(0, yOffset, ScreenWidth, 40);
    }
}





#pragma mark - requestNetworkGetData

- (void)pullUpLoadData
{
    _currentPage ++;
    if (_listType == SureListTypeSURE)
    {
        [self personalSURERequestData];
    }
    else if (_listType == SureListTypeTapedSure)
    {
        [self personalTapedSURERequestData];
    }
    else if (_listType == SureListTypeTagBrand)
    {
        [self personalTagedBrandRequestData];
    }
}


- (void)requestNetworkGetData
{
    NSString * sure_type = nil;
    switch (_listType)
    {
        case SureListTypeSURE:
            sure_type = @"sure_list";
            break;
        case SureListTypeTapedSure:
            sure_type = @"sure";
            break;
        case SureListTypeTagBrand:
            sure_type = @"brand";
            break;
        default:
            sure_type = @"";
            break;
    }
    

    NSDictionary *dist = @{@"cur_page":@"1",@"cur_size":@"20",@"parent_id":_parserID,@"user_id":_userID,@"sure_type":sure_type};
    
    
    [self.httpManager personalSureStatusWithParameterDict:dist CompletionBlock:^(OtherDetaileModel *userDetaileModel, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            _userModel = userDetaileModel;
            [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.userHeader] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            self.headerView.nameLable.text = _userModel.userName;
            self.headerView.signNameLable.text = _userModel.userSignature;
            self.headerView.countView.tapedCountLable.text = _userModel.tapedCount;
            self.headerView.countView.fansCountLable.text = _userModel.fansCount;
            self.headerView.countView.optionCountLable.text = _userModel.optionCount;
            
            
            NSLog(@"userDetaileModel.isOption ====%@",userDetaileModel.isOption);
            
            
            if ([_userModel.isOption isEqualToString:@"1"])
            {
                self.headerView.optionButton.selected = YES;//已关注
                
            }
            else
            {
                self.headerView.optionButton.selected = NO;//关注
            }
            
            
            CGFloat height = [self.headerView updateUIGetHeight];
            self.headerView.frame = CGRectMake(0, -height - 40, ScreenWidth, height);
            _collectionView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.headerView.frame) + 40, 0, 44, 0);
            self.collectionView.hidden = NO;
            [_collectionView reloadData];
        }
        
    }];
}

// 获取SURE列表数据
- (void)personalSURERequestData
{
    NSString *page = [NSString stringWithFormat:@"%ld",_currentPage];
    
    NSDictionary *dict = @{@"cur_page":page,@"cur_size":@"20",@"parent_id":_parserID,@"user_id":_userID};
    
    
    
    [self.httpManager sureListWithParameterDict:dict CompletionBlock:^(NSMutableArray<SUREModel *> *listArray, NSError *error)
     {
         if (listArray && listArray.count)
         {
             if (_currentPage == 1)
             {
                 _userModel.sureListArray = listArray;
             }
             else
             {
                 [_userModel.sureListArray addObjectsFromArray:listArray];
             }
             
             [self stopRefreshWithMoreData:NO IsTip:_userModel.sureListArray.count > 18];
         }
         else
         {
             [self stopRefreshWithMoreData:NO IsTip:_userModel.sureListArray.count > 18];
         }
         
         
         [_collectionView reloadData];
    }];

}

// 获取赞过的SURE列表数据
- (void)personalTapedSURERequestData
{
    NSString *page = [NSString stringWithFormat:@"%ld",_currentPage];
    
    NSDictionary *dict = @{@"cur_page":page,@"cur_size":@"20",@"parent_id":_parserID,@"sure_type":@"sure"};
    
    [self.httpManager personalSureDataWithParameterDict:dict CompletionBlock:^(NSMutableArray *listArray, NSError *error)
    {
        if (listArray && listArray.count)
        {
            if (_currentPage == 1)
            {
                _userModel.tapSureListArray = listArray;
            }
            else
            {
                [_userModel.tapSureListArray addObjectsFromArray:listArray];
            }
            
            [self stopRefreshWithMoreData:NO IsTip:_userModel.tapSureListArray.count > 18];
        }
        else
        {
            
            
            [self stopRefreshWithMoreData:NO IsTip:_userModel.tapSureListArray.count > 18];
        }
        
        [_collectionView reloadData];
    }];
    
}

// 获取Tag过的品牌列表数据
- (void)personalTagedBrandRequestData
{
    NSString *page = [NSString stringWithFormat:@"%ld",_currentPage];

    
    [self stopRefreshWithMoreData:NO IsTip:NO];
    
    [_collectionView reloadData];
    
    
}


// 添加关注 : 在观察别人详情页（除了自己）
- (void)addOptionButtonClick:(UIButton *)sender
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        
        return;
    }
    
    
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_parserID,@"follow_type":@"1"};
    sender.userInteractionEnabled = NO;
    if (sender.selected)
    {
        //已关注 --- > 取消关注
        sender.selected = NO;
        sender.backgroundColor = RGBA(141, 31, 203, 1);

        
        [self.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
        {
            sender.userInteractionEnabled = YES;
            if (error)
            {
                _userModel.isOption = @"1";
            }
            else
            {
                _userModel.isOption = @"0";
            }
        }];
        
        
        
        
    }
    else
    {
        //未关注 --- > 关注
        sender.selected = YES;
        sender.backgroundColor = [UIColor whiteColor];

        [self.httpManager attentionWithParameterDict:dict CompletionBlock:^(NSError *error)
         {
             sender.userInteractionEnabled = YES;

             if (error)
             {
                 _userModel.isOption = @"0";
             }
             else
             {
                 _userModel.isOption = @"1";
             }
         }];
    }
}


- (void)stopRefreshWithMoreData:(BOOL)isMoreData IsTip:(BOOL)isTip
{
    if ([_collectionView.mj_footer isRefreshing])
    {
        if (isMoreData)
        {
            [_collectionView.mj_footer endRefreshing];
        }
        else
        {
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
    
    
    
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_collectionView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (isTip == NO)
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
