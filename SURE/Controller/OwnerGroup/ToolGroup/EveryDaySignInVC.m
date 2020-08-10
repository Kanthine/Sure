//
//  EveryDaySignInVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/28.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "EveryDaySignInVC.h"

#import "SignInView.h"
#import "SureCoinDetaileVC.h"

@interface EveryDaySignInVC ()

@end

@implementation EveryDaySignInVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self customNavBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"每日签到";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightNavBarButton.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    [rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Question"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    
}

- (IBAction)signInButtonClick:(UIButton *)sender
{
    SignInView *signView = [[SignInView alloc]init];
    signView.currentViewController = self;
    [signView show];

}


- (IBAction)lookSureCoinDeatileButtonClick:(UIButton *)sender
{
    SureCoinDetaileVC *coinvC = [[SureCoinDetaileVC alloc]init];
    [self.navigationController pushViewController:coinvC animated:YES];
}


@end
