//
//  AddressManagerVC.m
//  SURE
//
//  Created by 王玉龙 on 16/11/15.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"ShippingAddressCell"


#import "AddressManagerVC.h"

#import "ShippingAddressCell.h"
#import "ShippingAddressFooterView.h"
#import "AddressDetaileVC.h"

#import "UserInfoHttpManager.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface AddressManagerVC ()

<UITableViewDelegate,UITableViewDataSource>

{
    
    NSMutableArray *_listArray;
    
    __weak IBOutlet UITableView *_tableView;
}

@property (nonatomic ,strong) UserInfoHttpManager *httpManager;

@end

@implementation AddressManagerVC

- (void)dealloc
{
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self customNavBar];
    
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellReuseIdentifier:CellIdentifer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self requestNetworkGetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.title = @"地址管理";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewShippingAddressButtonClick:(UIButton *)sender
{

    AddressDetaileVC *addressVC = [[AddressDetaileVC alloc]init];
    if (_listArray && _listArray.count)
    {
        //地址列表已经有地址，则不必强制要求设为默认地址
        addressVC.isNecessarySetDefaultAddress = NO;
    }
    else
    {
        //地址列表已经没有地址，强制要求添加的这个地址设为默认地址
         addressVC.isNecessarySetDefaultAddress = YES;
    }
    addressVC.detaileState = AddressDetaileStateAdd;
    [self.navigationController pushViewController:addressVC animated:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _listArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
            {
                ShippingAddressCell *addressCell = (ShippingAddressCell *)cell;
                ShippingAddressModel *adressModel = _listArray[indexPath.section];

                [addressCell updateAdressDetaileInfoWithIndexPath:indexPath ShippingModel:adressModel];
            }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 1;
    }
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ShippingAddressFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"ShippingAddressFooterView" owner:nil options:nil][0];
    
    ShippingAddressModel *adressModel = _listArray[section];
    footerView.defaultButton.selected = adressModel.isDefaultAdress;
    footerView.section = section;
    
    [footerView.defaultButton addTarget:self action:@selector(setDefaultShippingAdressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.editButton addTarget:self action:@selector(editShippingAdressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView.deleteButton addTarget:self action:@selector(deleteShippingAdressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ShippingAddressModel *adressModel = _listArray[indexPath.section];
    
    [cell updateAdressDetaileInfoWithIndexPath:indexPath ShippingModel:adressModel];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (_parentType == AddressManagerStateCar)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(switchShippingAddressWithAddress:)])
        {
            ShippingAddressModel *adressModel = _listArray[indexPath.section];
            [self.delegate switchShippingAddressWithAddress:adressModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark - FooterView Button Click


//设置默认地址
- (void)setDefaultShippingAdressButtonClick:(UIButton *)sender
{
    for (ShippingAddressModel *adressModel in _listArray)
    {
        adressModel.isDefaultAdress = NO;
        adressModel.address_name = @"收货地址";
        [ShippingAddressModel updateShippingAdressWithModel:adressModel];
    }
    
    ShippingAddressFooterView *footerView = (ShippingAddressFooterView *)sender.superview;
    ShippingAddressModel *adressModel = _listArray[footerView.section];

    adressModel.isDefaultAdress = YES;
     adressModel.address_name = @"默认地址";
    [_tableView reloadData];
    
    [self setDefaultShippingAdressWithAdress:adressModel];
}


- (void)editShippingAdressButtonClick:(UIButton *)sender
{
    ShippingAddressFooterView *footerView = (ShippingAddressFooterView *)sender.superview;
    ShippingAddressModel *adressModel = _listArray[footerView.section];

    AddressDetaileVC *addressVC = [[AddressDetaileVC alloc]init];
    addressVC.detaileState = AddressDetaileStateEdit;
    addressVC.adressModel = adressModel;
    [self.navigationController pushViewController:addressVC animated:YES];
}


- (void)deleteShippingAdressButtonClick:(UIButton *)sender
{
    ShippingAddressFooterView *footerView = (ShippingAddressFooterView *)sender.superview;
    ShippingAddressModel *adressModel = _listArray[footerView.section];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    hud.label.text = @"正在删除...";
    [self.httpManager deleteShippingAdressWithAddressId:adressModel.address_id CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];

         if (error == nil)
         {
             [ShippingAddressModel deletaShippingAdressWithModel:adressModel];
             [_listArray removeObject:adressModel];
             [_tableView reloadData];
         }
    }];
}

- (void)setDefaultShippingAdressWithAdress:(ShippingAddressModel *)model
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    AccountInfo *account = [AccountInfo standardAccountInfo];
    
        //十个参数 修改地址
    NSDictionary *parameterDict = @{@"user_id":account.userId,@"consignee":model.nameString,@"country":@"1",@"province":model.provinceID,@"city":model.cityID,@"district":model.districtID,@"address":model.addressString,@"mobile":model.phoneString,@"address_name":@"默认地址",@"address_id":model.address_id};
        
    hud.label.text = @"修改中...";
    
    //默认地址 收货地址
    
    // Set the label text.
    
    [self.httpManager addShippingAdressParameterDict:parameterDict CompletionBlock:^(NSError *error)
     {
         [hud hideAnimated:YES];
         
         if (error == nil)
         {
             [ShippingAddressModel updateShippingAdressWithModel:model];
         }
     }];
}


#pragma mark -

- (void)requestNetworkGetData
{
    NSArray *array = [ShippingAddressModel queryShippingAdressWithModel:nil];
    
    if (array && array.count)
    {
        _listArray = array;
                
         [_tableView reloadData];
        [self.httpManager getShippingListCompletionBlock:^(NSMutableArray *listArray, NSError *error)
         {
             if (error == nil)
             {
                 _listArray = listArray;
                 [_tableView reloadData];
             }
             
         }];
        
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.httpManager getShippingListCompletionBlock:^(NSMutableArray *listArray, NSError *error)
         {
             [hud hideAnimated:YES];
             
             if (error == nil)
             {
                 _listArray = listArray;
                 [_tableView reloadData];
             }
         }];
    }

    

}

@end
