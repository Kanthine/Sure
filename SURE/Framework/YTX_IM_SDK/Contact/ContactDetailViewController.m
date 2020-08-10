//
//  ContactDetailViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "UIImage+Extend.h"
#import "ChatViewController.h"


extern NSString * Notification_ChangeMainDisplay;


@interface ContactDetailViewController ()
<UIActionSheetDelegate>

{
    __weak IBOutlet UILabel *_nickNameLable;
    __weak IBOutlet UILabel *_sureNameLable;
    
    
    __weak IBOutlet UIImageView *_headerImageView;
}

@end

@implementation ContactDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _headerImageView.layer.cornerRadius = 40;
    _headerImageView.clipsToBounds = YES;
    [self customNavBar];
    [self updateContactLinkerInfo];
}

- (void)customNavBar
{
    self.title = @"个人中心";
    self.navigationItem.titleView = nil;
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateContactLinkerInfo
{
    _nickNameLable.text = [NSString stringWithFormat:@"昵称:%@",_dict[nameKey]];
    _sureNameLable.text = _dict[phoneKey];

//    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_dict[imageKey]]];
}

- (IBAction)sendMessageButtonClick:(UIButton *)sender
{
    
    __block BOOL isPop = NO;
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        
         if ([obj isKindOfClass:NSClassFromString(@"ChatViewController")])
         {
             [self.navigationController popToViewController:obj animated:YES];
             isPop = YES;
             * stop = YES;
         }
         
    }];
    
    
    if (isPop == NO)
    {
        ChatViewController *chatVC = [[ChatViewController alloc]initWithSessionId:_dict[phoneKey]];
        chatVC.sessionId = _dict[phoneKey];
        [self.navigationController pushViewController:chatVC animated:YES];

    }
    

}


@end
