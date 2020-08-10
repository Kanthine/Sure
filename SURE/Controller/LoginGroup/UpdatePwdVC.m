//
//  UpdatePwdVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/10.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "UpdatePwdVC.h"

#import "ErrorTipView.h"

#import "LoginHttpManager.h"


@interface UpdatePwdVC ()

{
    __weak IBOutlet UITextField *_firstPwdTf;
    
    __weak IBOutlet UITextField *_secondPwdTf;
}

@property (nonatomic ,strong) LoginHttpManager *httpManager;


@end

@implementation UpdatePwdVC

- (void)dealloc
{
    self.httpManager = nil;
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
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.navigationItem.title = @"找回密码";
}

- (void)leftItemButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick
{
    if ([self judgePassWordIsLegal] == NO)
    {
        return;
    }

    
    NSDictionary *dict = @{@"user_name":_numberString,@"salt":_codeString,@"password":_firstPwdTf.text};
    
    [self.httpManager resetPasswordWithParameters:dict CompletionBlock:^(BOOL isSuccess, NSError *error)
     {
         if (isSuccess)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             CGFloat y = _secondPwdTf.frame.origin.y + _secondPwdTf.frame.size.height;
             CGFloat x = _secondPwdTf.frame.origin.x;
             
             ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:error.domain frame:CGRectMake( x + 20, y - 10, 200, 50)];
             [tipView showInView:self.view ShowDuration:2];
             
         }
    }];

}

- (BOOL)judgePassWordIsLegal
{
    //两次密码完全一致且符合要求
    //两次密码一致但不合要求
    //密码为空
    //两次密码不一致
    
    if ([_firstPwdTf.text isEqualToString:_secondPwdTf.text]
        && _firstPwdTf.text.length > 0)
    {
        
        if ([ValidateClass judgePassWordLegal:_firstPwdTf.text]
            && [ValidateClass judgePassWordLegal:_secondPwdTf.text])
        {
            return YES;
        }
        else
        {
            CGFloat y = _secondPwdTf.frame.origin.y + _secondPwdTf.frame.size.height;
            CGFloat x = _secondPwdTf.frame.origin.x;
            
            ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"密码不规范，请重新输入" frame:CGRectMake( x + 20, y - 10, 200, 50)];
            [tipView showInView:self.view ShowDuration:2];
            
            
            return NO;
        }
        
    }
    else if (_firstPwdTf.text.length == 0 || _secondPwdTf.text.length == 0)
    {
        CGFloat y = _secondPwdTf.frame.origin.y + _secondPwdTf.frame.size.height;
        CGFloat x = _secondPwdTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"密码不能为空!" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        return NO;
    }
    else
    {
        CGFloat y = _secondPwdTf.frame.origin.y + _secondPwdTf.frame.size.height;
        CGFloat x = _secondPwdTf.frame.origin.x;
        
        ErrorTipView *tipView = [[ErrorTipView alloc]initWithTipString:@"两次密码输入不一致,请重新输入!" frame:CGRectMake( x + 20, y - 10, 200, 50)];
        [tipView showInView:self.view ShowDuration:2];
        
        
        
        return NO;
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_firstPwdTf resignFirstResponder];
    [_secondPwdTf resignFirstResponder];
}



@end
