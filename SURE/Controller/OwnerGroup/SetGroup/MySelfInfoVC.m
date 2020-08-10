//
//  MySelfInfoVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define AppID @"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"

#import "MySelfInfoVC.h"

#import <StoreKit/StoreKit.h>

@interface MySelfInfoVC ()
<SKStoreProductViewControllerDelegate>
{
    
    __weak IBOutlet UILabel *_infoLable;
    __weak IBOutlet UIButton *_evaluateButton;
}
@end

@implementation MySelfInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _infoLable.text = [NSString stringWithFormat:@"版本信息:%@",[self getAppVersion]];
    
    _evaluateButton.layer.cornerRadius = 5;
    _evaluateButton.clipsToBounds = YES;
    _evaluateButton.layer.borderWidth = 1;
    _evaluateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
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
    
    self.navigationItem.title = @"关于我们";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)evaluateButtonClick:(UIButton *)sender
{
    /*
    跳转到AppStore评分,有两种方法：
    
    一种是跳出应用,跳转到AppStore,进行评分；
    
    另一种是在应用内,内置AppStore进行评分。
    */
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppID]];

//    return;
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"444934666"} completionBlock:^(BOOL result, NSError *error)
    {
        if(error)
        {
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
        }
        else
        {
            // 模态弹出appstore
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }    
    }];
//
}

- (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
