//
//  MySureCoinVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/27.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "MySureCoinVC.h"

#import "SureCoinDetaileVC.h"
#import "EveryDaySignInVC.h"


@interface MySureCoinVC ()

{
    __weak IBOutlet UIButton *_lookDetaileButton;
}

@end

@implementation MySureCoinVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _lookDetaileButton.layer.borderColor = RGBA(141, 31, 203, 1).CGColor;
    _lookDetaileButton.layer.borderWidth = 1;
    
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
    
    self.navigationItem.title = @"SURE币";
    
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

- (IBAction)goSignInButtonClick:(UIButton *)sender
{
    EveryDaySignInVC *signVC = [[EveryDaySignInVC alloc]init];
    [self.navigationController pushViewController:signVC animated:YES];
}


- (IBAction)lookSureCoinDeatileButtonClick:(UIButton *)sender
{
    SureCoinDetaileVC *coinvC = [[SureCoinDetaileVC alloc]init];
    [self.navigationController pushViewController:coinvC animated:YES];
}



@end
