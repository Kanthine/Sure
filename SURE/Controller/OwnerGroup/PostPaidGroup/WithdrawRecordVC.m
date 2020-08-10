//
//  WithdrawRecordVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/8.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"WithdrawRecordCell"

#import "WithdrawRecordVC.h"
#import "WithdrawRecordCell.h"

@interface WithdrawRecordVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WithdrawRecordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellReuseIdentifier:CellIdentifer];
    _tableView.hidden = YES;
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
    
    self.navigationItem.title = @"提现记录";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    
    headerView.backgroundColor = GrayLineColor;
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 30)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textColor = TextColor149;
    [headerView addSubview:titleLable];
    
    titleLable.text = [NSString stringWithFormat:@"2016年%ld月",section+1];
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    
    
    return cell;
}

@end
