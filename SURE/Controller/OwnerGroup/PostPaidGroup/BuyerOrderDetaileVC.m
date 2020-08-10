//
//  BuyerOrderDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BuyerOrderDetaileVC.h"

@interface BuyerOrderDetaileVC ()

@end

@implementation BuyerOrderDetaileVC

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
    
    self.navigationItem.title = @"用户订单明细";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
