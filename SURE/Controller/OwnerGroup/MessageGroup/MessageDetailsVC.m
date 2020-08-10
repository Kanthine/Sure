//
//  MessageDetailsVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "MessageDetailsVC.h"

@interface MessageDetailsVC ()

{
    NSDictionary *_userInfo;
}

@property (nonatomic ,strong) UILabel *textLable;

@end

@implementation MessageDetailsVC

- (instancetype)initWithInfo:(NSDictionary *)userInfo
{
    self = [super init];
    
    if (self)
    {
        _userInfo = userInfo;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GrayAreaColor;
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
    
    self.navigationItem.title = @"消息详情";
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)textLable
{
    if (_textLable == nil)
    {
        _textLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 90)];
        _textLable.backgroundColor = [UIColor whiteColor];
        _textLable.font = [UIFont systemFontOfSize:15];
        _textLable.text = [[_userInfo objectForKey:@"aps"] objectForKey:@"ewags"];
    }
    
    return _textLable;
}

@end
/*
 推送消息 =========
 {
     "" = "";
     aps =
     {
     alert = ewags;
     badge = 34;
     sound = default;
 };
 }
 */
