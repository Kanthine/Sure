//
//  MySignatureVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/18.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define MAX_INPUT_LENGTH 200

#import "MySignatureVC.h"

#import "UserInfoHttpManager.h"

@interface MySignatureVC ()
<UITextViewDelegate>
{
    UIButton *_saveNavBarButton;
    
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *_placeholderLable;
    
    __weak IBOutlet UILabel *_lenthLable;
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@end

@implementation MySignatureVC

- (void)dealloc
{
    self.httpManager = nil;
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
    _textView.text = account.realName;
    _textView.layer.cornerRadius = 5;
    _textView.clipsToBounds = YES;
    
    
    if (_textView.text.length > 0)
    {
        _placeholderLable.hidden = YES;
    }
    else
    {
        _placeholderLable.hidden = NO;
    }
    
    
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
    
    self.navigationItem.title = @"编辑个性签名";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _saveNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [_saveNavBarButton setTitle:@"完成" forState:UIControlStateNormal];
    [_saveNavBarButton addTarget:self action:@selector(saveNavBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:_saveNavBarButton];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)leftBtnAction
{
    [_textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveNavBarButtonClick
{
    NSString *newRealNameStr = _textView.text;
    [_textView resignFirstResponder];
    [self updateNickName:newRealNameStr];
}

- (void)updateNickName:(NSString *)nameString
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.userId,@"birthday":account.birthday,@"nickname":account.nickname,@"sex":account.sex,@"minename":nameString,@"headimg":account.headimg};
    
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
             account.realName = nameString;
             [account storeAccountInfo];
             
             [self leftBtnAction];
         }
     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
    
    _lenthLable.text = [NSString stringWithFormat:@"%ld/200",_textView.text.length];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textView.text.length == 0)
    {
        _placeholderLable.hidden = NO;
    }
    else
    {
        _placeholderLable.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0)
    {
        //删除字符肯定是安全的
        return YES;
    }
    else
    {
        if (textView.text.length - range.length + text.length > MAX_INPUT_LENGTH)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}



@end
