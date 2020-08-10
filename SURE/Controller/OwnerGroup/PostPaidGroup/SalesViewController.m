//
//  SalesViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/12/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CellIdentifer @"SalesTableViewCell"
#define HeaderIdentifer @"SalesTableSectionHeaderView"


#import "SalesViewController.h"
#import "SalesTableViewCell.h"
#import "SalesTableSectionHeaderView.h"
#import "BuyerOrderDetaileVC.h"

typedef NS_ENUM(NSUInteger, SalesViewType)
{
    SalesViewTypeNormal = 0,
    SalesViewTypeSearch,
};

@interface SalesViewController ()
<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *searchResultArray;

@property (nonatomic ,assign) SalesViewType searchType;

@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SalesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _searchType = SalesViewTypeNormal;
    
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellReuseIdentifier:CellIdentifer];
    [_tableView registerClass:[SalesTableSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HeaderIdentifer];
    
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
    
    self.navigationItem.title = @"销售额";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setSearchType:(SalesViewType)searchType
{
    _searchType = searchType;
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchType == SalesViewTypeNormal)
    {
        return self.dataArray.count;
    }
    else
    {
        return self.searchResultArray.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SalesTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifer];
    
    NSDictionary *dict = nil;
    if (_searchType == SalesViewTypeNormal)
    {
        dict = _dataArray[section];
    }
    else
    {
        dict = _searchResultArray[section];
    }

    
    headerView.orderNumberLable.text = [dict objectForKey:@"ordersn"];
    headerView.orderTimeLable.text = [dict objectForKey:@"time"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    NSDictionary *dict = nil;
    if (_searchType == SalesViewTypeNormal)
    {
        dict = _dataArray[indexPath.row];
    }
    else
    {
        dict = _searchResultArray[indexPath.row];
    }
    
    [cell refreshCellData:dict];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyerOrderDetaileVC *buyerVC = [[BuyerOrderDetaileVC alloc]initWithNibName:@"BuyerOrderDetaileVC" bundle:nil];
    [self.navigationController pushViewController:buyerVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFiled resignFirstResponder];
    self.searchType = SalesViewTypeNormal;
}

- (IBAction)searchButtonClick:(UIButton *)sender
{
    /*
     谓词检索订单号 ID号
     @"name CONTAIN[cd] 'ang'" //包含某个字符串
     @"name BEGINSWITH[c] 'sh'" //以某个字符串开头
     @"name ENDSWITH[d] 'ang'" //以某个字符串结束
     */
    
    self.searchType = SalesViewTypeSearch;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ordersn BEGINSWITH[cd] %@ OR ID BEGINSWITH[cd] %@",_textFiled.text,_textFiled.text];
    NSArray *array = [self.dataArray filteredArrayUsingPredicate:predicate];

    [self.searchResultArray removeAllObjects];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSLog(@"predicate ====== %@",obj);
        [self.searchResultArray addObject:obj];
        
    }];
    
    [self.tableView reloadData];
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        
        
        for (int i = 0; i < 10; i ++)
        {
            NSString *priceStr = [NSString stringWithFormat:@"%d",arc4random() % 400 + 30];
            NSString *idStr =  [NSString stringWithFormat:@"%d",123456 * (i + 1)];
            NSString *orderSn = [NSString stringWithFormat:@"%d",123456789 * (i + 2)];
            
            NSDictionary *dict = @{@"ordersn":orderSn,@"time":[self createCurrentTime],@"price":priceStr, @"ID":idStr, @"status":@"已收货"};
            [_dataArray addObject:dict];
        }
    }
    
    return _dataArray;
}

- (NSMutableArray *)searchResultArray
{
    if (_searchResultArray == nil)
    {
        _searchResultArray = [NSMutableArray array];
    }
    
    return _searchResultArray;
}

- (NSString*)createCurrentTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];
    
    return [formatter stringFromDate:datenow];;
}


@end
