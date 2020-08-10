//
//  PersonalSetVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"PersonalSetCell"
#define CellIdentifer_Header @"PersonalSetCellHeader"

#import "PersonalSetVC.h"

#import <StoreKit/StoreKit.h>


#import "CustomSwitch.h"

#import "MySelfInfoVC.h"

#import "ClearProgressView.h"

@interface PersonalSetVC ()
<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>

{
    NSArray *_titleArray;
    
    
    ClearProgressView *_clearProgress;
    
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic ,strong) UIView *footerView;

@end

@implementation PersonalSetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _titleArray = @[@"接受通知",@"用户反馈",@"清除图片缓存",@"省流量流畅版",@"给我们评价",@"关于我们",@"APP版本"];
    self.footerView.frame = CGRectMake(0, 1, ScreenWidth, 150);
    _tableView.tableFooterView = self.footerView;
    
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
    
    self.navigationItem.title = @"设置";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)footerView
{
    if (_footerView == nil)
    {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView =  UIView.new;
        lineView.frame = CGRectMake(15, 0, ScreenWidth, 0.5);
        lineView.backgroundColor = RGBA(200, 199, 204, 1);
        [_footerView  addSubview:lineView];
        
//        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareButton.frame = CGRectMake(50, 25, ScreenWidth - 100, 40);
//        shareButton.backgroundColor = RGBA(226, 100, 200,1);
//        shareButton.layer.cornerRadius = 20;
//        shareButton.clipsToBounds = YES;
//        [shareButton setTitle:@"推荐朋友使用SURE" forState:UIControlStateNormal];
//        shareButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_footerView addSubview:shareButton];
        
        
        
        UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logOutButton.frame = CGRectMake(20,15, ScreenWidth - 40, 40);
        logOutButton.backgroundColor = [UIColor redColor];
        logOutButton.layer.cornerRadius = 5;
        logOutButton.clipsToBounds = YES;
        [logOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        logOutButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logOutButton addTarget:self action:@selector(logOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:logOutButton];
        
        if ([AuthorizationManager isAuthorization] == NO)
        {
            logOutButton.hidden = YES;
            logOutButton.userInteractionEnabled = NO;
        }
                
    }
    
    return _footerView;
}

- (void)logOutButtonClick:(UIButton *)button
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    if ([account logoutAccount])
    {
        button.backgroundColor = [UIColor lightGrayColor];
        button.userInteractionEnabled = NO;
        
        
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"账户已退出" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
               [self leftBtnAction];
        }];
        
        [alertView addAction:cancelAction];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = (indexPath.row == 0 || indexPath.row == 3) ? CellIdentifer_Header : CellIdentifer;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        
        if (indexPath.row == 0 || indexPath.row == 3)
        {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer_Header];
            
            

            
            CustomSwitch *switchUI = [[CustomSwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 10, 50, 30)];
            switchUI.on = indexPath.row == 0 ? YES : NO;
            switchUI.onColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
            
            [cell.contentView addSubview:switchUI];
            
            

        }
        else
        {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
            
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TextColorBlack;
    cell.textLabel.text = _titleArray[indexPath.row];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = TextColorBlack;
    
    if (indexPath.row == 2)
    {
        //图片缓存
        cell.detailTextLabel.text = [self getSDWebImageCache];
    }
    else if (indexPath.row == 6)
    {
        cell.detailTextLabel.text = [self getAppVersion];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
//            [self updateHeaderImage];
        }
            break;
        case 1:
        {
//            [self updateNickName];
        }
            break;
        case 2:
        {
            [self  clearDiskClickWithIndexPath:indexPath];
        }
            break;
        case 3:
        {
//            [self updateBirthday];
        }
            break;
        case 4:
        {
            [self evaluateApp];
        }
            break;
        case 5:
        {
            [self lookAppInfo];
        }
            break;
        case 6:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)clearDiskClickWithIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    
    if (_clearProgress == nil)
    {
        _clearProgress = [[ClearProgressView alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 23 , 2, 45, 45)];
        _clearProgress.progressColors = @[[UIColor redColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor]];
        [cell.contentView addSubview:_clearProgress];
        [_clearProgress addNotificationObserver];
        
        __block UIImageView *sureImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 2.0 - 23, 2, 30, 30)];
        sureImage.contentMode = UIViewContentModeScaleAspectFit;
        sureImage.center = _clearProgress.center;
        sureImage.image = [UIImage imageNamed:@"text_Sure_Gray"];
        [cell.contentView addSubview:sureImage];
        
        

        
        
        SDImageCache *cache = [SDImageCache sharedImageCache];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
       {
           //清除缓存
           [cache clearDiskOnCompletion:^
            {
                //延迟4秒
                [self performSelector:@selector(updateCacheCell:) withObject:sureImage afterDelay:4];

            }];
       });

    }
}

- (void)updateCacheCell:(UIImageView *)sureImage
{
    [sureImage removeFromSuperview];
    sureImage = nil;
    
    [_clearProgress removeFromSuperview];
    _clearProgress = nil;
    
    [_tableView reloadData];
}


- (void)lookAppInfo
{
    MySelfInfoVC *appInfoVC = [[MySelfInfoVC alloc]init];
    [self.navigationController pushViewController:appInfoVC animated:YES];
}

- (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)getSDWebImageCache
{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheCount = cache.getSize;
    
    NSString *resultCount = [self fileSizeWithInterge:cacheCount];
    
    
    return resultCount;
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size
{
    // 1k = 1024, 1m = 1024k
    if (size < 1024)
    {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024)
    {// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024)
    {// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.2fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.2fG",aFloat];
    }
}


- (void)evaluateApp
{
    /*
     跳转到AppStore评分,有两种方法：
     
     一种是跳出应用,跳转到AppStore,进行评分；
     
     另一种是在应用内,内置AppStore进行评分。
     */
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppID]];
    
    //    return;
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"444934666"} completionBlock:^(BOOL result, NSError *error)
     {
         if(error)
         {
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }
         else
         {
             // 模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:nil];
         }
     }];
    //
}

//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
