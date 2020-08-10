//
//  ApplyWithdrawVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ApplyWithdrawVC.h"

@interface ApplyWithdrawVC ()

@end

@implementation ApplyWithdrawVC

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
    
    self.navigationItem.title = @"申请提现";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
