//
//  BindedMobilePhoneVC.m
//  SURE
//
//  Created by 王玉龙 on 17/1/5.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "BindedMobilePhoneVC.h"

#import "LoginHttpManager.h"


@interface BindedMobilePhoneVC ()



@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLable;

@property (weak, nonatomic) IBOutlet UIButton *bindButton;

@property (nonatomic ,strong) LoginHttpManager *httpManager;

@end

@implementation BindedMobilePhoneVC

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
    
    self.bindButton.layer.cornerRadius = 3;
    self.bindButton.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = 40;
    self.headerImageView.clipsToBounds = YES;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.headerURLStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.mobileLable.text = self.phoneStr;
    
    
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
    
    
    self.navigationItem.title = @"绑定手机号";
}

- (void)leftItemButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)bindMobilePhoneButtonclick:(UIButton *)sender
{
    NSDictionary *dict = @{@"user_id":self.userIDStr,@"mobile_phone":self.phoneStr,@"salt":self.verificationCodeString};
    
    [self.httpManager bindingMobilePhoneWithParameterDict:dict CompletionBlock:^(AccountInfo *user, NSError *error)
    {
        if (error)
        {
            
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BindMobilePhoneSuccess" object:nil userInfo:@{@"user":user}];
        }
    }];
}

@end
