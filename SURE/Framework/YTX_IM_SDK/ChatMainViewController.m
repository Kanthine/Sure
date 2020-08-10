//
//  ChatMainViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/11/22.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ChatMainViewController.h"


#import "SUNSlideSwitchView.h"
#import "SessionViewController.h"
#import "ContactListViewController.h"

#import "AppDelegate.h"
#import "ECLoginInfo.h"
#import "ECDevice.h"
#import "ECMultiDeviceState.h"
#import "UIImage+Extend.h"

NSString *const Notification_ChangeMainDisplay = @"Notification_ChangeMainDisplay";

CGFloat NavAndBarHeight = 64.0f;
#define bito 0.4

@interface ChatMainViewController()
<SUNSlideSwitchViewDelegate, SlideSwitchSubviewDelegate>

//显示的内容view
@property (nonatomic, strong) SessionViewController *sessionView;
@property (nonatomic, strong) ContactListViewController *contactView;
@property (nonatomic, strong) UIView *menuView;

@end

@implementation ChatMainViewController

{
    SUNSlideSwitchView *_slideSwitchView;
    BOOL notFirst;
}



- (void) dealloc
{
    [self ClearView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self customNavBar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMainDisplaySubview:) name:Notification_ChangeMainDisplay object:nil];
    
    //刷新历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveHistoryMessage) name:KNOTIFICATION_haveHistoryMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completionSyncHistory) name:KNOTIFICATION_HistoryMessageCompletion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popNameInputAlertView) name:KNOTIFICATION_needInputName object:nil];
    
    
    [self customSlideSwitchView];
    
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainviewdidappear" object:nil];
    [self popNameInputAlertView];
    
}

- (void)customNavBar
{
    self.title = @"消息中心";
    self.navigationItem.titleView = nil;
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *rightBarButton =[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [rightBarButton setImage:[[UIImage imageNamed:@"plusSign"] scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [rightBarButton setImage:[[UIImage imageNamed:@"plusSign"] scaleToSize:CGSizeMake(20, 20)]  forState:UIControlStateHighlighted];
    [rightBarButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClicked
{
    if (self.menuView == nil)
    {
        
        self.menuView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClearView)];
        [self.menuView addGestureRecognizer:tap];
        
        NSArray *menuTitles = @[@"添加SURE友"];

        
        CGFloat menuHeight = 40.0f;
        CGFloat menuWidht = self.view.bounds.size.width * bito;
        CGFloat menuX = self.view.bounds.size.width*(1-bito);
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(menuX, 64.0f, menuWidht, menuHeight*menuTitles.count)];
        view.tag = 50;
        view.backgroundColor = [UIColor blackColor];
        [self.menuView addSubview:view];
        
        for (NSString* title in menuTitles)
        {
            NSUInteger index = [menuTitles indexOfObject:title];
            UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            menuBtn.frame = CGRectMake(0.0f, menuHeight*index, menuWidht, menuHeight);
            [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [menuBtn setTitle:title forState:UIControlStateNormal];
            menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [menuBtn addTarget:self action:@selector(menuListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:menuBtn];
        }
    }
    
    if (self.menuView.superview == nil)
    {
        [self.view.window addSubview:self.menuView];
    }
}

- (void)customSlideSwitchView
{
    //滑动效果的添加
    _slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    _slideSwitchView.slideSwitchViewDelegate = self;
    
    _slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1];
    _slideSwitchView.tabItemSelectedColor = [UIColor redColor];
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"navigation_bar_on"]
                                    stretchableImageWithLeftCapWidth:50.f topCapHeight:5.0f];
    
    
    self.sessionView = [[SessionViewController alloc] init];
    self.sessionView.title = @"沟通";
    self.sessionView.mainView = self;
    self.sessionView.tableView.scrollsToTop = YES;
    
    self.contactView = [[ContactListViewController alloc] init];
    self.contactView.title = @"联系人";
    self.contactView.mainView = self;
    self.contactView.tableView.scrollsToTop = YES;
    
    
    [_slideSwitchView buildUI];
}

- (void)completionSyncHistory
{
    self.title = @"IM通讯";
    self.navigationItem.titleView = nil;
}

-(void)haveHistoryMessage
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSString *title = @"收取中...";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    UIActivityIndicatorView *Activityview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    Activityview.frame = CGRectMake((self.view.frame.size.width-size.width-Activityview.frame.size.width)*0.5f-5, 22.0f-Activityview.frame.size.height*0.5f, Activityview.frame.size.width, Activityview.frame.size.height);
    label.frame = CGRectMake(Activityview.frame.origin.x+Activityview.frame.size.width+5, 22-size.height*0.5f, size.width, size.height);
    label.text = title;
    [Activityview startAnimating];
    [view addSubview:Activityview];
    [view addSubview:label];
    
    self.navigationItem.titleView = view;
    self.title = nil;
}



//Toast错误信息
-(void)showToast:(NSString *)message
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)changeMainDisplaySubview:(NSNotification*)notification
{
    NSInteger selectIndex = [notification.object integerValue];
    [_slideSwitchView setSelectedViewIndex:selectIndex andAnimation:NO];
}



-(void)ClearView
{
    [self.menuView removeFromSuperview];
}

- (void)menuListBtnClicked:(UIButton *)sender
{
    //
}


#pragma mark - SUNSlideSwitchView

/*
 * 返回tab个数
 */
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 2;
}

/*
 * 每个tab所属的viewController
 */
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0)
    {
        return self.sessionView;
    } else if (number == 1)
    {
        return self.contactView;
    }
    else
    {
        return nil;
    }
}

/*
 * 点击tab
 */
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (number == 0)
    {
        self.sessionView.tableView.scrollsToTop = YES;
        self.contactView.tableView.scrollsToTop = NO;
        [self.sessionView prepareDisplay];
    }
    else if (number == 1)
    {
        self.sessionView.tableView.scrollsToTop = NO;
        self.contactView.tableView.scrollsToTop = YES;
        [self.contactView prepareDisplay];
    }
    else
    {
        
    }
}

#pragma mark - SlideSwitchSubviewDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:viewController animated:animated];
}


-(void)popNameInputAlertView
{
    if ([self.navigationController.topViewController isKindOfClass:NSClassFromString(@"PersonInfoViewController")])
    {
        return;
    }
    
    if ([DemoGlobalClass sharedInstance].isNeedSetData) {
        UIViewController* viewController = [[NSClassFromString(@"PersonInfoViewController") alloc] init];
        [viewController.navigationItem setHidesBackButton:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

