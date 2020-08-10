//
//  SureCoinDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/28.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellIdentifer @"SureCoinDetaileTableCell"

#import "SureCoinDetaileVC.h"

#import "SureCoinDetaileTableCell.h"

@interface SureCoinDetaileVC ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIView *tableHeaderView;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *listArray;

@end

@implementation SureCoinDetaileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    self.navigationItem.title = @"SURE币明细";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightNavBarButton.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    [rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Question"] forState:UIControlStateNormal];
    [rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    
}


- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil)
    {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 54)];

        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        leftLable.text = @"您目前拥有SURE币：";
        leftLable.textColor = TextColorBlack;
        leftLable.font = [UIFont systemFontOfSize:14];
        CGFloat lableWidth = [leftLable.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : leftLable.font} context:nil].size.width;
        leftLable.frame = CGRectMake(10, 0, lableWidth + 3, 44);
        [_tableHeaderView addSubview:leftLable];
        
        
        UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), 0, 100, 44)];
        contentLable.text = @"120";
        contentLable.textColor = [UIColor redColor];
        contentLable.font = [UIFont systemFontOfSize:14];
        [_tableHeaderView addSubview:contentLable];
        
        
        UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 10)];
        grayLable.backgroundColor = RGBA(239, 239, 244, 1);
        [_tableHeaderView addSubview:grayLable];
    }
    
    return _tableHeaderView;
}


- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 63;
        [_tableView registerNib:[UINib nibWithNibName:@"SureCoinDetaileTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SureCoinDetaileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
