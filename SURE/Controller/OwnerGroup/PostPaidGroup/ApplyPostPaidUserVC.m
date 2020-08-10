//
//  ApplyPostPaidUserVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "ApplyPostPaidUserVC.h"
#import "ErrorTipBlackView.h"
#import "UserInfoHttpManager.h"
@interface ApplyPostPaidUserVC ()

{
    
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;
@end

@implementation ApplyPostPaidUserVC

- (void)dealloc
{
    _httpManager = nil;
}

- (UserInfoHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[UserInfoHttpManager alloc]init];
    }
    
    return _httpManager;
}


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
    
    
    UIImageView *textImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_Sure"]];
    textImageView.contentMode = UIViewContentModeScaleAspectFit;
    textImageView.frame = CGRectMake( 0, 0, 73, 20);
    self.navigationItem.titleView = textImageView;
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//是否同意协议
- (IBAction)isAgreeProtocolButtonClick:(UIButton *)sender
{
    UIButton *applyButton = [sender.superview viewWithTag:5];
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        applyButton.backgroundColor = RGBA(141, 31, 203, 1);
        applyButton.userInteractionEnabled = YES;
    }
    else
    {
        applyButton.backgroundColor = RGBA(149, 149, 149, 1);
        applyButton.userInteractionEnabled = NO;
    }
    
}

//查看协议
- (IBAction)lookProtocolButtonClick:(UIButton *)sender
{
    
}

//成为签约用户
- (IBAction)applyPostPaidButtonClick:(UIButton *)sender
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.userId};
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"申请中...";

    [self.httpManager applyPostPaidParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];

         if (error)
         {
             [ErrorTipBlackView errorTip:error.domain SuperView:self.view];
         }
         else
         {
             account.isFenxiao = @"1";
             [account storeAccountInfo];
             [ErrorTipBlackView errorTip:@"您已成为签约用户" SuperView:self.view];
         }
         
         
    }];
    
    
}

//规则说明
- (IBAction)howApplyUserButtonClick:(UIButton *)sender
{
    
}

- (BOOL)isCanApply
{
    return YES;
}

@end
