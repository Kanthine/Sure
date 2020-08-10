//
//  ForegtPwdViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ForegtPwdViewController.h"

#import "LoginHttpManager.h"


#import "UpdatePwdVC.h"
#import "ErrorTipView.h"

@interface ForegtPwdViewController ()

{
    NSString *_verificationCodeString;
    NSString *_phoneNumberString;
    
    __weak IBOutlet UIButton *_verificationCodeButton;
    
    __weak IBOutlet UITextField *_phoneNumberTf;
    
    __weak IBOutlet UITextField *_verCodetf;
    
    NSInteger _interval;
}

@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation ForegtPwdViewController

- (void)dealloc
{
    self.httpManager = nil;
    self.timer = nil;
}

- (LoginHttpManager *)httpManager
{
    if (_httpManager == nil)
    {
        _httpManager = [[LoginHttpManager alloc]init];
    }
    
    return _httpManager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self customNavBarItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBarItem
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navBar_LeftButton"] style:UIBarButtonItemStyleDone target:self action:@selector(leftItemButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"找回密码";
}

- (void)leftItemButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick
{
    if ([self isLeagle] == NO)
    {
        return;
    }
    
    // 验证码正确，进入下一步
    if ([_verificationCodeString isEqualToString:_verCodetf.text]
        && [_phoneNumberString isEqualToString:_phoneNumberTf.text])
    {
        UpdatePwdVC *updateVC = [[UpdatePwdVC alloc]init];
        updateVC.numberString = _phoneNumberString;
        updateVC.codeString = _verificationCodeString;
        [self.navigationController pushViewController:updateVC animated:YES];
    }
    else
    {
        //提示手机号码有问题
        CGFloat y = _verCodetf.frame.origin.y + _verCodetf.frame.size.height;
        CGFloat x = _verCodetf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"验证码有误" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];

    }

}

- (IBAction)getVerificationCode:(UIButton *)sender
{
    
    if ([self isLeagle] == NO)
    {
        return;
    }
    
    
    
    if (_verificationCodeButton.enabled)
    {
        [self timer];
        
        //获取验证码
        NSDictionary *dict = @{@"mobile_phone":_phoneNumberTf.text,@"user_id":@""};
        
        [self.httpManager getVerificationCodeWithParameterDict:dict CompletionBlock:^(NSString *verificationCodeString, NSError *error)
        {
            
            if (verificationCodeString)
            {
                _verificationCodeString = verificationCodeString;
                _phoneNumberString = _phoneNumberTf.text;
            }
            else
            {
                CGFloat y = _phoneNumberTf.frame.origin.y + _phoneNumberTf.frame.size.height;
                CGFloat x = _verCodetf.frame.origin.x;
                
                ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:error.domain frame:CGRectMake( x + 20, y - 10, 200, 50)];
                [tipView showInView:self.view ShowDuration:1];
            }
        }];

        
        //不能连续点击
        _verificationCodeButton.enabled = NO;
    }

}

- (BOOL)isLeagle
{
    if ([ValidateClass isMobile:_phoneNumberTf.text] == NO)
    {
        CGFloat y = _phoneNumberTf.frame.origin.y + _phoneNumberTf.frame.size.height;
        CGFloat x = _verCodetf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"手机号码有误" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        
        
        return NO;
    }
    
    
    
    
    return YES;
}


- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
        _interval = 60;
    }
    return _timer;
}

- (void)sendMessage
{
    _interval --;
    NSString *title = [NSString stringWithFormat:@"重新发送(%02ld)",_interval];
    _verificationCodeButton.titleLabel.text = title;
    [_verificationCodeButton setTitle:title forState:UIControlStateDisabled];
    
    if (_interval == 0)
    {
        [_verificationCodeButton setTitle:@"再次发送" forState:UIControlStateDisabled];
        _interval = 60;
        _verificationCodeButton.enabled = YES;
        [self.timer invalidate];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_phoneNumberTf resignFirstResponder];
    [_verCodetf resignFirstResponder];
}


@end
