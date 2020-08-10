//
//  KindListVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/19.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define Collection_Cell_Weight  (ScreenWidth - 1 * 3 )/ 2.0
#define Collection_Cell_Height  Collection_Cell_Weight + 75
#define Collection_Cell_Identifer @"CommodityCollectionCell"
#define Collection_SURE_Identifer @"BrandDetaileCollectionSureCell"

#import "KindListVC.h"

#import "BrandMenuView.h"
#import <MJRefresh.h>
#import "CommodityCollectionCell.h"
#import "BrandDetaileCollectionSureCell.h"
#import "UICollectionView+LTCollectionViewLayoutCell.h"

#import "UIViewController+AddShoppingCar.h"
#import "ChooseProductSpecificationVC.h"
#import "SingleProductDetaileVC.h"

typedef NS_ENUM(NSUInteger ,KindListShowType)
{
    KindListShowTypeCommodity = 0,
    KindListShowTypeSure,
};





@interface KindListVC ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

{
    KindListShowType _showType;

    KindModel *_kindModel;
    
    
    
    NSMutableArray *_productListModelArray;
    NSMutableArray *_sureListModelArray;
    
    CommodityCollectionCell *_cell;

    
    NSString *_orderByStr;
    NSString *_desStr;
    NSInteger _currentPage;

}

@property (nonatomic ,strong) BrandMenuView *menuView;

@property (nonatomic ,strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic ,strong) UICollectionViewFlowLayout *tableLayout;
@property (nonatomic ,strong) UICollectionView *listCollectionView;


@property (nonatomic ,strong) ChooseProductSpecificationVC *chooseVC;

@property (nonatomic,strong) CALayer *animationLayer;
@property (nonatomic,strong) UIBezierPath *animationPath;
@end

@implementation KindListVC

- (instancetype)initWithModel:(KindModel *)model
{
    self = [super init];
    if (self)
    {
        _kindModel = model;
        _orderByStr = @"";
        _desStr = @"";
        
        [self pullDownRefreshData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;

    [self setNavBar];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.listCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = self;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Custom NavBar

- (void)setNavBar
{
    self.navigationItem.title = _kindModel.catName;
    
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftNavBarButtonClick)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    UIButton *carNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    carNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    carNavBarButton.frame = CGRectMake(ScreenWidth - 40, 7, 60, 44);
    [carNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
    [carNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:carNavBarButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)leftNavBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 * 商品分类展示
 */
- (BrandMenuView *)menuView
{
    if (_menuView == nil)
    {
        _menuView = [[BrandMenuView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, 40)];
        __weak __typeof__(self) weakSelf = self;
        _menuView.brandMenuViewButtonClick = ^(BOOL isRequest , NSString *orderByStr , NSString *desc)
        {
            if (isRequest)
            {
                _currentPage = 1;
                if (weakSelf.listCollectionView.mj_footer.state == MJRefreshStateNoMoreData)
                {
                    weakSelf.listCollectionView.mj_footer.state = MJRefreshStateIdle;
                }
                
                
                
                if ([orderByStr isEqualToString:@"SURE"])
                {
                    weakSelf.listCollectionView.collectionViewLayout = weakSelf.tableLayout;

                    _showType = KindListShowTypeSure;
                    [weakSelf requestNetWorkGetSureListData];
                }
                else
                {
                    
                    NSLog(@"weakSelf.listCollectionView == %@",weakSelf.listCollectionView);
                    NSLog(@"collectionLayout == %@",weakSelf.collectionLayout);
                    NSLog(@"weakSelf == %@",weakSelf);
                    
                    weakSelf.listCollectionView.collectionViewLayout = weakSelf.collectionLayout;
                    _showType = KindListShowTypeCommodity;
                    [weakSelf requestNetWorkGetDataWithOrderBy:orderByStr Des:desc];
                }
                
                [weakSelf.listCollectionView reloadData];
                
            }
        };
    }
    
    return _menuView;
}

#pragma mark - UICollectionView

- (UICollectionViewFlowLayout *)tableLayout
{
    if (_tableLayout == nil)
    {
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(ScreenWidth,ScreenHeight - 64 - 40 - 49);
        flowLayout.headerReferenceSize = CGSizeZero;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        _tableLayout = flowLayout;
    }
    
    return _tableLayout;
}

- (UICollectionViewFlowLayout *)collectionLayout
{
    if (_collectionLayout == nil)
    {
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(Collection_Cell_Weight,Collection_Cell_Height);//设置每个cell显示数据的宽和高必须
        flowLayout.headerReferenceSize = CGSizeZero;//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        
        _collectionLayout = flowLayout;
    }
    
    return _collectionLayout;
}

- (UICollectionView *)listCollectionView
{
    if (_listCollectionView == nil)
    {
        _listCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.menuView.frame),ScreenWidth, ScreenHeight - 64 - 45) collectionViewLayout:self.collectionLayout];
        _listCollectionView.delegate = self;
        _listCollectionView.dataSource = self;
        _listCollectionView.backgroundColor = [UIColor whiteColor];
        _listCollectionView.scrollEnabled = YES;
        
        
        //自定义单元格
        [_listCollectionView registerNib:[UINib nibWithNibName:@"CommodityCollectionCell" bundle:nil] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        [_listCollectionView registerClass:[BrandDetaileCollectionSureCell class] forCellWithReuseIdentifier:Collection_SURE_Identifer];
        
        //设置上拉加载更多
        [self setTableViewRefresh];
    }
    
    return _listCollectionView;
}


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (_showType == KindListShowTypeSure)
    {
        return _sureListModelArray.count;
    }
    
    return _productListModelArray.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == KindListShowTypeCommodity)
    {
        return CGSizeMake(Collection_Cell_Weight, Collection_Cell_Height);
    }
    else
    {
        
        CGFloat height = [collectionView lt_heightForCellWithIdentifier:Collection_SURE_Identifer cacheByIndexPath:indexPath configuration:^(BrandDetaileCollectionSureCell *cell)
      {
          SUREModel *sureModel = _sureListModelArray[indexPath.row];
          
          [cell updateBrandDetaileCollectionSureCellWithModel:sureModel];
      }];
        
        return CGSizeMake(ScreenWidth, height);
        
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == KindListShowTypeSure)
    {
        BrandDetaileCollectionSureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_SURE_Identifer forIndexPath:indexPath];
        cell.currentViewController = self;
        if (_sureListModelArray && _sureListModelArray.count)
        {
            SUREModel *sureModel = _sureListModelArray[indexPath.row];
            
            [cell updateBrandDetaileCollectionSureCellWithModel:sureModel];
        }
        return cell;
    }
    
    
    
    CommodityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    
    ProductModel *product = _productListModelArray[indexPath.row];
    cell.productNameLable.text = product.productNameStr;
    cell.productPriceLable.text = [NSString stringWithFormat:@"￥%@",product.productPriceStr] ;
    
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:product.goods_thumbString] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    
    cell.addCarButton.tag = indexPath.row + 10;
    [cell.addCarButton addTarget:self action:@selector(addCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == KindListShowTypeSure)
    {
        
    }
    else
    {
        if (self.isBrandTagChoose)
        {
            ProductModel *product = _productListModelArray[indexPath.row];
            
            self.didSelectKindListCommodity(product.brandNameStr,product.brandIDStr,product.productIDStr);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ProductModel *product = _productListModelArray[indexPath.row];
            SingleProductDetaileVC *singleDetaileVC = [[SingleProductDetaileVC alloc]initWithCommodityModel:product];
            [self.navigationController pushViewController:singleDetaileVC animated:YES];
        }

    }


}

#pragma mark - Add Shopping Car

- (void)addCarButtonClick:(UIButton *)button
{
    NSInteger index = button.tag - 10;
    ProductModel *product = _productListModelArray[index];
    CommodityCollectionCell *cell = (CommodityCollectionCell *)[_listCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    
    if ([AuthorizationManager isAuthorization])
    {
        if (product.attributeModelArray.count > 0)
        {
            [self editingProductAttributeProduct:product];
        }
        else
        {
            [self startAnimationWithStartRect:CGRectMake(Collection_Cell_Weight / 4.0, Collection_Cell_Weight / 4.0, Collection_Cell_Weight / 2.0, Collection_Cell_Weight / 2.0) ImageView:cell.productImageView WithCell:cell];
            
            AccountInfo *user = [AccountInfo standardAccountInfo];
            NSString *userID = user.userId;
            
            //
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:product.productIDStr forKey:@"goods_id"];
            [dict setObject:userID forKey:@"user_id"];
            [dict setObject:@"1" forKey:@"goods_number"];
            //[dict setObject:<#(nonnull id)#> forKey:@"goods_attr_id"];
            //[dict setObject:<#(nonnull id)#> forKey:@"product_id"];
            
            
            NSLog(@"dict === %@",dict);
            
            [self.httpManager addProductToShoppingCarWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 if (error == nil)
                 {
                     NSLog(@"添加成功");
                 }
             }];
        }
        
        
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
    
    
    
    
}


- (ChooseProductSpecificationVC *)chooseVC
{
    if (_chooseVC == nil)
    {
        _chooseVC = [[ChooseProductSpecificationVC alloc] init];
    }
    
    return _chooseVC;
}


- (void)editingProductAttributeProduct:(ProductModel *)product
{
    _chooseVC = nil;
    
    self.chooseVC.singleProduct = product;
    if (product.associationArray.count > 0)//默认商品规格
    {
        self.chooseVC.defaultAssociationModel = product.associationArray[0];
    }
    
    
    self.chooseVC.enterType = EnterTypeAddShoppingCar;
    __weak typeof(self)weakSelf = self;
    _chooseVC.block = ^
    {
        
        NSLog(@"点击回调去购物车");
        //        // 下面一定要移除，不然你的控制器结构就乱了，基本逻辑层级我们已经写在上面了，这个效果其实是addChildVC来的，最后的展示是在Window上的，一定要移除
        //        [weakSelf.chooseVC.view removeFromSuperview];
        //        [weakSelf.chooseVC removeFromParentViewController];
        //        weakSelf.chooseVC.view = nil;
        //        weakSelf.chooseVC = nil;
        
        //        MKJShoppingCartViewController *shop = [MKJShoppingCartViewController new];
        //        [weakSelf.navigationController pushViewController:shop animated:YES];
        
    };
    
    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{
                                                                                     KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                                     KNSemiModalOptionKeys.animationDuration : @(0.6),
                                                                                     KNSemiModalOptionKeys.shadowOpacity     : @(0.0),
                                                                                     KNSemiModalOptionKeys.backgroundView : [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]]
                                                                                     }];
    
    
    
}

#pragma mark - Add Car Animation

-(void)startAnimationWithStartRect:(CGRect)rect ImageView:(UIImageView *)imageView WithCell:(CommodityCollectionCell *)cell
{
    if (!_animationLayer)
    {
        _animationLayer = [CALayer layer];
        _cell = cell;
        //contents表示接受内容
        _animationLayer.contents = (id)imageView.layer.contents;
        //contents的内容映射到边界矩形
        _animationLayer.contentsGravity = kCAGravityResizeAspectFill;
        _animationLayer.bounds = rect;
        [_animationLayer setCornerRadius:CGRectGetHeight([_animationLayer bounds]) / 2];
        _animationLayer.masksToBounds = YES;
        
        _animationLayer.position = CGPointMake( rect.origin.x + imageView.frame.size.width / 2, rect.origin.y + imageView.frame.size.height / 2);
        
        [cell.contentView.layer addSublayer:_animationLayer];
        //[self.view.layer addSublayer:_animationLayer];
        
        
        
        self.animationPath = [UIBezierPath bezierPath];
        [_animationPath moveToPoint:_animationLayer.position];
        
        
        
        CGFloat endX = cell.addCarButton.frame.origin.x;//_footerCarView.shopCarImageview.center.x + _footerCarView.frame.origin.x;
        CGFloat endY = cell.addCarButton.frame.origin.y;//_footerCarView.shopCarImageview.center.y + _footerCarView.frame.origin.y;
        
        [_animationPath addQuadCurveToPoint:CGPointMake(endX, endY) controlPoint:CGPointMake(Collection_Cell_Weight / 2,Collection_Cell_Height / 2.0 )];
    }
    
    [self groupAnimation];
}

-(void)groupAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _animationPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:1.5f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.5f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_animationLayer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_animationLayer animationForKey:@"group"])
    {
        
        
        [_animationLayer removeFromSuperlayer];
        _animationLayer = nil;
        
        
        
        int num = 9;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        //_footerCarView.shoppingNumLable.text = [NSString stringWithFormat:@"%d",_commodityNumber == 0 ? num : _commodityNumber];
        //  [_footerCarView.shoppingPriceLable.layer addAnimation:animation forKey:nil];
        
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_cell.addCarButton.layer addAnimation:shakeAnimation forKey:nil];
        
        
        //        _commodityNumber = 0;
    }
}



#pragma mark - RequestData

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    _listCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
    {
        [weakSelf pullDownRefreshData];
    }];

    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _listCollectionView.mj_footer = footer;
}

- (void)pullDownRefreshData
{
    _currentPage = 1;
    
    if (_listCollectionView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        _listCollectionView.mj_footer.state = MJRefreshStateIdle;
    }
    
    
    if (_showType == KindListShowTypeCommodity)
    {
        [self requestNetWorkGetDataWithOrderBy:_orderByStr Des:_desStr];
    }
    else
    {
        [self requestNetWorkGetSureListData];
    }
}

- (void)pullUpLoadData
{
    _currentPage ++;
    
    if (_showType == KindListShowTypeCommodity)
    {
        [self requestNetWorkGetDataWithOrderBy:_orderByStr Des:_desStr];
    }
    else
    {
        [self requestNetWorkGetSureListData];
    }
}

- (void)requestNetworkGetData
{
    _currentPage = 1;
    
    if (_showType == KindListShowTypeCommodity)
    {
        [self requestNetWorkGetDataWithOrderBy:@"click_count" Des:@""];
    }
    else
    {
        [self requestNetWorkGetSureListData];
    }

}

- (void)requestNetWorkGetDataWithOrderBy:(NSString *)orderByStr Des:(NSString *)desStr
{
    
    _orderByStr = orderByStr;
    _desStr = desStr;
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage];
    /*
     *综合:click_count  销量:buymax     价格:shop_price   新品:add_time
     */
    
    if (orderByStr == nil)
    {
        orderByStr = @"";
    }
    if (desStr == nil)
    {
        desStr = @"";
    }
    
    
    NSDictionary *parametersDict = @{@"supplier_id":@"",@"order_by":orderByStr,@"desc":desStr,@"cur_page":pageString,@"cur_size":@"10",@"cat_id":_kindModel.catId};

    [self.httpManager getBrandCommodityListWithParameterDict:parametersDict CompletionBlock:^(NSMutableArray *productListArray, NSError *error)
     {
         if (!error)
         {
             if (_currentPage == 1)
             {
                 [self stopRefreshWithMoreData:YES];
                 _productListModelArray = productListArray;
             }
             else
             {
                 if (productListArray.count)
                 {
                     [self stopRefreshWithMoreData:YES];
                     [_productListModelArray addObjectsFromArray:productListArray];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             
             [self.listCollectionView reloadData];
         }
         else
         {
             [self stopRefreshWithMoreData:NO];
         }
     }];    
}

- (void)requestNetWorkGetSureListData
{
    NSString *uID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        uID = account.userId;
    }
    
    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage];

    
    NSDictionary *dict = @{@"sure_id":@"",@"goods_id":@"",@"brand_id":@"2",@"sure_type":@"brand",@"user_id":uID,@"cur_page":pageString,@"cur_size":@"5"};
    
    [self.httpManager getBrandOrCommoditySureListWithParameterDict:dict CompletionBlock:^(NSMutableArray *sureListArray, NSError *error)
     {
         if (sureListArray)
         {
             if (_currentPage == 1)
             {
                 [self stopRefreshWithMoreData:YES];
                 _sureListModelArray = sureListArray;
             }
             else
             {
                 if (sureListArray.count)
                 {
                     [self stopRefreshWithMoreData:YES];
                     [_sureListModelArray addObjectsFromArray:sureListArray];
                 }
                 else
                 {
                     [self stopRefreshWithMoreData:NO];
                 }
             }
             
             [self.listCollectionView reloadData];

         }
         else
         {
             [self stopRefreshWithMoreData:NO];

         }
     }];
}

- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    if ([_listCollectionView.mj_header isRefreshing])
    {
        [_listCollectionView.mj_header endRefreshing];
    }
    
    
    if ([_listCollectionView.mj_footer isRefreshing])
    {
        if (isMoreData)
        {
            [_listCollectionView.mj_footer endRefreshing];
        }
        else
        {
            [_listCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_listCollectionView.mj_footer;
    //如果底部 提示字体在界面上，则设置空
    if (_productListModelArray.count < 6)
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



@end
