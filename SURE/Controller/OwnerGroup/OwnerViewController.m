//
//  OwnerViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellIdentiferProto @"OwnerOriginalCell"
#define CellIdentiferOrder @"OwnerOrderCell"
#define CellIdentiferTools @"OwnerToolsCell"
#define CellIdentiferSures @"OwnerSureCell"
#define CellIdentiferSign @"OwnerSignCell"
#define HeaderIdentifer @"OwnerTableSectionHeaderView"


#define BackGroupHeight (250.0 / 375.0 * ScreenWidth)



#import "OwnerViewController.h"

#import "OwnerTableSectionHeaderView.h"
#import "OwnerOrderCell.h"
#import "OwnerToolsCell.h"
#import "OwnerSureCell.h"
#import "OwnerSignCell.h"
#import "OwnerOriginalCell.h"

#import "SingleProductCollectionCell.h"
#import "OwnerHeaderView.h"

#import "UIImage+Extend.h"

#import "PersonalSetVC.h"
#import "OrderListVC.h"
#import "RefundListVC.h"

#import "CollectBrandVC.h"
#import "CollectProductVC.h"
#import "MySureCoinVC.h"
#import "CouponViewController.h"

#import "WithdrawViewController.h"
#import "SalesViewController.h"

#import "MySureViewController.h"

#import "MessageCenterVC.h"
#import "ChatMainViewController.h"

#import "VideoPickerViewController.h"

#import "PersonalCenterVC.h"
#import "TapSupportDetaileVC.h"

#import "FilePathManager.h"

#import "ApplyPostPaidUserVC.h"
#import "HowPromotionViewController.h"
#import "PublicBarcodeVC.h"

#import "ChatViewController.h"

typedef NS_ENUM(NSUInteger, OwnerViewType)
{
    OwnerViewTypeNoLogin = 0,//4个分区
    OwnerViewTypeLoginNoSign,//4个分区
    OwnerViewTypeLoginAndSign,//5个分区
};

@interface OwnerViewController ()

<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,
UINavigationControllerDelegate>

{
    UIImageView *_navBarImageView;
    UILabel *_navBarTitleLable;
    UIButton *_leftNavBarButton;
    UIButton *_carBarButton;
    UIButton *_messageBarButton;
    
    CGFloat _sure_Y;

}

@property (nonatomic ,assign) OwnerViewType ownerType;

@property (nonatomic ,strong) UIView *navBarView;
@property (nonatomic ,strong) UIImageView *headerBackImageView;

@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) OwnerHeaderView *infoHeaderView;

@property (nonatomic ,strong) UIButton *loginButton;


@end

@implementation OwnerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.navBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackImageSuccessClick) name:@"ChangeBackImageSuccess" object:nil];
    
    //登录状态
    self.ownerType = OwnerViewTypeNoLogin;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;

    if ([AuthorizationManager isAuthorization])
    {
        [self.infoHeaderView updateMyInfo];
        
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if ([account.isFenxiao isEqualToString:@"1"])
        {
            self.ownerType = OwnerViewTypeLoginAndSign;
        }
        else
        {
            self.ownerType = OwnerViewTypeLoginNoSign;
        }
        
        
    }
    else
    {
        self.ownerType = OwnerViewTypeNoLogin;
    }
    
}

- (void)changeBackImageSuccessClick
{
    NSString *filePath = [FilePathManager getDefaultBackImagePath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    self.headerBackImageView.image = image;
}

- (void)setOwnerType:(OwnerViewType)ownerType
{
    _ownerType = ownerType;
    
    switch (ownerType)
    {
        case OwnerViewTypeNoLogin:
            self.loginButton.center = CGPointMake(_headerBackImageView.center.x, _headerBackImageView.center.y + 30);
            [self.tableview addSubview:self.loginButton];
            
            break;
        case OwnerViewTypeLoginNoSign:
            
            if (_loginButton)
            {
                [_loginButton removeFromSuperview];
                _loginButton = nil;
            }
            
            break;
        case OwnerViewTypeLoginAndSign:
            if (_loginButton)
            {
                [_loginButton removeFromSuperview];
                _loginButton = nil;
            }
            break;
        default:
            break;
    }
    
    [_tableview reloadData];
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

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.delegate = self;
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.backgroundColor = [UIColor clearColor];
        _navBarView.clipsToBounds = YES;

        
        _navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        _navBarImageView.frame = _navBarView.bounds;
        _navBarImageView.alpha = 0;
        [_navBarView addSubview:_navBarImageView];
        
        
        
        _navBarTitleLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth - 80) / 2.0, 20,80, 44)];
//        _navBarTitleLable.text = [NSString stringWithFormat:@"我的"];
        _navBarTitleLable.backgroundColor = [UIColor clearColor];
        _navBarTitleLable.font = [UIFont systemFontOfSize:16];
        _navBarTitleLable.textColor = [UIColor whiteColor];
        _navBarTitleLable.textAlignment = NSTextAlignmentCenter;
        [_navBarView addSubview:_navBarTitleLable];
        
        
        _leftNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
        _leftNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_SetBack"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_SetBack_Pressed"] forState:UIControlStateHighlighted];
        [_leftNavBarButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_leftNavBarButton];
        
        
        _carBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateNormal];
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateHighlighted];
        [_carBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_carBarButton];
        
        _messageBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 20, 40, 40)];
        [_messageBarButton setImage:[UIImage imageNamed:@"navBar_MessageBack"] forState:UIControlStateNormal];
        [_messageBarButton setImage:[UIImage imageNamed:@"navBar_MessageBack_Pressed"] forState:UIControlStateHighlighted];
        [_messageBarButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_messageBarButton];
    }
    
    return _navBarView;
}

-(void)leftBtnAction
{
    PersonalSetVC *setVC = [[PersonalSetVC alloc]init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

-(void)rightBtnAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

- (void)messageButtonClick
{
    MessageCenterVC *messageVC = [[MessageCenterVC alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (UIButton *)loginButton
{
    if (_loginButton == nil)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginButton.titleLabel.shadowOffset = CGSizeMake(.5, .5);
        [_loginButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.layer.borderWidth = 2;
        _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _loginButton.frame = CGRectMake(0, 0, 120, 45);
        [_loginButton addTarget:self action:@selector(loginButtonclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (void)loginButtonclick
{
    [AuthorizationManager getAuthorizationWithViewController:self];
}

#pragma mark - UITableView

- (UIImageView *)headerBackImageView
{
    if (_headerBackImageView == nil)
    {
        _headerBackImageView =[[UIImageView alloc]init];
        _headerBackImageView.frame=CGRectMake(0, -BackGroupHeight , ScreenWidth, BackGroupHeight);
        
        
        
        NSString *filePath = [FilePathManager getDefaultBackImagePath];
        UIImage *backImage = [UIImage imageNamed:@"owner_Back"];;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image)
            {
                backImage = image;
            }
        }
        
        _headerBackImageView.image= backImage;
    }
    
    return _headerBackImageView;
}

- (OwnerHeaderView *)infoHeaderView
{
    if (_infoHeaderView == nil)
    {
        __weak __typeof__(self) weakSelf = self;
        
        _infoHeaderView = [[OwnerHeaderView alloc]initWithFrame:CGRectMake( 0, -43, ScreenWidth, OwnerHeaderViewHeight)];
        _infoHeaderView.currentViewController = self;

        _infoHeaderView.ownerHeaderViewSupportedButtonClick = ^
        {
            //被赞数
            [weakSelf likedDetaileButtonClick];
        };
        _infoHeaderView.ownerHeaderViewFansCountButtonClick = ^
        {
            //粉丝数
            [weakSelf fansDetaileButtonClick];
        };
        _infoHeaderView.ownerHeaderViewOptionButtonClick = ^
        {
            //关注
            [weakSelf optionButtonClick];
        };
        
        [_infoHeaderView updateMyInfo];

    }
    return _infoHeaderView;
}

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        
        [_tableview registerClass:[OwnerTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
        [_tableview registerClass:[OwnerOrderCell class] forCellReuseIdentifier:CellIdentiferOrder];
        [_tableview registerClass:[OwnerToolsCell class] forCellReuseIdentifier:CellIdentiferTools];
        [_tableview registerClass:[OwnerSureCell class] forCellReuseIdentifier:CellIdentiferSures];
        [_tableview registerClass:[OwnerOriginalCell class] forCellReuseIdentifier:CellIdentiferProto];

        [_tableview registerNib:[UINib nibWithNibName:CellIdentiferSign bundle:nil] forCellReuseIdentifier:CellIdentiferSign];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
        _tableview.contentInset = UIEdgeInsetsMake(BackGroupHeight, 0, 49, 0);
        [_tableview addSubview:self.headerBackImageView];

    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (_ownerType)
    {
        case OwnerViewTypeNoLogin:
            return 4;
            break;
        case OwnerViewTypeLoginNoSign:
            return 4;
            break;
        case OwnerViewTypeLoginAndSign:
            return 5;
            break;
        default:
            break;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_ownerType == OwnerViewTypeLoginAndSign && section == 4)
    {
        return 2;
    }
    else if ( (_ownerType == OwnerViewTypeNoLogin || _ownerType == OwnerViewTypeLoginNoSign ) && section == 3)
    {
        return 3;
    }
    
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (_ownerType != OwnerViewTypeNoLogin && section == 0)
    {
        return OwnerHeaderViewHeight;
    }
    else if (section == 0 || section == 1 || section == 2 || (_ownerType == OwnerViewTypeLoginAndSign && section == 3))
    {
        return 44;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ownerType == OwnerViewTypeLoginAndSign && indexPath.section == 0)
    {
        return 70;
    }
    else if ( (_ownerType == OwnerViewTypeLoginAndSign && indexPath.section == 4 ) || (_ownerType != OwnerViewTypeLoginAndSign && indexPath.section == 3))
    {
        return 45;
    }
    
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OwnerTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];

    
    headerView.headerTitleLable.frame = CGRectMake(10, 10, 100, 20);
    headerView.lookAllButton.frame = CGRectMake(ScreenWidth - 150, 0, 150, 40);
    [headerView.lookAllButton removeTarget:self action:@selector(lookAllButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView.lookAllButton removeTarget:self action:@selector(lookMyBarcodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isKindOfClass:[OwnerHeaderView class]])
         {
             [obj removeFromSuperview];
             
             * stop = YES;
         }
    }];
    
    
    if (_ownerType != OwnerViewTypeLoginAndSign)
    {
        if (_ownerType == OwnerViewTypeNoLogin && section == 0)
        {
            headerView.headerTitleLable.text = @"我的订单";
            
            [headerView.lookAllButton setTitle:@"查看全部订单" forState:UIControlStateNormal];
            [headerView.lookAllButton addTarget:self action:@selector(lookAllButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
            headerView.lookAllButton.hidden = NO;
            return headerView;
        }
        else if (_ownerType == OwnerViewTypeLoginNoSign && section == 0)
        {
            [headerView.contentView addSubview:self.infoHeaderView];
            
            headerView.headerTitleLable.frame = CGRectMake(10, OwnerHeaderViewHeight - 30, 80, 20);
            headerView.lookAllButton.frame = CGRectMake(ScreenWidth - 150, OwnerHeaderViewHeight - 40, 150, 40);
            headerView.headerTitleLable.text = @"我的订单";
            [headerView.lookAllButton addTarget:self action:@selector(lookAllButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [headerView.lookAllButton setTitle:@"查看全部订单" forState:UIControlStateNormal];
            headerView.lookAllButton.hidden = NO;
            return headerView;
        }
        else if (section == 1)
        {
            headerView.headerTitleLable.text = @"我的工具箱";
            headerView.lookAllButton.hidden = YES;
            
            return headerView;
        }
        else if (section == 2)
        {
            headerView.headerTitleLable.text = @"SURE";
            headerView.lookAllButton.hidden = YES;
            
            return headerView;
        }
        else
        {
            return nil;
        }

    }
    else
    {
        if (section == 0)
        {
            [headerView.contentView addSubview:self.infoHeaderView];
            headerView.headerTitleLable.frame = CGRectMake(10, OwnerHeaderViewHeight - 30, 100, 20);
            headerView.lookAllButton.frame = CGRectMake(ScreenWidth - 150, OwnerHeaderViewHeight - 40, 150, 40);
            headerView.headerTitleLable.text = @"我是签约用户";
            headerView.lookAllButton.hidden = NO;
            [headerView.lookAllButton setTitle:@"推广二维码" forState:UIControlStateNormal];
            [headerView.lookAllButton addTarget:self action:@selector(lookMyBarcodeButtonClick) forControlEvents:UIControlEventTouchUpInside];

            return headerView;
        }
        else if (section == 1)
        {
            headerView.headerTitleLable.text = @"我的订单";
            headerView.lookAllButton.hidden = NO;
            [headerView.lookAllButton setTitle:@"查看全部订单" forState:UIControlStateNormal];
            [headerView.lookAllButton addTarget:self action:@selector(lookAllButtonButtonClick) forControlEvents:UIControlEventTouchUpInside];
            return headerView;
        }
        else if (section == 2)
        {
            headerView.headerTitleLable.text = @"我的工具箱";
            headerView.lookAllButton.hidden = YES;
            return headerView;
        }
        else if (section == 3)
        {
            headerView.headerTitleLable.text = @"SURE";
            headerView.lookAllButton.hidden = YES;
            
            return headerView;
        }
        else
        {
            return nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if (_ownerType != OwnerViewTypeLoginAndSign)
    {
        if (indexPath.section == 0)
        {
            OwnerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferOrder forIndexPath:indexPath];
            cell.ownerOrderCellButtonClick = ^(NSInteger index)
            {
                [weakSelf ownerOrderCellButtonClick:index];
            };
            
            return cell;
        }
        else if (indexPath.section == 1)
        {
            OwnerToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferTools forIndexPath:indexPath];
            cell.ownerToolsCellButtonClick = ^(NSInteger index)
            {
                [weakSelf lookToolsBoxWithIndexPath:index];
            };

            return cell;
            
        }
        else if (indexPath.section == 2)
        {
            OwnerSureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferSures forIndexPath:indexPath];
            cell.ownerSuresCellButtonClick = ^(NSInteger index)
            {
                [weakSelf lookMySureWithIndexPath:index];
            };
            return cell;
        }
    }
    else if (_ownerType == OwnerViewTypeLoginAndSign)
    {
        if (indexPath.section == 0)
        {
            OwnerSignCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferSign forIndexPath:indexPath];
            cell.ownerSignCellButtonClick = ^(NSInteger index)
            {
                [weakSelf lookPostPaidWithIndexPath:index];
            };
            return cell;
        }
        else if (indexPath.section == 1)
        {
            OwnerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferOrder forIndexPath:indexPath];
            cell.ownerOrderCellButtonClick = ^(NSInteger index)
            {
                [weakSelf ownerOrderCellButtonClick:index];
            };
            return cell;
        }
        else if (indexPath.section == 2)
        {
            OwnerToolsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferTools forIndexPath:indexPath];
            cell.ownerToolsCellButtonClick = ^(NSInteger index)
            {
                [weakSelf lookToolsBoxWithIndexPath:index];
            };

            return cell;
            
        }
        else if (indexPath.section == 3)
        {
            OwnerSureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferSures forIndexPath:indexPath];
            cell.ownerSuresCellButtonClick = ^(NSInteger index)
            {
                [weakSelf lookMySureWithIndexPath:index];
            };
            return cell;
        }
    }
    
    
    OwnerOriginalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferProto];
    
    
    
    if (_ownerType == OwnerViewTypeLoginAndSign )
    {
        switch (indexPath.row)
        {
            case 0:
                cell.leftLable.text = @"如何推广";
                break;
            case 1:
                cell.leftLable.text = @"联系客服";
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.leftLable.text = @"成为签约用户";
                break;
            case 1:
                cell.leftLable.text = @"如何推广";
                break;
            case 2:
                cell.leftLable.text = @"联系客服";
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_ownerType)
    {
        case OwnerViewTypeNoLogin:
        case OwnerViewTypeLoginNoSign:
        {
            // 登录 未签约
            if (indexPath.section == 3)
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        if ([AuthorizationManager isAuthorization])
                        {
                            //成为签约用户
                            ApplyPostPaidUserVC *applyVC = [[ApplyPostPaidUserVC alloc]initWithNibName:@"ApplyPostPaidUserVC" bundle:nil];
                            applyVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:applyVC animated:YES
                             ];
                        }
                        else
                        {
                            [AuthorizationManager getAuthorizationWithViewController:self];
                        }
                        

                    }
                        break;
                    case 1:
                    {
                        //如何推广
                        HowPromotionViewController *howPromotion = [[HowPromotionViewController alloc]initWithNibName:@"HowPromotionViewController" bundle:nil];
                        howPromotion.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:howPromotion animated:YES];

                    }
                        break;
                    case 2:
                    {
                        if ([AuthorizationManager isAuthorization])
                        {
                            //联系客服
                            ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
                            [self presentViewController:nav animated:YES completion:nil];
                        }
                        else
                        {
                            [AuthorizationManager getAuthorizationWithViewController:self];
                        }



                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case OwnerViewTypeLoginAndSign:
        {
            // 登录 签约
            if (indexPath.section == 4)
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        //如何推广
                        HowPromotionViewController *howPromotion = [[HowPromotionViewController alloc]initWithNibName:@"HowPromotionViewController" bundle:nil];
                        howPromotion.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:howPromotion animated:YES];
                    }
                        break;
                    case 1:
                    {
                        if ([AuthorizationManager isAuthorization])
                        {
                            //联系客服
                            ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
                            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
                            [self presentViewController:nav animated:YES completion:nil];
                        }
                        else
                        {
                            [AuthorizationManager getAuthorizationWithViewController:self];
                        }

                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
}

//订单事件

- (void)ownerOrderCellButtonClick:(NSInteger)index
{
    switch (index)
    {
        case 20://待付款
        {
            [self lookOrderListWithOrderState:1];
        }
            break;
        case 21://待发货
        {
            [self lookOrderListWithOrderState:2];
        }
            break;
        case 22://接收货
        {
            [self lookOrderListWithOrderState:3];
        }
            break;
        case 23://待SURE
        {
            [self lookOrderListWithOrderState:4];
        }
            break;
        case 24://退款、售后
        {
            RefundListVC *refundVC = [[RefundListVC alloc]init];
            refundVC.refundType = RefundStateAll;
            refundVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:refundVC animated:YES];
        }
            break;
        default:
            break;
    }
    

}

//推广二维码
- (void)lookMyBarcodeButtonClick
{
    PublicBarcodeVC *barcodeVC = [[PublicBarcodeVC alloc]init];
    barcodeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:barcodeVC animated:YES];
}

- (void)lookAllButtonButtonClick
{
    [self lookOrderListWithOrderState:0];
}

- (void)lookOrderListWithOrderState:(NSInteger)index
{
    if ([AuthorizationManager isAuthorization])
    {
        OrderListVC *orderVC = [[OrderListVC alloc]init];
        switch (index)
        {
            case 0:
                orderVC.orderType = OrderStateAll;
                break;
            case 1://待付款
                orderVC.orderType = OrderStateWaitPay;
                break;
            case 2://待发货
                orderVC.orderType = OrderStateWaitSendGoods;
                break;
            case 3://待收货
                orderVC.orderType = OrderStateReceiveGoods;
                break;
            case 4://待SURE
                orderVC.orderType = OrderStateWaitSure;
                break;
            default:
                break;
        }
        [orderVC requestNetworkGetData];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

//工具箱事件
- (void)lookToolsBoxWithIndexPath:(NSInteger)index
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    
    switch (index)
    {
        case 10://收藏品牌
        {
            CollectBrandVC *brandVC = [[CollectBrandVC alloc]init];
            [brandVC requestNetworkGetData];
            brandVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 11://收藏单品
        {
            CollectProductVC *productVC = [[CollectProductVC alloc]init];
            [productVC requestNetworkGetData];
            productVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productVC animated:YES];
        }
            break;
        case 12://SURE币
        {
            MySureCoinVC *sureCoinVC = [[MySureCoinVC alloc]init];
            sureCoinVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sureCoinVC animated:YES];
        }
            break;
        case 13://优惠券
        {
            CouponViewController *couponVC = [[CouponViewController alloc]init];
            [couponVC requestNetworkGetData];
            couponVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
        case 14://积分商城
        {
            
        }
            break;
        default:
            break;
    }

}

//SURE 事件
- (void)lookMySureWithIndexPath:(NSInteger)index
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    AccountInfo *account = [AccountInfo standardAccountInfo];

    switch (index)
    {
        case 30://我的SURE
        {
            MySureViewController *sureVC = [[MySureViewController alloc]initWithParentID:account.userId UserID:account.userId UserType:SureUserTypeMy SureListType:SureListTypeSURE];
            sureVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sureVC animated:YES];
        }
            break;
        case 31://我赞过的SURE
        {
            MySureViewController *sureVC = [[MySureViewController alloc]initWithParentID:account.userId UserID:account.userId UserType:SureUserTypeMy SureListType:SureListTypeTapedSure];
            sureVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sureVC animated:YES];
        }
            break;
        case 32://我Tag过的品牌
        {
            MySureViewController *sureVC = [[MySureViewController alloc]initWithParentID:account.userId UserID:account.userId UserType:SureUserTypeMy SureListType:SureListTypeTagBrand];
            sureVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sureVC animated:YES];
        }
            break;
        default:
            break;
    }
}

//签约用户 事件
- (void)lookPostPaidWithIndexPath:(NSInteger)index
{
    if ([AuthorizationManager isAuthorization] == NO)
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
        return;
    }
    
    
    switch (index)
    {
        case 40://提现
        {
            WithdrawViewController *withdrawVC = [[WithdrawViewController alloc]initWithNibName:@"WithdrawViewController" bundle:nil];
            withdrawVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:withdrawVC animated:YES];
        }
            break;
        case 41://销售额
        {
            SalesViewController *salesVC = [[SalesViewController alloc]initWithNibName:@"SalesViewController" bundle:nil];
            salesVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:salesVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Header View Button

- (void)likedDetaileButtonClick
{
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSString *userID = account.userId;
        //被赞数
        TapSupportDetaileVC *supportDetaileVC = [[TapSupportDetaileVC alloc]init];
        supportDetaileVC.titleString = @"被赞数";
        supportDetaileVC.userID = userID;
        supportDetaileVC.attentionedID = @"";
        supportDetaileVC.type = @"4";
        [supportDetaileVC requestNetworkGetData];
        supportDetaileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:supportDetaileVC animated:YES];
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }

}

- (void)fansDetaileButtonClick
{
    if ([AuthorizationManager isAuthorization])
    {
        //粉丝数
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        NSString *userID = account.userId;
        TapSupportDetaileVC *supportDetaileVC = [[TapSupportDetaileVC alloc]init];
        supportDetaileVC.titleString = @"粉丝";
        supportDetaileVC.userID = userID;
        supportDetaileVC.attentionedID = @"";
        supportDetaileVC.type = @"4";
        [supportDetaileVC requestNetworkGetData];
        supportDetaileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:supportDetaileVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}

- (void)optionButtonClick
{
    if ([AuthorizationManager isAuthorization])
    {
        /* 1是用户2是店铺3商品4sure点赞 */
        
        //关注
        AccountInfo *account = [AccountInfo standardAccountInfo];
        NSString *userID = account.userId;
        TapSupportDetaileVC *supportDetaileVC = [[TapSupportDetaileVC alloc]init];
        supportDetaileVC.titleString = @"关注者";
        supportDetaileVC.userID = userID;
        supportDetaileVC.attentionedID = @"";
        supportDetaileVC.type = @"1";
        [supportDetaileVC requestNetworkGetData];
        supportDetaileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:supportDetaileVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}


#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    
    if (yOffset < -BackGroupHeight)
    {
        CGRect rect = _headerBackImageView.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = ScreenWidth + fabs(xOffset)*2;
        
        _headerBackImageView.frame = rect;
        if (_loginButton)
        {
            _loginButton.center = CGPointMake(_headerBackImageView.center.x, _headerBackImageView.center.y + 30);
        }
    }
    
    CGFloat alpha = (yOffset + BackGroupHeight)/BackGroupHeight;
    _navBarImageView.alpha = alpha;
    
    
    if (alpha < 0.5f)
    {
        
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_SetBack"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_SetBack_Pressed"] forState:UIControlStateHighlighted];

        
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateNormal];
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar_Back_Pressed"] forState:UIControlStateHighlighted];
        
        [_messageBarButton setImage:[UIImage imageNamed:@"navBar_MessageBack"] forState:UIControlStateNormal];
        [_messageBarButton setImage:[UIImage imageNamed:@"navBar_MessageBack_Pressed"] forState:UIControlStateHighlighted];

    }
    else
    {
        
        [_leftNavBarButton setImage:[UIImage imageNamed:@"owner_Set"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"owner_Set_Pressed"] forState:UIControlStateHighlighted];
        
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [_carBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
        [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
        [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];

    }
}

@end
