//
//  BaseViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/7.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end


@implementation BaseViewController

- (void)dealloc
{
    _httpManager = nil;
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

- (HttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[HttpManager alloc]init];
    }
    
    return _httpManager;
}

- (void)requestNetworkGetData
{
    
}

@end
