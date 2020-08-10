//
//  RegisterViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/11.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "RegisterViewController.h"

#import "LoginHttpManager.h"


#import "ValidateClass.h"
#import "ErrorTipView.h"
@interface RegisterViewController ()

{
    __weak IBOutlet UITextField *_phoneNumberTf;
    
    __weak IBOutlet UITextField *_verCodeTf;
    
    
    __weak IBOutlet UITextField *_passwordTf;
    
    
    __weak IBOutlet UIButton *_codeButton;
    
    NSString *_verificationCodeString;
    NSString *_phoneNumberString;
    
    NSInteger _interval;
}

@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation RegisterViewController

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
    
    _verificationCodeString = nil;
    
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
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"注册";
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
    
    
    
    NSDictionary *dict = @{@"froms":@"iOS",@"mobile_phone":_phoneNumberTf.text,@"salt":_verCodeTf.text,@"password":_passwordTf.text};
    
    
    [self.httpManager regiserAccountWithParameter:dict CompletionBlock:^(BOOL isSuccess, NSString *errorString)
     {
         if (isSuccess)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             CGFloat y = _passwordTf.frame.origin.y + _passwordTf.frame.size.height;
             CGFloat x = _phoneNumberTf.frame.origin.x;
             
             ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:errorString frame:CGRectMake( x + 20, y - 10, 200, 50)];
             [tipView showInView:self.view ShowDuration:1];
         }
    }];
}

- (BOOL)isLeagle
{
    
    //手机号没变，验证码正确，密码格式正确
    //手机号没变，验证码正确，密码格式错误
    //手机号没变，验证码错误
    //手机号错误
    
    if ([ValidateClass isMobile:_phoneNumberTf.text] == NO)
    {
        CGFloat y = _phoneNumberTf.frame.origin.y + _phoneNumberTf.frame.size.height;
        CGFloat x = _phoneNumberTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"手机号有误" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        return NO;
    }
    
    if ([_verCodeTf.text isEqualToString:_verificationCodeString] == NO)
    {
        CGFloat y = _verCodeTf.frame.origin.y + _verCodeTf.frame.size.height;
        CGFloat x = _verCodeTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"验证码有误" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        
        return NO;
    }
    
    
    if ([_passwordTf.text length] == 0)
    {
        
        CGFloat y = _passwordTf.frame.origin.y + _passwordTf.frame.size.height;
        CGFloat x = _passwordTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"密码不得为空" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        return NO;
    }
    

    
    
    return YES;
}



- (IBAction)getVerificationCodeButtonClick:(UIButton *)sender
{
    if ([ValidateClass isMobile:_phoneNumberTf.text])
    {
        
        if (_codeButton.enabled)
        {
            // -- > 发送短信请求
             [self timer];
            
            NSDictionary *dict = @{@"mobile_phone":_phoneNumberTf.text,@"user_id":@""};
            
            [self.httpManager getVerificationCodeWithParameterDict:dict CompletionBlock:^(NSString *verificationCodeString, NSError *error)
            {
                
                NSLog(@"verificationCodeString === %@",verificationCodeString);
                
                if (verificationCodeString)
                {
                    _phoneNumberString = _phoneNumberTf.text;
                    _verificationCodeString = verificationCodeString;
                }
            }];
            
            //不能连续点击
            _codeButton.enabled = NO;
        }
    }
    else
    {
        _phoneNumberString = nil;
        
        CGFloat y = _phoneNumberTf.frame.origin.y + _phoneNumberTf.frame.size.height;
        CGFloat x = _phoneNumberTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"手机号码有误!" frame:CGRectMake( x + 20, y - 5, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
    }
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
    _codeButton.titleLabel.text = title;
    [_codeButton setTitle:title forState:UIControlStateDisabled];
    
    if (_interval == 0)
    {
        [_codeButton setTitle:@"再次发送" forState:UIControlStateDisabled];
        _interval = 60;
        _codeButton.enabled = YES;
        [self.timer invalidate];
    }
}


@end
