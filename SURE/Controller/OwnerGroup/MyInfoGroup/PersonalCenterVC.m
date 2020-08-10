//
//  PersonalCenterVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"PersonalCenterCell"
#define CellIdentifer_Header @"PersonalCenterCellHeader"

#import "PersonalCenterVC.h"

#import "ResetNickNameVC.h"
#import "DatePickerView.h"
#import "AddressManagerVC.h"
#import "MySignatureVC.h"

#import "QNManager.h"

#import "WaveProgressView.h"

#import "MyHeaderBackImageVC.h"

#import "AlbumPhotoViewController.h"
#import "AlbumLibraryViewController.h"

#import "UserInfoHttpManager.h"

@interface PersonalCenterVC ()

<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic ,strong) NSArray *mainTitleArray;
@property (nonatomic ,strong) NSArray *detaileTitleArray;
@property (nonatomic ,strong) UIImageView *headerImageView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UserInfoHttpManager *httpManager;
@end

@implementation PersonalCenterVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 55;
        [_tableView setTableFooterView:[UIView new]];
    }
    
    return _tableView;
}


- (NSArray *)mainTitleArray
{
    if (_mainTitleArray == nil)
    {
        _mainTitleArray = @[@"头像",@"昵称",@"性别",@"生日",@"收货地址",@"手机号",@"个性签名",@"更改背景"];
    }
    
    return _mainTitleArray;
}

- (NSArray *)detaileTitleArray
{
    if (_detaileTitleArray == nil)
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        _detaileTitleArray = @[account.headimg,account.nickname, [self getSexWithSex:account.sex],account.birthday,account.address,account.mobilePhone,account.realName,@""];
    }
    
    return _detaileTitleArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCropImageSuccessClick:) name:@"myCropHeaderImageSuccess" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
    [self customNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"个人资料";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)headerImageView
{
    if (_headerImageView == nil)
    {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 40 - 30, 7, 40, 40)];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headerImageView.layer.cornerRadius = 20;
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = indexPath.row == 0 ? CellIdentifer_Header : CellIdentifer;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        if (indexPath.row == 0)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer_Header];
            
            
            
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.detaileTitleArray[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [cell.contentView addSubview:self.headerImageView];
        }
        else
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = TextColor149;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = TextColorBlack;
    cell.detailTextLabel.numberOfLines = 2;

    
    
    if (indexPath.row == 0 && [self.detaileTitleArray[0] isKindOfClass:[UIImage class]])
    {
        self.headerImageView.image = self.detaileTitleArray[0];
    }
    else if (indexPath.row == 0 && [self.detaileTitleArray[0] isKindOfClass:[NSString class]])
    {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.detaileTitleArray[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    else
    {
        cell.detailTextLabel.text = self.detaileTitleArray[indexPath.row];
    }
    cell.textLabel.text = self.mainTitleArray[indexPath.row];
    
    
    
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [self updateHeaderImage];
        }
            break;
        case 1:
        {
            [self updateNickName];
        }
            break;
        case 2:
        {
            [self updatePersonalSex];
        }
            break;
        case 3:
        {
            [self updateBirthday];
        }
            break;
        case 4:
        {
            [self updateShippingAddress];
        }
            break;
        case 5:
        {
            [self updatePhoneNumber];
        }
            break;
        case 6:
        {
            [self updatePersonalizedSignature];
        }
            break;
        case 7:
        {
            [self updatePersonalBackImage];
        }
            break;

        default:
            break;
    }
    
}

#pragma mark - 修改头像

- (void)updateHeaderImage
{
    __weak __typeof__(self) weakSelf = self;

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
      {
          AlbumPhotoViewController *album = [[AlbumPhotoViewController alloc]init];
          album.cropSize = CGSizeMake(ScreenWidth, ScreenWidth);
          UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:album];
          nav.navigationBarHidden = YES;
          [weakSelf presentViewController:nav animated:YES completion:nil];
      }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        AlbumLibraryViewController *album = [[AlbumLibraryViewController alloc]init];
        album.cropSize = CGSizeMake(ScreenWidth, ScreenWidth);
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:album];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:libraryAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


- (void)myCropImageSuccessClick:(NSNotification *)notification
{
    UIImage *image = notification.userInfo[@"image"];
    
    
    __block WaveProgressView *waveProgress  = [[WaveProgressView alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0 - 40, 200, 80, 80)];
    waveProgress.isShowWave = YES;
    [self.view addSubview:waveProgress];
    [QNManager updateLoadImage:image ProgressBlock:^(float progress)
     {
         waveProgress.percent = progress;
         waveProgress.centerLabel.text = [NSString stringWithFormat:@"%.02f%%",progress];
         
         if (progress >= 1)
         {
             [waveProgress removeFromSuperview];
             
         }
         
     } CompletionBlock:^(NSString *urlString, BOOL isSucceed)
     {
         if (isSucceed)
         {
             [self updatePersonalHeader:urlString];
         }
         
     }];


}

- (void)updatePersonalHeader:(NSString *)urlString
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    NSDictionary *dict = @{@"user_id":account.userId,@"birthday":account.birthday,@"nickname":account.nickname,@"sex":account.sex,@"minename":account.realName,@"headimg":urlString};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = @"设置中...";
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             //网络更新成功后 修改数据库 数据
             //修改单例账户类数据
             //更新界面
             account.headimg = urlString;
             [account storeAccountInfo];
             
             
             
             _detaileTitleArray = @[account.headimg,account.nickname, [self getSexWithSex:account.sex],account.birthday,account.address,account.mobilePhone,account.realName,@""];
             [_tableView reloadData];
             
         }
     }];
    
}

#pragma mark - 修改昵称

- (void)updateNickName
{
    ResetNickNameVC *nickVC = [[ResetNickNameVC alloc]init];
    
    
    [self.navigationController pushViewController:nickVC animated:YES];
}

#pragma mark - 修改 性别

- (void)updatePersonalSex
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        
    }];
    

    UIAlertAction *securityAction = [UIAlertAction actionWithTitle:@"保密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self updatePersonalSexWithNewSex:@"0"];
    }];
    
    UIAlertAction *boyAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
     {
        [self updatePersonalSexWithNewSex:@"1"];
     }];
    
    UIAlertAction *girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
     {
         [self updatePersonalSexWithNewSex:@"2"];
     }];

    [actionSheet addAction:cancelAction];
    [actionSheet addAction:securityAction];
    [actionSheet addAction:boyAction];
    [actionSheet addAction:girlAction];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)updatePersonalSexWithNewSex:(NSString *)sexString
{
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
    
    NSDictionary *dict = @{@"user_id":account.userId,@"birthday":account.birthday,@"nickname":account.nickname,@"sex":sexString,@"minename":account.realName,@"headimg":account.headimg};
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = @"修改中";
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             //网络更新成功后 修改数据库 数据
             //修改单例账户类数据
             //更新界面
             account.sex = sexString;
             [account storeAccountInfo];
             
             _detaileTitleArray = @[account.headimg,account.nickname, [self getSexWithSex:account.sex],account.birthday,account.address,account.mobilePhone,account.realName,@""];
             [_tableView reloadData];

         }
     }];
    
}

- (NSString *)getSexWithSex:(NSString *)sex
{
    if ([sex isEqualToString:@"0"])
    {
        return @"保密";
    }
    else if ([sex isEqualToString:@"1"])
    {
        return @"男";
    }
    else
    {
        return @"女";
    }
}

#pragma mark - 修改 生日

- (void)updateBirthday
{
    AccountInfo *account = [AccountInfo standardAccountInfo];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:account.birthday];

    
    
    DatePickerView *datePicker = [[DatePickerView alloc] init];
    datePicker.datePickerType = DatePickerLocationTypeCenter;
    datePicker.maxSelectDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.currentDate = currentDate; // 日期一定要设置
    __weak typeof(self) weakSelf = self;
    [datePicker didFinishSelectedDate:^(NSDate *selectedDate)
     {
        [weakSelf confirmDateButtonClickWithDate:selectedDate];
    }];
    [datePicker show];
}

- (void)confirmDateButtonClickWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];

    NSDictionary *dict = @{@"user_id":account.userId,@"birthday":currentDateStr,@"nickname":account.nickname,@"sex":account.sex,@"minename":account.realName,@"headimg":account.headimg};
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"修改中";
    [self.httpManager updatePersonalInfoParameterDict:dict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             //网络更新成功后 修改数据库 数据
             //修改单例账户类数据
             //更新界面
             account.birthday = currentDateStr;
             [account storeAccountInfo];
             
             _detaileTitleArray = @[account.headimg,account.nickname, [self getSexWithSex:account.sex],account.birthday,account.address,account.mobilePhone,account.realName,@""];
             [_tableView reloadData];
             
         }
     }];

    

    NSLog(@"currentDateStr ====== %@",currentDateStr);
}

#pragma mark - 收货地址

- (void)updateShippingAddress
{
    AddressManagerVC *managerVC = [[AddressManagerVC alloc]init];
    [managerVC requestNetworkGetData];
    [self.navigationController pushViewController:managerVC animated:YES];
}

#pragma mark - 电话号码

- (void)updatePhoneNumber
{
    
}


#pragma mark - 个性签名

- (void)updatePersonalizedSignature
{
    MySignatureVC *signatureVC = [[MySignatureVC alloc]init];
    [self.navigationController pushViewController:signatureVC animated:YES];
}

#pragma mark - 修改个人主页背景

- (void)updatePersonalBackImage
{
    MyHeaderBackImageVC *backImageVC = [[MyHeaderBackImageVC alloc]init];
    [self.navigationController pushViewController:backImageVC animated:YES];
}


@end
