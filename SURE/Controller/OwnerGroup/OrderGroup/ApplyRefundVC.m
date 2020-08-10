//
//  ApplyRefundVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/17.
//  Copyright © 2017年 longlong. All rights reserved.
//

#define CellCommodityIdentifer @"ApplyRefundCommodityTableCell"
#define CellApplyIdentifer @"ApplyRefundTableCell"


#import "ApplyRefundVC.h"

#import "ApplyRefundCommodityTableCell.h"
#import "ApplyRefundTableCell.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "RefundReasonView.h"

@interface ApplyRefundVC ()
<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    NSString *_reasonString;
    CGFloat _newHeight;
    
    
}

@property (nonatomic ,strong) NSMutableArray *photoArray;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) UIButton *confirmButton;

@end

@implementation ApplyRefundVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavBar];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.confirmButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"申请退款";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;

}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)photoArray
{
    if (_photoArray == nil)
    {
        _photoArray = [NSMutableArray array];
    }
    
    return _photoArray;
}

- (NSMutableArray<OrderProductModel *> *)modelArray
{
    if (_modelArray == nil)
    {
        _modelArray = [NSMutableArray array];
    }
    
    return _modelArray;
}

- (UIButton *)confirmButton
{
    if (_confirmButton == nil)
    {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, ScreenHeight - 64 - 49, ScreenWidth, 49);
        _confirmButton.backgroundColor = [UIColor redColor];
        [_confirmButton setTitle:@"提 交" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _confirmButton;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        [_tableView registerClass:[ApplyRefundCommodityTableCell class] forCellReuseIdentifier:CellCommodityIdentifer];
        [_tableView registerClass:[ApplyRefundTableCell class] forCellReuseIdentifier:CellApplyIdentifer];
    }
    
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.modelArray.count;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60.0;
    }
    
    
    CGFloat height = 195.0 + (ScreenWidth - 50) / 4.0;
    
    if (_newHeight > height)
    {
        height  = _newHeight;
    }
        
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        ApplyRefundCommodityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellCommodityIdentifer forIndexPath:indexPath];
        
        OrderProductModel *model = _modelArray[indexPath.row];
        
        cell.nameLable.text = model.goodsName;
        
        
        
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@",ImageUrl,model.goodsImg];

        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        return cell;
    }
    
    
    ApplyRefundTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellApplyIdentifer forIndexPath:indexPath];
    [cell.reasonButton addTarget:self action:@selector(reasonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.currentViewController = self;
    cell.refundPriceLable.text = [self getRefundPrice];
    [cell updatePhotoContentViewWithArray:self.photoArray];
    cell.applyRefundStateTextViewShowClick = ^(CGFloat height)
    {
        _newHeight = height;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    };

    cell.applyRefundAddPhotoButtonClick = ^()
    {
        [self applyRefundAddPhotoClick];
    };

    return cell;
}

- (void)reasonButtonClick:(UIButton *)sender
{
    
    NSLog(@"%@",sender.titleLabel.text);
    
    RefundReasonView *reasonView = [[RefundReasonView alloc] initWithReasonStr:sender.titleLabel.text];
    reasonView.currentReasonStr = sender.titleLabel.text;
    reasonView.refundReasonViewConfirmButtonClick = ^(NSString *reasonString)
    {
        [sender setTitle:reasonString forState:UIControlStateNormal];
    };

    [reasonView show];

}

- (NSString *)getRefundPrice
{
    __block CGFloat price = 0.0;
    
    [_modelArray enumerateObjectsUsingBlock:^(OrderProductModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
         price = price + [obj.goodsPrice floatValue];
    }];
    
    
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
    
    return priceStr;
}

#pragma mark -

- (void)applyRefundAddPhotoClick
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof__(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [weakSelf presentPhotoResourceViewControllerWithIndex:0];
                                    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [weakSelf presentPhotoResourceViewControllerWithIndex:1];
                                      
                                  }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:photoAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)presentPhotoResourceViewControllerWithIndex:(NSInteger)index
{
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

    if (index == 0)
    {
        //图库
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else
    {
        //相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.photoArray addObject:image];
    
    NSIndexPath *indexp = [NSIndexPath indexPathForRow:0 inSection:1];
    
    ApplyRefundTableCell *cell = [self.tableView cellForRowAtIndexPath:indexp];
    [cell updatePhotoContentViewWithArray:self.photoArray];
}




@end
