//
//  ChatDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 17/1/4.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ChatDetaileVC.h"

@interface ChatDetaileVC ()

@end

@implementation ChatDetaileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    self.navigationItem.title = @"客服中心";
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}


-(void)leftBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

