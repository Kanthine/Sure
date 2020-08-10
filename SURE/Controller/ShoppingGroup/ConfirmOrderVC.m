//
//  ConfirmOrderVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/21.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"ConfirmOrderCell"
#define CellIdentifer_Address @"AddressCell"




#import "ConfirmOrderVC.h"

#import "ShippingAddressCell.h"
#import "ConfirmOrderCell.h"
#import "ConfirmOrderHeaderView.h"
#import "ConfirmOrderFooterView.h"

#import "UITableView+FDTemplateLayoutCell.h"

#import "AddressManagerVC.h"
#import "PayOrderVC.h"

#import "ShutTableView.h"

@interface ConfirmOrderVC ()

<UITableViewDelegate,UITableViewDataSource,AddressManagerDelegate>

{
    
    __weak IBOutlet UILabel *_totalPriceLable;
    __weak IBOutlet ShutTableView *_tableView;
    
    __weak IBOutlet UIButton *_submitOrderButton;
    
    
    
    NSString *_messageString;
    
}

@property (nonatomic ,strong) UIActivityIndicatorView *submitOrderIndicator;


@end

@implementation ConfirmOrderVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardStateChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50);
    [_tableView registerNib:[UINib nibWithNibName:@"ShippingAddressCell" bundle:nil] forCellReuseIdentifier:CellIdentifer_Address];
    [_tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderCell" bundle:nil] forCellReuseIdentifier:CellIdentifer];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    _totalPriceLable.text = [NSString stringWithFormat:@"合计：￥%.2f",[self countTotalPrice]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"确认订单";
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIActivityIndicatorView *)submitOrderIndicator
{
    if (_submitOrderIndicator == nil)
    {
        _submitOrderIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_submitOrderIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
    
    return _submitOrderIndicator;
}

- (void)keyBoardStateChange:(NSNotification *)notification
{
    NSDictionary *userInfoDict = notification.userInfo;
    
    CGFloat time = [[userInfoDict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    NSValue *endValue = [userInfoDict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] ;
    CGRect endRect = [endValue CGRectValue];
    CGFloat yCoordinate = endRect.origin.y;
    
    NSLog(@"userInfoDict ======= %@",userInfoDict);
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:time];
    
    if (yCoordinate > ScreenHeight - 64)
    {
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 50);
    }
    else
    {
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, yCoordinate - 64);
    }
    [UIView commitAnimations];
    
    
    
    NSLog(@"_tableView.frame === %@",[NSValue valueWithCGRect:_tableView.frame]);
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //第一分区 默认地址
    return 1 + _carModel.brandListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    BrandInfoModel *brandModel = _carModel.brandListArray[section - 1];
    
    return brandModel.commodityListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return [tableView fd_heightForCellWithIdentifier:CellIdentifer_Address cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    ShippingAddressCell *addressCell = (ShippingAddressCell *)cell;
                    [addressCell updateAdressDetaileInfoWithIndexPath:indexPath ShippingModel:_defaultAddress];
                }];
    }
    else
    {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
                          {
                              ConfirmOrderCell *productCell = (ConfirmOrderCell *)cell;
                              BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section - 1];
                              CommodityInfoModel *product = brandModel.commodityListArray[indexPath.row];
                              [productCell updateConfirmOrderWithProduct:product];
                          }];
        
        return height > 100 ? height : 100;
    }
    
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 20;
    }
    
    return 123;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    ConfirmOrderHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ConfirmOrderHeaderView" owner:nil options:nil][0];
    
    BrandInfoModel *brandModel = _carModel.brandListArray[section - 1];
    
    headerView.nameLable.text = brandModel.brandNameString;
    [headerView.imageView sd_setImageWithURL:[NSURL URLWithString:brandModel.brandImageString]];
    
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return nil;
    }
    
    ConfirmOrderFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ConfirmOrderFooterView" owner:nil options:nil][0];
    
    BrandInfoModel *brandModel = _carModel.brandListArray[section - 1];
    
    
    footerView.brandPriceLable.text = [NSString stringWithFormat:@"￥ %.2f",[self countSectionPriceWithBrand:brandModel]];
    footerView.countLable.text = [NSString stringWithFormat:@"共%ld件单品",[self countSectionSelectedNumberWithBrand:brandModel]];
    footerView.tag = 2;
    
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        ShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer_Address];
        [cell updateAdressDetaileInfoWithIndexPath:indexPath ShippingModel:_defaultAddress];
        
        return cell;
    }
    else
    {
        ConfirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        
        BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section - 1];
        CommodityInfoModel *product = brandModel.commodityListArray[indexPath.row];
        [cell updateConfirmOrderWithProduct:product];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        [self pushToShippingAddressManager];
    }    
}

- (void)pushToShippingAddressManager
{
    AddressManagerVC *managerVC = [[AddressManagerVC alloc]init];
    managerVC.delegate = self;
    managerVC.parentType = AddressManagerStateCar;
    [self.navigationController pushViewController:managerVC animated:YES];
}

- (void)switchShippingAddressWithAddress:(ShippingAddressModel *)addressModel
{
    _defaultAddress = addressModel;
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (IBAction)submitOrderButtonClick:(UIButton *)sender
{
    _submitOrderButton.userInteractionEnabled = NO;
    sender.selected = YES;
    self.submitOrderIndicator.center = CGPointMake(40, 15);
    [sender addSubview:self.submitOrderIndicator];
    [_submitOrderIndicator startAnimating];
    [self submitOrder];
    
    /*
     
     商品信息
     地址信息
     买家留言
     
     提交后台 生成订单
     
     生成订单成功后 转到支付页面
     */


}

#pragma mark -

- (CGFloat)countSectionPriceWithBrand:(BrandInfoModel *)brand
{
    CGFloat totalPrice = 0.0;
    

    for (CommodityInfoModel *product in brand.commodityListArray)
    {
        totalPrice += [product.oldPriceString floatValue] * product.count;
    }
    
    return totalPrice;
}

- (CGFloat)countTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        for (CommodityInfoModel *product in brand.commodityListArray)
        {
            totalPrice += [product.oldPriceString floatValue] * product.count;
        }
    }
    return totalPrice;
}

- (NSInteger)countSectionSelectedNumberWithBrand:(BrandInfoModel *)brand
{
    NSInteger count = 0;

    for (CommodityInfoModel *product in brand.commodityListArray)
    {
        count = count + product.count;
    }

    return count;
}

- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        for (CommodityInfoModel *product in brand.commodityListArray)
        {
            count = count + product.count;
        }
    }
    return count;
}


#pragma mark - RequestNetworkGetData

- (void)submitOrder
{
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    AccountInfo *user = [AccountInfo standardAccountInfo];
    NSString *userID = user.userId;
    
    __block NSString *rec_id = nil;
    [_carModel.brandListArray enumerateObjectsUsingBlock:^(BrandInfoModel  * brand, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [brand.commodityListArray enumerateObjectsUsingBlock:^(CommodityInfoModel *commodity, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (rec_id)
            {
                rec_id = [NSString stringWithFormat:@"%@,%@",rec_id,commodity.carIDString];
            }
            else
            {
                rec_id = commodity.carIDString;
            }
            
        }];
        
    }];
    
    
    [parameters setObject:userID forKey:@"user_id"];
    [parameters setObject:rec_id forKey:@"rec_id"];
    if (_defaultAddress.address_id.length > 0)
    {
        [parameters setObject:_defaultAddress.address_id forKey:@"address_id"];
    }
    else
    {
        _submitOrderButton.selected = NO;
        [_submitOrderIndicator stopAnimating]; // 开始旋转
        [_submitOrderIndicator removeFromSuperview];
        _submitOrderButton.userInteractionEnabled = YES;
        
        [self noAddressTipAlertView];
        return;
    }
    
    
//    [parameters setObject:_messageString forKey:@"postscript"];
//    [parameters setObject:phone_mob forKey:@"pay_id"];
//    [parameters setObject:save_address forKey:@"pay_name"];
//    [parameters setObject:shipping_id forKey:@"bonus_money"];
//    [parameters setObject:_buyerMessageString forKey:@"bonus_id"];
    
    NSLog(@"parameters ====== %@",parameters);
    
    
    [self.httpManager submitOrderParameterDict:parameters CompletionBlock:^(NSDictionary *payDict, NSError *error)
     {
         _submitOrderButton.selected = NO;
         [_submitOrderIndicator stopAnimating]; // 开始旋转
         [_submitOrderIndicator removeFromSuperview];
         _submitOrderButton.userInteractionEnabled = YES;
         if (error)
         {
             
         }
         else
         {
             
             NSDictionary *payInfo = @{@"order_string":payDict[@"order_string"],@"order_id":payDict[@"result"]};
             PayOrderVC *payVC = [[PayOrderVC alloc]initWithPayInfo:payInfo];
             [self.navigationController pushViewController:payVC animated:YES];
         }
    }];
}

- (void)noAddressTipAlertView
{
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"目前您还没有设置收货地址，请您添加至少一个收货地址" preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self pushToShippingAddressManager];
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
        
    }];

    [alertView addAction:confirmAction];
    
    [alertView addAction:cancelAction];

    [self presentViewController:alertView animated:YES completion:nil];
    
    
    
    

}


@end
