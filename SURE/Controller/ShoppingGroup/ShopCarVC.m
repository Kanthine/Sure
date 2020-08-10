//
//  ShopCarVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/20.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define CellIdentifer @"ShopCarTableViewCell"


#import "ShopCarVC.h"
#import "MJRefresh.h"

#import "ShopCarTableViewCell.h"
#import "ShopCarTableViewHeaderView.h"

#import "UIImage+Extend.h"
#import "UIViewController+AddShoppingCar.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "ChooseProductSpecificationVC.h"

#import "ConfirmOrderVC.h"

#import "UserInfoHttpManager.h"

@interface ShopCarVC ()

<UITableViewDelegate,UITableViewDataSource,ShopCarTableViewCellDelegate,ShopCarTableViewHeaderViewDelegate,ChooseProductSpecificationVCDelegate>

{
    UIButton *_rightNavBarButton;
    
    
    __weak IBOutlet UIButton *_bottomShareBuutom;
    __weak IBOutlet UIButton *_bottomDeleteButton;
    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UILabel *_totalPriceLable;
    
    __weak IBOutlet UIButton *_sumButton;
    
    __weak IBOutlet UIButton *_allSelectedButton;
    
    
    ShoppingCarModel *_carModel;
    
    NSIndexPath *_editAttrbuteIndexPath;
    
    NSInteger _currentPage;
    
}

@property (nonatomic ,strong) ShippingAddressModel *defaultAddress;
@property (nonatomic ,strong) ChooseProductSpecificationVC *chooseVC;

@end

@implementation ShopCarVC


+ (void)pushToShoppingCarWithCurrentViewController:(UIViewController *)currentVC
{
    if ([AuthorizationManager isAuthorization])
    {
        ShopCarVC *carVC = [[ShopCarVC alloc]init];
        [carVC requestNetworkGetData];
        carVC.navigationController.navigationBar.hidden = NO;
        carVC.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:carVC animated:YES];
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:currentVC];
    }
}

- (void)dealloc
{
    NSLog(@"ShopCarVC   dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:CellIdentifer bundle:nil] forCellReuseIdentifier:CellIdentifer];
    [self setTableViewRefresh];
    [self customNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;

//    [self getCarListData];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getDefaultShippingAddress];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customNavBar
{
    self.navigationController.navigationBar.hidden = NO;
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage loadNavBarBackgroundImage]  imageByApplyingAlpha:1] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"购物车";

    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightNavBarButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightNavBarButton setTitle:@"完成" forState:UIControlStateSelected];

    _rightNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightNavBarButton addTarget:self action:@selector(rightNavButtonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    [_rightNavBarButton setImage:[UIImage imageNamed:@"shoppingCar_edit_white"] forState:UIControlStateNormal];
    //    _rightNavBarButton.adjustsImageWhenHighlighted = NO;
    //    _rightNavBarButton.adjustsImageWhenDisabled = NO;
    ////    [_rightNavBarButton setImage:[UIImage imageNamed:@"shoppingCar_CircleWhite_Selected"] forState:UIControlStateSelected];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightNavBarButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}


-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavButtonEditClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    for (BrandInfoModel *brandModel in _carModel.brandListArray)
    {
        brandModel.isEditingStatus = button.selected;
    }
    [_tableView reloadData];
    
    
    [self updateBottomSumButton:button.selected];
    
}


- (void)updateBottomSumButton:(BOOL)isSelected
{
    if (_rightNavBarButton.selected)
    {
        isSelected = YES;
    }
    _bottomShareBuutom.hidden = YES;

    
    //两种 进入编辑的 方式  全部编辑 和 品牌编辑
    if (isSelected)
    {
        _bottomDeleteButton.hidden = NO;
        _sumButton.hidden = YES;
        _totalPriceLable.hidden = YES;
    }
    else
    {
        _bottomDeleteButton.hidden = YES;
        _sumButton.hidden = NO;
        _totalPriceLable.hidden = NO;
        
        [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
        _sumButton.backgroundColor = RGBA(141, 31, 203,1);
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _carModel.brandListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    BrandInfoModel *brandModel = _carModel.brandListArray[section];
    
    return brandModel.commodityListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    return [tableView fd_heightForCellWithIdentifier:CellIdentifer cacheByIndexPath:indexPath configuration:^(id cell)
//            {
////                [self congifCell:cell indexpath:indexPath];
//            }];
    
    
    return 105;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCarTableViewHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ShopCarTableViewHeaderView" owner:nil options:nil][0];
    
    
    BrandInfoModel *brandModel = _carModel.brandListArray[section];
    
    headerView.delegate = self;
    headerView.sectionIndex = section;
    
    headerView.brandEditButton.selected = brandModel.isEditingStatus;
    headerView.leftButton.selected = brandModel.isBrandSelected;
    headerView.brandNameLable.text = brandModel.brandNameString;
    headerView.brandLogoImageView.image = [UIImage imageNamed:@"app.png"];
    
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section];
    CommodityInfoModel *infoModel = brandModel.commodityListArray[indexPath.row];
    
    
    
    cell.leftChooseButton.selected = infoModel.isCommoditySelected;
    
    
    cell.commodityNumberLable.text = [NSString stringWithFormat:@"X %ld",infoModel.count];
    cell.commodityPriceLable.text = [NSString stringWithFormat:@"￥ %@",infoModel.oldPriceString];
    cell.numberTextFiled.text = [NSString stringWithFormat:@"%ld",infoModel.count];
    cell.commodityTitleLable.text = infoModel.nameString;
    [cell.commodityImageButton sd_setImageWithURL:[NSURL URLWithString:infoModel.imageString] forState:UIControlStateNormal];
    
    cell.commodityKindLable.text = infoModel.attributeStrig;
    cell.currentKindLable.text = infoModel.attributeStrig;
    
    
    if (brandModel.isEditingStatus == NO)
    {
        cell.normalView.hidden = NO;
        cell.editStatusView.hidden = YES;
    }
    else
    {
        cell.normalView.hidden = YES;
        cell.editStatusView.hidden = NO;
    }
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ShopCarTableView HeaderView Delegate

//左上角 选中状态
- (void)brandSelected:(ShopCarTableViewHeaderView *)sender
{
    BrandInfoModel *brandModel = _carModel.brandListArray[sender.sectionIndex];
    brandModel.isBrandSelected = !brandModel.isBrandSelected;
    
    [brandModel.commodityListArray enumerateObjectsUsingBlock:^(CommodityInfoModel *commodityInfo, NSUInteger idx, BOOL * _Nonnull stop)
    {
        commodityInfo.isCommoditySelected = brandModel.isBrandSelected;
    }];

    NSRange range = NSMakeRange(sender.sectionIndex, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [_tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
    
    
    // 每次点击都要统计底部的按钮是否全选
    _allSelectedButton.selected = [self isAllProcductChoosed];
    
    if (brandModel.isEditingStatus == NO)
    {
        [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    }
    
    
    _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
}

//右上角 编辑状态
- (void)brandEditingSelected:(ShopCarTableViewHeaderView *)sender
{
    BrandInfoModel *brandModel = _carModel.brandListArray[sender.sectionIndex];
    brandModel.isEditingStatus = !brandModel.isEditingStatus;
    
    if (brandModel.isEditingStatus)
    {
        sender.brandEditButton.selected = YES;
    }
    else
    {
        sender.brandEditButton.selected = NO;
    }
    
    NSLog(@" sender== %@",sender);
    
    NSRange range = NSMakeRange(sender.sectionIndex, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [_tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
    
    [self updateBottomSumButton:brandModel.isEditingStatus];
}

#pragma mark - ShopCarTableView Cell Delegate

//编辑    商品属性
- (void)editingProductAttributeInfoClick:(ShopCarTableViewCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section];
    CommodityInfoModel *infoModel = brandModel.commodityListArray[indexPath.row];
    
    _editAttrbuteIndexPath = indexPath;
    
    
//    
//    if (infoModel.attributeModelArray.count == 0 || infoModel.attributeStrig == nil)
//    {
//        
//        return;
//    }
//    
    
    
    self.chooseVC = nil;
    self.chooseVC = [[ChooseProductSpecificationVC alloc] initWithEnterType:EnterTypeShopingCarEdit DefaultAssociationModel:infoModel.defaultAssociationModel];
    self.chooseVC.commodityInfo = infoModel;
    self.chooseVC.delegate = self;
//    self.chooseVC.defaultAssociationModel = infoModel.defaultAssociationModel;
//    self.chooseVC.enterType = EnterTypeShopingCarEdit;
    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{
                                                                                     KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                                     KNSemiModalOptionKeys.animationDuration : @(0.6),
                                                                                     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                                     KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]]
                                                                                     }];
    
    
    
}

- (void)editedAttributeInfoClick:(ProductAssociationModel *)defaultAssociationModel Attribute:(NSString *)attributeString Count:(NSInteger)count
{
    //修改 商品 数量
    if (_editAttrbuteIndexPath)
    {
        BrandInfoModel *brandModel = _carModel.brandListArray[_editAttrbuteIndexPath.section];
        CommodityInfoModel *infoModel = brandModel.commodityListArray[_editAttrbuteIndexPath.row];
        
        infoModel.defaultAssociationModel = defaultAssociationModel;
        
        infoModel.count = count;
        infoModel.attributeStrig = attributeString;
        
        [_tableView reloadRowsAtIndexPaths:@[_editAttrbuteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
        // 每次点击都要统计底部的按钮是否全选
        _allSelectedButton.selected = [self isAllProcductChoosed];
        if (brandModel.isEditingStatus == NO)
        {
            [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
        }
        _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
        
    }
    
    
    
    
}

//商品 是否选中
- (void)commoditySelectedStatusClick:(ShopCarTableViewCell *)cell isSelected:(BOOL)choosed
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section];
    CommodityInfoModel *productModel = brandModel.commodityListArray[indexPath.row];
    productModel.isCommoditySelected = !productModel.isCommoditySelected;
    
    
    // 当点击单个的时候，判断是否该买手下面的商品是否全部选中
    __block NSInteger count = 0;
    [brandModel.commodityListArray enumerateObjectsUsingBlock:^(CommodityInfoModel *commodityModel, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if (commodityModel.isCommoditySelected)
        {
            count ++;
        }
    }];
    
    if (count == brandModel.commodityListArray.count)
    {
        brandModel.isBrandSelected = YES;
    }
    else
    {
        brandModel.isBrandSelected = NO;
    }
    
    
    
    NSRange range = NSMakeRange(indexPath.section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [_tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
    
    
    // 每次点击都要统计底部的按钮是否全选
    _allSelectedButton.selected = [self isAllProcductChoosed];

    
    if (brandModel.isEditingStatus == NO)
    {
        [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    }
    

    _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];

}

- (void)plusOrMinusCommodityNumberClick:(ShopCarTableViewCell *)cell tag:(NSInteger)tag
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    BrandInfoModel *brandModel = _carModel.brandListArray[indexPath.section];
    CommodityInfoModel *infoModel = brandModel.commodityListArray[indexPath.row];
    
    if (tag == 5)
    {
        if (infoModel.count <= 1)
        {
            
        }
        else
        {
            infoModel.count --;
        }
    }
    else if (tag == 6)
    {
        infoModel.count ++;
    }
    
    [_tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    
    _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
}


//删除 单件商品
- (void)deleteProductClick:(ShopCarTableViewCell *)cell
{
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    
    BrandInfoModel *brand = _carModel.brandListArray[indexpath.section];
    CommodityInfoModel *product = brand.commodityListArray[indexpath.row];
    

    
    [self.httpManager deleteShoppingCarProfuctWithCarID:product.carIDString CompletionBlock:^(NSError *error)
    {
        if (error == nil)
        {
            //数组中删除
            if (brand.commodityListArray.count == 1)
            {
                [_carModel.brandListArray removeObject:brand];
            }
            else
            {
                [brand.commodityListArray removeObject:product];
            }
            // 这里删除之后操作涉及到太多东西了，需要
            [self deleteCommodityAndUpdateInfomation];
        }
        
    }];
}


- (void)enumerateCarListArrayDeleteProductWithCount:(NSInteger)count
{
    for ( BrandInfoModel *brand in _carModel.brandListArray)
    {
        if (brand.isBrandSelected)
        {
            [_carModel.brandListArray removeObject:brand];
            break;
        }
        else
        {
            for (CommodityInfoModel *product in brand.commodityListArray)
            {
                if (product.isCommoditySelected)
                {
                    [brand.commodityListArray removeObject:product];
                    break;
                }
            }
        }
    }
    
    count --;
    
    if (count > 0)
    {
        [self enumerateCarListArrayDeleteProductWithCount:count];
    }
    

}

- (void)deleteCommodityAndUpdateInfomation
{
    // 会影响到对应的买手选择
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        NSInteger count = 0;
        for (CommodityInfoModel *product in brand.commodityListArray)
        {
            if (product.isCommoditySelected)
            {
                count ++;
            }
        }
        if (count == brand.commodityListArray.count)
        {
            brand.isBrandSelected = YES;
        }
    }
    // 再次影响到全部选择按钮
    _allSelectedButton.selected = [self isAllProcductChoosed];
    
    _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",[self countTotalPrice]];
    
    
    [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
    [_tableView reloadData];
    
    // 如果删除干净了
    if (_carModel.brandListArray == nil || _carModel.brandListArray.count == 0)
    {
        [self rightNavButtonEditClick:_rightNavBarButton];
        _rightNavBarButton.enabled = NO;
    }
    
}

- (CGFloat)countTotalPrice
{
    CGFloat totalPrice = 0.0;
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        if (brand.isBrandSelected)
        {
            for (CommodityInfoModel *product in brand.commodityListArray)
            {
                totalPrice += [product.oldPriceString floatValue] * product.count;
            }
        }
        else
        {
            for (CommodityInfoModel *product in brand.commodityListArray)
            {
                if (product.isCommoditySelected)
                {
                    totalPrice += [product.oldPriceString floatValue] * product.count;
                }
            }
            
        }
    }
    return totalPrice;
}

- (NSInteger)countTotalSelectedNumber
{
    NSInteger count = 0;
     for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        for (CommodityInfoModel *product in brand.commodityListArray)
        {
            if (product.isCommoditySelected)
            {
                count ++;
            }
        }
    }
    return count;
}

- (BOOL)isAllProcductChoosed
{
    if (_carModel.brandListArray.count == 0)
    {
        return NO;
    }
    NSInteger count = 0;
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        if (brand.isBrandSelected)
        {
            count ++;
        }
    }
    return (count == _carModel.brandListArray.count);
}

#pragma mark - Bottom Button Click

- (IBAction)allProductSelectedButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    for (BrandInfoModel *brand in _carModel.brandListArray)
    {
        brand.isBrandSelected = sender.selected;
        for (CommodityInfoModel *product in brand.commodityListArray)
        {
            product.isCommoditySelected = brand.isBrandSelected;
        }
    }
    [_tableView reloadData];
    
    CGFloat totalPrice = [self countTotalPrice];
    _totalPriceLable.text = [NSString stringWithFormat:@"合计￥%.2f",totalPrice];
    [_sumButton setTitle:[NSString stringWithFormat:@"结算(%ld)",[self countTotalSelectedNumber]] forState:UIControlStateNormal];
    
}

- (IBAction)settleAccountsOrDeleteButtonClick:(UIButton *)sender
{
    //结算 遍历获取选中商品
    ShoppingCarModel *selectedCarModel = [_carModel getSelectedCarModel];
      
    if (selectedCarModel.brandListArray.count == 0)
    {
        return;
    }
    
    ConfirmOrderVC *orderVC = [[ConfirmOrderVC alloc]init];
    orderVC.carModel = selectedCarModel;
    orderVC.defaultAddress = _defaultAddress;
    [self.navigationController pushViewController:orderVC animated:YES];

}

- (IBAction)BottomDeleteButtonClick:(UIButton *)sender
{
    if ([_carModel isEmptyShoppingCar] == NO)
    {
        return;
    }
    
    __block NSString *carIDString = nil;
    
    __block  NSInteger count = 0;
    
    //遍历选中者 获得carID
    [_carModel.brandListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         BrandInfoModel *brand = (BrandInfoModel *)obj;
         [brand.commodityListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
          {
              CommodityInfoModel *product = (CommodityInfoModel *)obj;
              if (product.isCommoditySelected)
              {
                  if (carIDString == nil || [carIDString isEqualToString:@""])
                  {
                      carIDString = product.carIDString;
                  }
                  else
                  {
                      carIDString = [NSString stringWithFormat:@"%@,%@",carIDString,product.carIDString];
                  }
                  
                  count ++;
              }
          }];
     }];
    
    
    //forin 循环中的便利内容不能被改变, 是因为如果改变其便利的内容会少一个, 而系统是不会允许这个发生的所以就会crash...但是当改变最后一个的内容时, 就不会crash, 是因为此时遍历已经结束, 结束之后对内容做修改是允许的
    NSLog(@" delete count ======== %ld",count);

    if (count == 0)
    {
        return;
    }
    
    

    
    
    //网上 删除成功
    [self.httpManager deleteShoppingCarProfuctWithCarID:carIDString CompletionBlock:^(NSError *error)
     {
         
         if (error == nil)
         {
             
             NSLog(@"%ld",count);
             
             //数组删除
             [self enumerateCarListArrayDeleteProductWithCount:count];
             
             
             
             
             
             // 更新界面
             [self deleteCommodityAndUpdateInfomation];
         }
     }];
    
}

- (IBAction)bottomShareButtonClick:(UIButton *)sender
{
    
    
    
    
    
    
}

#pragma mark - RequestNetworkGetData

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
//                            {
//                                [weakSelf pullDownRefreshData];
//                            }];
//    
//
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;

}

- (void)pullDownRefreshData
{
    _currentPage = 1;
    
    if (_tableView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        _tableView.mj_footer.state = MJRefreshStateIdle;
    }
    
    [self requestNetworkGetData];
}

- (void)pullUpLoadData
{
    _currentPage ++;
    [self requestNetworkGetData];
}

- (void)requestNetworkGetData
{
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *user = [AccountInfo standardAccountInfo];
        NSString *userID = user.userId;
        NSDictionary *parameterDict = @{@"user_id":userID};
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.httpManager getShoppingCarListWithParameterDict:parameterDict CompletionBlock:^(ShoppingCarModel *carModel, NSError *error)
        {
            [hud hideAnimated:YES];
            
            if (error)
            {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"错误提示" message:error.domain preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"了解" style:UIAlertActionStyleDefault handler:nil];
                [alertView addAction:cancelAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            else
            {
                _carModel = carModel;
                [_tableView reloadData];
            }
            
            [self stopRefreshWithMoreData:YES];
        }];
        
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
}


- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    
    if ([_tableView.mj_header isRefreshing])
    {
        [_tableView.mj_header endRefreshing];
        
    }
    
    if ([_tableView.mj_footer isRefreshing])
    {
        
        if (isMoreData)
        {
            [_tableView.mj_footer endRefreshing];
        }
        else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_tableView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    
    if (_carModel.brandListArray && _carModel.brandListArray.count > 0)
    {
        BrandInfoModel *brand = (BrandInfoModel *)_carModel.brandListArray[0];
        if (brand.commodityListArray.count < 10)
        {
            [footer setTitle:@"" forState:MJRefreshStateIdle];
            [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        }
        else
        {
            [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
            [footer setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
        }
    }
    
}


// 拿到默认地址
- (void)getDefaultShippingAddress
{
    [[[UserInfoHttpManager alloc]init] getShippingListCompletionBlock:^(NSMutableArray *listArray, NSError *error)
     {
         if (listArray)
         {
             for (ShippingAddressModel *address in listArray)
             {
                 if (address.isDefaultAdress)
                 {
                     _defaultAddress = address;
                     break;
                 }
             }
         }         
     }];
}


@end
