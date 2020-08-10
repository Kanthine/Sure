//
//  ScanLifeResultViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/2/20.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ScanLifeResultViewController.h"
#import <WebKit/WebKit.h>

@interface ScanLifeResultViewController ()

@property (nonatomic ,strong) WKWebView *webView;

@end

@implementation ScanLifeResultViewController

- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    
    if (self)
    {
        if ([urlString hasPrefix:@"http"])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        }
        else
        {
            
            NSArray *array = [urlString componentsSeparatedByString:@"ID 是"];
            NSString *uID = array.lastObject;
            
            AccountInfo *account = [AccountInfo standardAccountInfo];
            
            urlString = [NSString stringWithFormat:@"上家用户ID是 %@ \n ；下家的uID是 %@",uID,account.userId];
            
            [self.webView loadHTMLString:urlString baseURL:nil];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationItem.title = @"扫描结果";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

- (void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (WKWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }
    
    return _webView;
}

@end
