//
//  ChooseLableViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/14.
//  Copyright © 2016年 longlong. All rights reserved.
//

#import "ChooseLableViewController.h"

@interface ChooseLableViewController ()
<UITableViewDelegate ,UITableViewDataSource>
{
    NSMutableArray *_titleArray;
    UITableView *_tableView;
}
@end

@implementation ChooseLableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _titleArray = [NSMutableArray array];
    
    for (int i = 0; i < 30; i ++)
    {
        [_titleArray addObject:[NSString stringWithFormat:@"第  %d  行",i]];
    }
    
    [self setHeaderView];
    [self  setTableView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 0, 90, 45);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton addTarget:self action:@selector(dismissCurrentViewClick) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"上一步" forState:UIControlStateNormal];
    [leftButton setTitleColor:TextColor149 forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:leftButton];
    
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame = CGRectMake(0, 0, 150, 45);
    titleButton.center = headerView.center;
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.userInteractionEnabled = NO;
    [titleButton setTitle:@"选择标签链接" forState:UIControlStateNormal];
    [titleButton setTitleColor:RGBA(51, 51, 51,1) forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:titleButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWidth - 55, 0, 45, 45);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(rightButtonSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBA(143, 6, 206,1) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    [rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [headerView addSubview:rightButton];
    
    
    UILabel *grayLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 1)];
    grayLable.backgroundColor = GrayColor;
    [headerView addSubview:grayLable];
    
}

- (void)rightButtonSearchClick
{
    
}

#pragma mark - UITableView

- (void)setTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 45) style:UITableViewStylePlain];
    _tableView.rowHeight = 50;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *titleString = _titleArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSignWithSign:)])
    {
        [self.delegate selectedSignWithSign:titleString];
    }
    [self dismissCurrentViewClick];
}

- (void)dismissCurrentViewClick
{
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
