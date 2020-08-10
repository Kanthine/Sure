//
//  MainTabBarController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/16.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "MainTabBarController.h"

#import "BrandViewController.h"
#import "RecommendViewController.h"
#import "SureViewController.h"
#import "KindViewController.h"
#import "OwnerViewController.h"


@interface MainTabBarController ()


@property (nonatomic ,strong) NSMutableArray *tabBarArray;

@end

@implementation MainTabBarController

static MainTabBarController *tabBarController = nil;
+ (MainTabBarController *)shareMainController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      tabBarController = [[MainTabBarController alloc]init];
                  });
    
    return tabBarController;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.tabBar.tintColor = RGBA(141, 44, 200,1);
        
        UIImage *whiteImage = [UIImage createImageWithColor:[UIColor whiteColor]];
        UIImage *newImage = [whiteImage imageByApplyingAlpha:.95f];
        self.tabBar.backgroundImage = newImage;
        
        self.viewControllers = self.tabBarArray;
        

    }
    
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNetworkData
{
    /* 品牌页面数据预加载 */
    UINavigationController *brandNav = [MainTabBarController shareBrandNavigationController];
    BrandViewController *brandVC = (BrandViewController *)[brandNav.viewControllers firstObject];
    [brandVC requestNetworkGetData];
    
    
    
    /* 推荐页面数据预加载 */
    UINavigationController *recommendNav = [MainTabBarController shareRecommendNavigationController];
    RecommendViewController *recommendVC = (RecommendViewController *)[recommendNav.viewControllers firstObject];
    [recommendVC requestNetworkGetData];
    
    
    /* sure页面数据预加载 */
    UINavigationController *sureNav = [MainTabBarController shareSureNavigationController];
    SureViewController *sureVC = (SureViewController *)[sureNav.viewControllers firstObject];
    [sureVC requestNetworkGetData];
    
    
    
    
    /* 分类页面数据预加载 */
    UINavigationController *kindNav = [MainTabBarController shareKindNavigationController];
    KindViewController *kindVC = (KindViewController *)[kindNav.viewControllers firstObject];
    [kindVC requestNetworkGetData];
    
    
}

#pragma mark -

static UINavigationController *brandNavigationController = nil;
+ (UINavigationController *)shareBrandNavigationController
{
    static dispatch_once_t rootOnceToken;
    dispatch_once(&rootOnceToken, ^
                  {
                      BrandViewController *brandVC = [[BrandViewController alloc]init];
                      brandVC.tabBarItem.title = @"品牌";
                      brandVC.tabBarItem.image  = [UIImage imageNamed:@"tabBar_Brand"];
                      brandVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_Brand_Select"];
                      brandNavigationController= [[UINavigationController alloc]initWithRootViewController:brandVC];
                  });
    
    return brandNavigationController;
}

static UINavigationController *recommendNavigationController = nil;
+ (UINavigationController *)shareRecommendNavigationController
{
    static dispatch_once_t onceCarToken;
    dispatch_once(&onceCarToken, ^
                  {
                      RecommendViewController *recommendVC = [[RecommendViewController alloc]init];
                      recommendVC.tabBarItem.title = @"推荐";
                      recommendVC.tabBarItem.image  = [UIImage imageNamed:@"tabBar_Recomend"];
                      recommendVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_Recomend_Select"];
                      recommendNavigationController= [[UINavigationController alloc]initWithRootViewController:recommendVC];
                  });
    
    return recommendNavigationController;
}

static UINavigationController *sureNavigationController = nil;
+ (UINavigationController *)shareSureNavigationController
{
    static dispatch_once_t onceStoreToken;
    dispatch_once(&onceStoreToken, ^
                  {
                      
                      NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
                      attrs[NSFontAttributeName] = [UIFont fontWithName:@"helvetica neue" size:12];
                      
                      SureViewController *sureVC = [[SureViewController alloc]init];
                      sureVC.tabBarItem.title = @"SURE";
                      [sureVC.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
                      sureVC.tabBarItem.image  = [UIImage imageNamed:@"tabBar_Sure"];
                      sureVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_Sure_Select"];
                      
                      
                      
                      sureNavigationController= [[UINavigationController alloc]initWithRootViewController:sureVC];
                  });
    
    return sureNavigationController;
}

static UINavigationController *kindNavigationController = nil;
+ (UINavigationController *)shareKindNavigationController
{
    static dispatch_once_t onceKindToken;
    dispatch_once(&onceKindToken, ^
                  {
                      KindViewController *myVC = [[KindViewController alloc]init];
                      myVC.tabBarItem.title = @"分类";
                      myVC.tabBarItem.image  = [UIImage imageNamed:@"tabBar_Kind"];
                      myVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_Kind_Select"];
                      kindNavigationController= [[UINavigationController alloc]initWithRootViewController:myVC];
                  });
    
    return kindNavigationController;
}


static UINavigationController *ownerNavigationController = nil;
+ (UINavigationController *)shareOwnerNavigationController
{
    static dispatch_once_t onceMyToken;
    dispatch_once(&onceMyToken, ^
                  {
                      OwnerViewController *myVC = [[OwnerViewController alloc]init];
                      myVC.tabBarItem.title = @"我的";
                      myVC.tabBarItem.image  = [UIImage imageNamed:@"tabBar_Owner"];
                      myVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_Owner_Select"];
                      ownerNavigationController= [[UINavigationController alloc]initWithRootViewController:myVC];
                  });
    
    return ownerNavigationController;
}

- (NSMutableArray *)tabBarArray
{
    if (_tabBarArray == nil)
    {
        _tabBarArray = [NSMutableArray array];
        
        UINavigationController *brandNav = [MainTabBarController shareBrandNavigationController];
        UINavigationController *recommendNav = [MainTabBarController shareRecommendNavigationController];
        UINavigationController *sureNav = [MainTabBarController shareSureNavigationController];
        UINavigationController *kindNav = [MainTabBarController shareKindNavigationController];
        UINavigationController *ownerNav = [MainTabBarController shareOwnerNavigationController];
        
        [_tabBarArray addObject:brandNav];
        [_tabBarArray addObject:recommendNav];
        [_tabBarArray addObject:sureNav];
        [_tabBarArray addObject:kindNav];
        [_tabBarArray addObject:ownerNav];
        
    }
    
    return _tabBarArray;
}


@end
