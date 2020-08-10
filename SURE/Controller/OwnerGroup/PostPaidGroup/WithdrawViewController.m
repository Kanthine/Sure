//
//  WithdrawViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "WithdrawViewController.h"

#import "ApplyWithdrawVC.h"
#import "WithdrawRecordVC.h"
@interface WithdrawViewController ()

@end

@implementation WithdrawViewController

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
    
    self.navigationItem.title = @"提现页面";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)withdrawButtonClick:(UIButton *)sender
{
    ApplyWithdrawVC *applyVC = [[ApplyWithdrawVC alloc]initWithNibName:@"ApplyWithdrawVC" bundle:nil];
    [self.navigationController pushViewController:applyVC animated:YES];
}

- (IBAction)withdrawHistoryButtonClick:(UIButton *)sender
{
    WithdrawRecordVC *recordVC = [[WithdrawRecordVC alloc]initWithNibName:@"WithdrawRecordVC" bundle:nil];
    [self.navigationController pushViewController:recordVC animated:YES];
}



@end
