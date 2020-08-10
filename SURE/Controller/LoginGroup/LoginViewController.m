//
//  LoginViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define Leftspace 30.0

#import "LoginViewController.h"

#import "ForegtPwdViewController.h"//忘记密码
#import "RegisterViewController.h"//注册
#import "BindingMobilePhoneVC.h"//第三方登录，绑定手机号

#import "ErrorTipView.h"
#import "LoginButtonView.h"

#import "LoginThirdPartyCoverView.h"//第三方登录 覆盖图层

#import <UMSocialCore/UMSocialCore.h>

#import "MainTabBarController.h"

#import "ValidateClass.h"

#import "LoginHttpManager.h"

@interface LoginViewController ()

{
    
    __weak IBOutlet UIView *_logo_1_ContentView;
    
    __weak IBOutlet UIImageView *_logoTitleIamgeView;
    
    __weak IBOutlet UIImageView *_loginBackImageView;

    __weak IBOutlet UIView *_inputContentView;
    __weak IBOutlet UIView *_thirdPartyContentView;
    
    
    __weak IBOutlet UIButton *_loginButton;
    
    __weak IBOutlet UIButton *_registerButton;
    __weak IBOutlet UIButton *_forgerPasswordButton;
    
    
    __weak IBOutlet UITextField *_accountTf;
    __weak IBOutlet UITextField *_pwdTf;
    
    __weak IBOutlet UIButton *_joinMainButton;
    
    
    
    UIActivityIndicatorView *_loginActivityIndicator;
}

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation LoginViewController

- (void)dealloc
{
    self.httpManager = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
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
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BindMobilePhoneSuccessClick:) name:@"BindMobilePhoneSuccess" object:nil];
    
    [self setImageControlFrame];
    
    
    _loginActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_loginActivityIndicator];
    [_loginActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    [_accountTf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_accountTf setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_pwdTf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTf setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    
}

- (void)setLoginButton
{
    LoginButtonView *loginButton = [[LoginButtonView alloc]initWithFrame:CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y, _loginButton.frame.size.width, _loginButton.frame.size.height)];
    [self.view addSubview:loginButton];
    
    
    __block LoginButtonView *button = loginButton;
    
    
    __weak __typeof__ (self) wself = self;
    
    
    loginButton.translateBlock = ^
    {
        NSLog(@"跳转了哦");
        button.bounds = CGRectMake(0, 0, 44, 44);
        button.layer.cornerRadius = 22;
        
        [wself setLoginButton];
    };
}

- (void)keyBoardChange:(NSNotification *)notification
{
    NSDictionary *userInfoDict = notification.userInfo;

    
    NSLog(@"userInfoDict ===== %@",userInfoDict);
    
    CGFloat time = [[userInfoDict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSValue *endValue = [userInfoDict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] ;
    CGRect endRect = [endValue CGRectValue];
    CGFloat yCoordinate = endRect.origin.y;

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:time];
    

    if (yCoordinate > _thirdPartyContentView.frame.origin.y - 40 - 6)
    {
        if ([UIDevice currentMainScreen] == 1)
        {
            _logo_1_ContentView.frame = CGRectMake(180, 30, 100, 210);
        }
        else if ([UIDevice currentMainScreen] == 2)
        {
            _logo_1_ContentView.frame = CGRectMake(215, 60, 100, 210);
            
        }
        else if ([UIDevice currentMainScreen] == 3)
        {
            _logo_1_ContentView.frame = CGRectMake(238, 92, 100, 210);
        }
        _logoTitleIamgeView.frame = CGRectMake((ScreenWidth - 73 ) / 2.0 , -20 , 73, 18);
        
        //键盘消失
        _loginButton.frame = CGRectMake(Leftspace, _thirdPartyContentView.frame.origin.y - 40 - 60, ScreenWidth - Leftspace * 2, 40);
    }
    else
    {
        if ([UIDevice currentMainScreen] == 1)
        {
            _logo_1_ContentView.frame = CGRectMake(ScreenWidth, 30, 100, 210);
        }
        else if ([UIDevice currentMainScreen] == 2)
        {
            _logo_1_ContentView.frame = CGRectMake(ScreenWidth, 60, 100, 210);
            
        }
        else if ([UIDevice currentMainScreen] == 3)
        {
            _logo_1_ContentView.frame = CGRectMake(ScreenWidth, 92, 100, 210);
        }
        _logoTitleIamgeView.frame = CGRectMake((ScreenWidth - 73 ) / 2.0 , 60 , 73, 18);
        
        
        _loginButton.frame = CGRectMake(Leftspace, yCoordinate - 40 - 60, ScreenWidth - Leftspace * 2, 40);
    }

    _registerButton.frame = CGRectMake(Leftspace, _loginButton.frame.origin.y + CGRectGetHeight(_loginButton.frame) + 10  , 70, 30);
    _forgerPasswordButton.frame = CGRectMake(ScreenWidth - Leftspace - 70, _loginButton.frame.origin.y + CGRectGetHeight(_loginButton.frame) + 10 , 70, 30);
    _inputContentView.frame = CGRectMake(Leftspace,_loginButton.frame.origin.y - 80 - 30, ScreenWidth - Leftspace * 2, 80);
    
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setImageControlFrame
{
    _loginBackImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    _joinMainButton.frame = CGRectMake(Leftspace, ScreenHeight - 30 - 10, ScreenWidth - Leftspace * 2, 30);
    
    _thirdPartyContentView.frame = CGRectMake(Leftspace, _joinMainButton.frame.origin.y - 40 - 15, ScreenWidth - Leftspace * 2, 40);
    UIButton *qqButton = (UIButton *)[_thirdPartyContentView viewWithTag:10];
    UIButton *weChatButton = (UIButton *)[_thirdPartyContentView viewWithTag:11];
    UIButton *sinaButton = (UIButton *)[_thirdPartyContentView viewWithTag:12];
    qqButton.frame = CGRectMake(15, 2, 35, 35);
    weChatButton.frame = CGRectMake((CGRectGetWidth(_thirdPartyContentView.frame) - 35)/2.0, 2, 35, 35);
    sinaButton.frame = CGRectMake(CGRectGetWidth(_thirdPartyContentView.frame) - 35 - 15, 2, 35, 35);
    
    
    _loginButton.frame = CGRectMake(Leftspace, _thirdPartyContentView.frame.origin.y - 40 - 60, ScreenWidth - Leftspace * 2, 40);
    _registerButton.frame = CGRectMake(Leftspace, _loginButton.frame.origin.y + CGRectGetHeight(_loginButton.frame) + 10  , 70, 30);
    _forgerPasswordButton.frame = CGRectMake(ScreenWidth - Leftspace - 70, _loginButton.frame.origin.y + CGRectGetHeight(_loginButton.frame) + 10 , 70, 30);
    
    _inputContentView.frame = CGRectMake(Leftspace,_loginButton.frame.origin.y - 80 - 30, ScreenWidth - Leftspace * 2, 80);
    UILabel *grayLable = [_inputContentView viewWithTag:20];
    UILabel *lineLable = [_inputContentView viewWithTag:21];
    UILabel *accountLable = [_inputContentView viewWithTag:22];
    UILabel *passwordLable = [_inputContentView viewWithTag:23];
    grayLable.frame = CGRectMake(0, 0, CGRectGetWidth(_inputContentView.frame), CGRectGetHeight(_inputContentView.frame));
    lineLable.frame = CGRectMake(0, CGRectGetHeight(_inputContentView.frame) / 2.0 - 0.5, CGRectGetWidth(_inputContentView.frame), 0.5);
    accountLable.frame = CGRectMake(10, 10, 35, 20);
    passwordLable.frame = CGRectMake(10, 50, 35, 20);
    _accountTf.frame = CGRectMake(55, 3, CGRectGetWidth(_inputContentView.frame) - 60, 34);
    _pwdTf.frame = CGRectMake(55, 43, CGRectGetWidth(_inputContentView.frame) - 60, 34);
    
    
    if ([UIDevice currentMainScreen] == 1)
    {
        _logo_1_ContentView.frame = CGRectMake(180, 30, 100, 210);
    }
    else if ([UIDevice currentMainScreen] == 2)
    {
        _logo_1_ContentView.frame = CGRectMake(215, 60, 100, 210);

    }
    else if ([UIDevice currentMainScreen] == 3)
    {
        _logo_1_ContentView.frame = CGRectMake(238, 92, 100, 210);
    }
    
    
    UIImageView *logo_1_SignImageView = [_logo_1_ContentView viewWithTag:30];
    UIImageView *logo_1_TitleImageView = [_logo_1_ContentView viewWithTag:31];
    logo_1_SignImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_logo_1_ContentView.frame), CGRectGetHeight(_logo_1_ContentView.frame));
    logo_1_TitleImageView.frame = CGRectMake(14, 7,  73, 18);
    
    _logoTitleIamgeView.frame = CGRectMake((ScreenWidth - 73 ) / 2.0 , -20 , 73, 18);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)forgetPwdButtonClick:(UIButton *)sender
{
    ForegtPwdViewController *foregtVC = [[ForegtPwdViewController alloc]init];
    [self.navigationController pushViewController:foregtVC animated:YES];
}

- (IBAction)reginButtonClick:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}


- (IBAction)loginButtonClick:(UIButton *)sender
{
//    [_accountTf resignFirstResponder];
//    [_pwdTf  resignFirstResponder];
    if ([self isLegal] == NO)
    {
        return;
    }
    
    //点击登录按钮时 判断手机号是否正确 密码是否为空
    _loginActivityIndicator.center =  _loginButton.center;
    [_loginButton setTitle:@"" forState:UIControlStateNormal];
    [_loginActivityIndicator startAnimating]; // 开始旋转

    //手机号或者密码不正确
    //手机号不存在
    //手机号密码正确，登录成功
    [self.httpManager loginWithAccount:_accountTf.text Password:_pwdTf.text CompletionBlock:^(AccountInfo *user, NSError *error)
    {
        [_loginActivityIndicator stopAnimating]; // 结束旋转
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        
        if (user)
        {
            //登录成功后IM登录
            [AuthorizationManager getIM_Authorization];

            [user storeAccountInfo];//存储数据
            //登录成功，进入主界面
            if (self.isNeedDismiss)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                MainTabBarController *mainController = [MainTabBarController shareMainController];
                [mainController loadNetworkData];
                APPDELEGETE.window.rootViewController = mainController;
            }
            
        }
        else
        {
            NSLog(@"errString == %@",error.domain);

            ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:error.domain frame:CGRectMake(100, _inputContentView.frame.origin.y + 20, 200, 50)];
            [tipView showInView:self.view ShowDuration:1];

            [self shakeAnimationForView:_pwdTf];
        }

    }];

    
}

- (void)shakeAnimationForView:(UIView *) view

{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.06];
    
    // 设置次数
    
    [animation setRepeatCount:3];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
}

- (BOOL)isLegal
{
    
    if ([ValidateClass isMobile:_accountTf.text] == NO)
    {
        //手机号有误
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"手机号有误" frame:CGRectMake(100, _inputContentView.frame.origin.y + 20, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        return NO;
    }
    
    
    if (_pwdTf.text.length == 0)
    {
        //密码不能为空
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"密码不能为空" frame:CGRectMake(100, _inputContentView.frame.origin.y + 60, 200, 50)];
        [tipView showInView:self.view ShowDuration:1];
        
        return NO;
    }
    
    
    
    return YES;
}

- (IBAction)qqLoginClick:(UIButton *)sender
{    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error)
    {
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        if (resp.uid && resp.name &&resp.iconurl )
        {
            NSDictionary *parameterDict = @{@"aite_id":resp.uid,@"login_type":@"1",@"nickname":resp.name,@"headimg":resp.iconurl};
            
            [self thirdPartyLoginWithParameterDict:parameterDict];
        }
    }];
    
    
    
}

- (IBAction)weChatLoginClick:(UIButton *)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error)
     {
         
         UMSocialUserInfoResponse *resp = result;
         
         // 第三方登录数据(为空表示平台未提供)
         // 授权数据
         NSLog(@" uid: %@", resp.uid);
         NSLog(@" openid: %@", resp.openid);
         NSLog(@" accessToken: %@", resp.accessToken);
         NSLog(@" refreshToken: %@", resp.refreshToken);
         NSLog(@" expiration: %@", resp.expiration);
         
         // 用户数据
         NSLog(@" name: %@", resp.name);
         NSLog(@" iconurl: %@", resp.iconurl);
         NSLog(@" gender: %@", resp.gender);
         
         // 第三方平台SDK原始数据
         NSLog(@" originalResponse: %@", resp.originalResponse);
         if (resp.uid && resp.name && resp.iconurl )
         {
             NSDictionary *parameterDict = @{@"aite_id":resp.uid,@"login_type":@"2",@"nickname":resp.name,@"headimg":resp.iconurl};
             [self thirdPartyLoginWithParameterDict:parameterDict];

         }


     }];
}

- (IBAction)wbLoginClick:(UIButton *)sender
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error)
     {
         
         UMSocialUserInfoResponse *resp = result;
         
         // 第三方登录数据(为空表示平台未提供)
         // 授权数据
         NSLog(@" uid: %@", resp.uid);
         NSLog(@" openid: %@", resp.openid);
         NSLog(@" accessToken: %@", resp.accessToken);
         NSLog(@" refreshToken: %@", resp.refreshToken);
         NSLog(@" expiration: %@", resp.expiration);
         
         // 用户数据
         NSLog(@" name: %@", resp.name);
         NSLog(@" iconurl: %@", resp.iconurl);
         NSLog(@" gender: %@", resp.gender);
         
         // 第三方平台SDK原始数据
         NSLog(@" originalResponse: %@", resp.originalResponse);
         NSString *headerImageStr = [resp.originalResponse objectForKey:@"avatar_hd"];
         if (resp.uid && resp.name && headerImageStr )
         {

             NSDictionary *parameterDict = @{@"aite_id":resp.uid,@"login_type":@"3",@"nickname":resp.name,@"headimg":headerImageStr};
             [self thirdPartyLoginWithParameterDict:parameterDict];
        }
         
     }];
}

- (void)thirdPartyLoginWithParameterDict:(NSDictionary *)parameterDict
{
    LoginThirdPartyCoverView *loadView = [[LoginThirdPartyCoverView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:loadView];
    [loadView startAnimation];
    
    [self.httpManager thirdPartyLoginWithParameterDict:parameterDict CompletionBlock:^(AccountInfo *user, NSError *error)
     {
         
         [loadView dismissFromSuperView];
         
         NSLog(@"user.mobilePhone ====== %@",user.mobilePhone);
         
         if (user && user.mobilePhone.length > 2)
         {
             
             //登录成功后IM登录
             [AuthorizationManager getIM_Authorization];
             
             
             [user storeAccountInfo];//存储数据
             //登录成功，进入主界面
             if (self.isNeedDismiss)
             {
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 MainTabBarController *mainController = [MainTabBarController shareMainController];
                 [mainController loadNetworkData];
                 APPDELEGETE.window.rootViewController = mainController;
             }
         }
         else if (user && user.mobilePhone.length < 2)
         {
             //绑定手机号
             BindingMobilePhoneVC *bindingVC = [[BindingMobilePhoneVC alloc]init];
             bindingVC.headerURLStr = parameterDict[@"headimg"];
             bindingVC.userIDStr = user.userId;
             [self.navigationController pushViewController:bindingVC animated:YES];
             
         }
         else
         {
             NSLog(@"errString == %@",error.domain);
         }
         
     }];

}

- (IBAction)joinMainPageClick:(UIButton *)sender
{
    if (self.isNeedDismiss)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        MainTabBarController *mainController = [MainTabBarController shareMainController];
        [mainController loadNetworkData];
        APPDELEGETE.window.rootViewController = mainController;
    }
}

- (void)BindMobilePhoneSuccessClick:(NSNotification *)notification
{
    AccountInfo *user = notification.userInfo[@"user"];
    [user storeAccountInfo];//存储数据
    
    //登录成功后IM登录
    [AuthorizationManager getIM_Authorization];
    
    
    //登录成功，进入主界面
    if (self.isNeedDismiss)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        MainTabBarController *mainController = [MainTabBarController shareMainController];
        [mainController loadNetworkData];
        APPDELEGETE.window.rootViewController = mainController;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
