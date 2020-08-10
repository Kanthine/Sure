//
//  ResetNickNameVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ResetNickNameVC.h"

#import "UserInfoHttpManager.h"

@interface ResetNickNameVC ()

{
    __weak IBOutlet UITextField *_textFiled;
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;
@end

@implementation ResetNickNameVC

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
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    _textFiled.text = account.nickname;
    _textFiled.layer.cornerRadius = 5;
    _textFiled.clipsToBounds = YES;
    
    
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
    
    self.navigationItem.title = @"设置昵称";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [_textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmResetNickNameButtonClick:(UIButton *)sender
{
    NSString *newNickNameStr = _textFiled.text;
    [_textFiled resignFirstResponder];
    [self updateNickName:newNickNameStr];
}

- (void)updateNickName:(NSString *)nameString
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.userId,@"birthday":account.birthday,@"nickname":nameString,@"sex":account.sex,@"minename":account.realName,@"headimg":account.headimg};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    hud.label.text = @"修改中";
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             //网络更新成功后 修改数据库 数据
             //修改单例账户类数据
             //更新界面
             account.nickname = nameString;
             [account storeAccountInfo];
             
             [self leftBtnAction];
         }
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
