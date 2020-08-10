//
//  SureDetaileViewController.m
//  SURE
//
//  Created by 王玉龙 on 17/1/5.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "SureDetaileViewController.h"
#import "SureMainTableCell.h"
#import "ShareViewController.h"
#import "SingleProductDetaileVC.h"
#import "TapSupportDetaileVC.h"

@interface SureDetaileViewController ()



@property (nonatomic ,strong) SUREModel *sureModel;
@property (nonatomic ,strong) SureMainTableCell *tableCell;

@end

@implementation SureDetaileViewController

- (instancetype)initWithModel:(SUREModel *)sureModel
{
    self = [super init];
    
    if (self)
    {
        _sureModel = sureModel;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableCell];
    [self.tableCell updateSureMainCellDataWithModel:_sureModel];
    [self.tableCell updateTapViewWithTapModel:_sureModel.tapModel];

    
    self.navigationItem.title = [NSString stringWithFormat:@"%@的SURE",_sureModel.sureName];
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    CGFloat height = [self.tableCell.statusLable.text boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.tableCell.statusLable.font} context:nil].size.height;
    self.tableCell.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth + 105 + height);
    
}

- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SureMainTableCell *)tableCell
{
    if (_tableCell == nil)
    {
        _tableCell = [[SureMainTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        _tableCell.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth + 125);
        
        
        _tableCell.currentViewController = self;
                
        
        
    }
    
    return _tableCell;
}



@end
