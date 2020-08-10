//
//  LookLogisticsVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/29.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"LogisticsCell"


#import "LookLogisticsVC.h"

#import "LogisticsHeaderView.h"

#import "LogisticsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface LookLogisticsVC ()

<UITableViewDelegate,UITableViewDataSource>

{
    UIButton *_messageBarButton;
}

@property (nonatomic ,strong) LogisticsHeaderView *tableHeaderView;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation LookLogisticsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self customNavBar];
    

    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"查看物流";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _messageBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message"] forState:UIControlStateNormal];
    [_messageBarButton setImage:[UIImage imageNamed:@"owner_Message_Pressed"] forState:UIControlStateHighlighted];
    [_messageBarButton addTarget:self action:@selector(navBar_MessageButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_messageBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navBar_MessageButtonEditClick:(UIButton *)button
{
    
}

- (LogisticsHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"LogisticsHeaderView" owner:nil options:nil][0];
    }
    
    return _tableHeaderView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[LogisticsCell class] forCellReuseIdentifier:CellIdentifer];

        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
    {
        cell = (LogisticsCell *)cell;
        [self congifCell:cell indexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 63, 20)];
    lable.text = @"运单编号:";
    lable.textColor = TextColor149;
    lable.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:lable];
    
    
    UILabel *snLable = [[UILabel alloc]initWithFrame:CGRectMake(73, 10, ScreenWidth - 110, 20)];
    snLable.text = @"198753490";
    snLable.textColor = TextColorBlack;
    snLable.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:snLable];
    
    
    UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
    grayLable.backgroundColor = GrayColor;
    [headerView addSubview:grayLable];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    [self congifCell:cell indexPath:indexPath];
    return cell;
}

- (void)congifCell:(LogisticsCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        cell.linkLable.textColor = TextColorPurple;
        cell.timeLable.textColor = TextColorPurple;
        cell.middleLineView.hidden = YES;
        cell.currentLineView.hidden = NO;
        
    }
    else
    {
        cell.linkLable.textColor = TextColor149;
        cell.timeLable.textColor = TextColor149;
        cell.middleLineView.hidden = NO;
        cell.currentLineView.hidden = YES;
    }
    
    
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.linkLable.text = [dict objectForKey:@"text"];
    [cell.linkLable sizeToFit];
    cell.timeLable.text = [dict objectForKey:@"time"];


    
    cell.linkLable.linkTapHandler = ^(KZLinkType linkType, NSString *string, NSRange range)
    {
        if (linkType == KZLinkTypeURL)
        {
            //[self openURL:[NSURL URLWithString:string]];
        }
        else if (linkType == KZLinkTypePhoneNumber)
        {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
            //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4006668800"]];
        }
        else
        {
            NSLog(@"Other Link");
        }
    };

}



- (NSArray *)dataArray
{
    if (_dataArray == nil)
    {
        NSDictionary *dict1 = @{@"text":@"[上海市]已签收，感谢使用顺丰，期待再次为您服务，感谢使用顺丰速运，祝您生活愉快！",@"time":@"2016-11-27 10:48:00"};
        NSDictionary *dict2 = @{@"text":@"[上海市]上海虹口通州营业部派件员：顺丰速运15921215085正在为您派件",@"time":@"2016-11-27 07:29:00"};
        NSDictionary *dict3 = @{@"text":@"[上海市]上海虹桥集散中心2 已发出",@"time":@"2016-11-27 03:59:00"};
        NSDictionary *dict4 = @{@"text":@"[上海市]上海虹桥集散中心 已发出",@"time":@"2016-11-26 14:21:00"};
        NSDictionary *dict5 = @{@"text":@"快件在【西安高陵集散中心】已装车，准备发往【西安总集散中心】",@"time":@"2016-11-26 00:11:00"};
        NSDictionary *dict6 = @{@"text":@"快件在【西安总集散中心】已装车，准备发往【上海虹桥集散中心】",@"time":@"2016-11-26 02:16:00"};

        _dataArray = @[dict1,dict2,dict3,dict4,dict5,dict6];
        
    }
    
    
    return _dataArray;
}

@end
