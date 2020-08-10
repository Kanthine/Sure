//
//  MessageCenterVC.m
//  SURE
//
//  Created by 王玉龙 on 16/12/27.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIndetifer @"MessageCenterTableCell"

#import "MessageCenterVC.h"

#import "MessageCenterTableCell.h"

@interface MessageCenterVC ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation MessageCenterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
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
    
    self.navigationItem.title = @"消息中心";
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource= self;
        _tableView.delegate = self;
        _tableView.rowHeight = 70;
        [_tableView registerClass:[MessageCenterTableCell class] forCellReuseIdentifier:CellIndetifer];
    }
    
    return _tableView;
}


#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCenterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifer];
    [cell updateMessageCenterTableCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
