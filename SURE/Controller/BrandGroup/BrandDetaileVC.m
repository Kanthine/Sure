//
//  BrandDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/17.
//  Copyright © 2016年 longlong. All rights reserved.
//

#define BackGroupHeight (ScreenWidth * 36 / 64.0)
#define Collection_Cell_Weight  (ScreenWidth - 1 )/ 2.0
#define Collection_Cell_Height  Collection_Cell_Weight + 75
#define Collection_Cell_Identifer @"CommodityCollectionCell"
#define Collection_SURE_Identifer @"BrandDetaileCollectionSureCell"

#import "BrandDetaileVC.h"

#import <UIImageView+WebCache.h>
#import "SingleProductDetaileVC.h"
#import "BrandIntroduceVC.h"
#import "ShareViewController.h"

#import "CommodityCollectionCell.h"
#import "BrandDetaileCollectionSureCell.h"


#import "TapSupportView.h"
#import "UIImage+Extend.h"
#import "FlashView.h"
#import "MJRefresh.h"
#import "BrandMenuView.h"
#import "ChatViewController.h"//即时通讯界面

#import "UIViewController+AddShoppingCar.h"
#import "ChooseProductSpecificationVC.h"

#import "LTCollectionViewDynamicHeightCellLayout.h"
#import "UICollectionView+LTCollectionViewLayoutCell.h"

typedef NS_ENUM(NSUInteger ,BrandDetaileShowType)
{
    BrandDetaileShowTypeCommodity = 0,
    BrandDetaileShowTypeSure,
};

@interface BrandDetaileVC ()
<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,CAAnimationDelegate>

{
    UIImageView *_navBarImageView;
    UIButton *_leftNavBarButton;
    UIButton *_rightNavBarButton;
    
    
    BrandDetaileShowType _showType;

    CommodityCollectionCell *_cell;
    
    NSMutableArray *_productListModelArray;
    NSMutableArray *_sureListModelArray;

    NSString *_orderByStr;
    NSString *_desStr;
    NSInteger _currentPage;
}
@property (nonatomic,strong) UIView *navBarView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *brandHeaderView;

@property (nonatomic ,strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic ,strong) UICollectionViewFlowLayout *tableLayout;
@property (nonatomic ,strong) UICollectionView *commodityCollectionView;


@property (nonatomic ,strong) NSMutableArray<NSNumber *> *indexCountBySectionForHeight;


@property (nonatomic,strong) FlashView *flashView;
@property (nonatomic ,strong) BrandMenuView *menuView;



@property (nonatomic ,strong) ChooseProductSpecificationVC *chooseVC;

@property (nonatomic,strong) CALayer *animationLayer;
@property (nonatomic,strong) UIBezierPath *animationPath;
@end

@implementation BrandDetaileVC

- (void)dealloc
{
    NSLog(@"BrandDetaileVC dealloc");

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _showType = BrandDetaileShowTypeCommodity;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    //截屏时事件通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenshotNotificationClick:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIView *)navBarView
{
    if (_navBarView == nil)
    {
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.delegate = self;
        
        
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navBarView.backgroundColor = [UIColor clearColor];
        _navBarView.clipsToBounds = YES;
        
        _navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        _navBarImageView.alpha = 0;
        _navBarImageView.frame = _navBarView.bounds;
        [_navBarView addSubview:_navBarImageView];
        
        
        _leftNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
        _leftNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back_Pressed"] forState:UIControlStateHighlighted];
        [_leftNavBarButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_leftNavBarButton];
        
        
        _rightNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Car"] forState:UIControlStateNormal];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_CarPressed"] forState:UIControlStateHighlighted];
        [_rightNavBarButton addTarget:self action:@selector(rightBtnShopCarAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_rightNavBarButton];
    }
    
    return _navBarView;
}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
        _bottomView.backgroundColor = [UIColor clearColor];
        

        
        
        UIImageView *bottomBackImageView = [[UIImageView alloc]initWithFrame:_bottomView.bounds];
        UIImage *whiteImage = [UIImage createImageWithColor:[UIColor whiteColor]];
        UIImage *newImage = [whiteImage imageByApplyingAlpha:.95f];
        bottomBackImageView.image = newImage;
        [_bottomView addSubview:bottomBackImageView];
        
        NSMutableArray *titleArray = [NSMutableArray arrayWithObjects:@"品牌介绍", @"咨询客服",@"收藏品牌",nil];
        NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:@"SingleProduct_Share", @"SingleProduct_Message",@"SingleProduct_CollectNo_Pressed",nil];
        CGFloat ButtonWidth = ScreenWidth / 3.0;
        for (int i = 0; i < titleArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ButtonWidth * i, 0, ButtonWidth, CGRectGetHeight(_bottomView.frame));
            button.adjustsImageWhenDisabled = NO;
            button.adjustsImageWhenHighlighted = NO;
            button.tag = 9 + i;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:TextColor149 forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
            [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            if (i == 2)
            {
                [button setImage:[UIImage imageNamed:@"SingleProduct_Collected"] forState:UIControlStateSelected];
            }
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [_bottomView addSubview:button];
        }
        
        
        UIView *lineView = UIView.new;
        lineView.backgroundColor = GrayLineColor;
        lineView.frame = CGRectMake(0, 0, ScreenWidth, 1);
        [_bottomView addSubview:lineView];
    }
    
    return _bottomView;
}

- (void)setBrandDataModel:(BrandDetaileModel *)brandDataModel
{
    _brandDataModel = brandDataModel;
    
    
    
    UIButton *button = [self.bottomView viewWithTag:11];
    
    if (brandDataModel.isAttention)
    {
        button.selected = YES;
    }
    else
    {
        button.selected = NO;
    }
    

    
    
}

- (FlashView *)flashView
{
    if (_flashView == nil)
    {
        _flashView = [[FlashView alloc]initWithFrame:CGRectMake(0, -BackGroupHeight - 90, ScreenWidth, BackGroupHeight)];
        _flashView.flashType = FlashViewModelTypeBrand;
        _flashView.currentViewController = self;
        _flashView.flashModelArray = _brandDataModel.flashModelArray;
    }
    
    return _flashView;
}

- (UIView *)brandHeaderView
{
    if (_brandHeaderView == nil)
    {
        _brandHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, - 90, ScreenWidth, 50)];
        
        
        UIView *imageContent = [[UIView alloc]initWithFrame:CGRectMake(10,5, 40, 40)];
        imageContent.backgroundColor = GrayLineColor;
        [_brandHeaderView addSubview:imageContent];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 38, 38)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_brandDataModel.brandLogoUrlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [imageContent addSubview:imageView];
        
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10 + CGRectGetWidth(imageView.frame) + 10 , 0, 100, 30)];
        nameLable.text = _brandDataModel.brandNameStr;
        nameLable.textColor = [UIColor blackColor];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGFloat width = [nameLable.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLable.font} context:nil].size.width;
        nameLable.frame = CGRectMake(10 + CGRectGetWidth(imageContent.frame) + 10 , 0, width, 30);
        nameLable.center = CGPointMake(nameLable.center.x, imageContent.center.y);
        [_brandHeaderView addSubview:nameLable];
        
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(ScreenWidth - 50, 5, 40, 40);
        [shareButton setImage:[UIImage imageNamed:@"sure_ShareGray"] forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"sure_ShareGray"] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareBrandButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        shareButton.hidden = YES;
        
        [_brandHeaderView addSubview:shareButton];
    }
    
    return _brandHeaderView;
}

/*
 * 商品分类展示
 */
- (BrandMenuView *)menuView
{
    if (_menuView == nil)
    {
        _menuView = [[BrandMenuView alloc]initWithFrame:CGRectMake(0, -40 , ScreenWidth, 40)];
        __weak __typeof__(self) weakSelf = self;
        _menuView.brandMenuViewButtonClick = ^(BOOL isRequest , NSString *orderByStr , NSString *desc)
        {
            if (isRequest)
            {
                _currentPage = 1;
                if (weakSelf.commodityCollectionView.mj_footer.state == MJRefreshStateNoMoreData)
                {
                    weakSelf.commodityCollectionView.mj_footer.state = MJRefreshStateIdle;
                }
                
                
                
                if ([orderByStr isEqualToString:@"SURE"])
                {
                    [weakSelf.commodityCollectionView setCollectionViewLayout:weakSelf.tableLayout];
                    _showType = BrandDetaileShowTypeSure;
                    [weakSelf requestNetWorkGetSureListData];
                }
                else
                {
              
                    [weakSelf.commodityCollectionView setCollectionViewLayout:weakSelf.collectionLayout];
                    _showType = BrandDetaileShowTypeCommodity;
                    [weakSelf requestNetWorkGetDataWithOrderBy:orderByStr Des:desc];
                }
                
                [weakSelf.commodityCollectionView reloadData];

            }
        };
    }
    
    return _menuView;
}

- (UICollectionViewFlowLayout *)tableLayout
{
    if (_tableLayout == nil)
    {
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(ScreenWidth,ScreenHeight - 64 - 40 - 49);
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);
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
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);//设置header区域大小
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//垂直滑动
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        
        _collectionLayout = flowLayout;
    }
    
    return _collectionLayout;
}

- (UICollectionView *)commodityCollectionView
{
    if (_commodityCollectionView == nil)
    {
        _commodityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) collectionViewLayout:self.collectionLayout];
        _commodityCollectionView.delegate = self;
        _commodityCollectionView.dataSource = self;
        _commodityCollectionView.backgroundColor = [UIColor whiteColor];
        _commodityCollectionView.scrollEnabled = YES;
        
        //自定义单元格
        [_commodityCollectionView registerNib:[UINib nibWithNibName:@"CommodityCollectionCell" bundle:nil] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        [_commodityCollectionView registerClass:[BrandDetaileCollectionSureCell class] forCellWithReuseIdentifier:Collection_SURE_Identifer];
        [_commodityCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        

        _commodityCollectionView.contentInset = UIEdgeInsetsMake(BackGroupHeight + 90, 0, 50, 0);
        [_commodityCollectionView addSubview:self.flashView];
        [_commodityCollectionView addSubview:self.brandHeaderView];
        [_commodityCollectionView addSubview:self.menuView];
        
        _indexCountBySectionForHeight = [NSMutableArray array];

        //设置上拉加载更多
        [self setTableViewRefresh];

    }
    
    
    return _commodityCollectionView;
}

#pragma mark - LTCollectionViewDynamicHeightCellLayoutDelegate
//
//- (NSInteger)numberOfColumnWithCollectionView:(UICollectionView *)collectionView
//                          collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout
//{
//    return 2;
//}
//
//- (CGFloat) marginOfCellWithCollectionView:(UICollectionView *)collectionView
//                      collectionViewLayout:(LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout{
//    return 2;
//}
//
//
//- (NSMutableArray<NSMutableArray *> *)indexHeightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout
//{
//    return _indexCountBySectionForHeight;
//}

#pragma mark - UICollectionView

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_showType == BrandDetaileShowTypeSure)
    {
        return _sureListModelArray.count;
    }

    
    return _productListModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == BrandDetaileShowTypeCommodity)
    {
//        CGFloat height = [collectionView lt_heightForCellWithIdentifier:Collection_Cell_Identifer cacheByIndexPath:indexPath configuration:^(CommodityCollectionCell *cell)
//                          {
////                              SUREModel *sureModel = _sureListModelArray[indexPath.row];
//                              
////                              [cell updateBrandDetaileCollectionSureCellWithModel:sureModel];
//                          }];
//        
//        _indexCountBySectionForHeight[indexPath.section] = @[@(height)];
//
//        return CGSizeMake(Collection_Cell_Weight, height);

        
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
    if (_showType == BrandDetaileShowTypeSure)
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
    if (_showType == BrandDetaileShowTypeSure)
    {
        
    }
    else
    {
        ProductModel *product = _productListModelArray[indexPath.row];
        SingleProductDetaileVC *singleDetaileVC = [[SingleProductDetaileVC alloc]initWithCommodityModel:product];
        [self.navigationController pushViewController:singleDetaileVC animated:YES];
    }
    
}

- (void)addCarButtonClick:(UIButton *)button
{
    NSInteger index = button.tag - 10;
    ProductModel *product = _productListModelArray[index];
    CommodityCollectionCell *cell = (CommodityCollectionCell *)[_commodityCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];

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

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    
    CGFloat alpha = (yOffset + BackGroupHeight)/BackGroupHeight;
    _navBarImageView.alpha = alpha;
    
    if (alpha < .5f)
    {
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back_Pressed"] forState:UIControlStateHighlighted];
        
        
        [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_Car"] forState:UIControlStateNormal];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"navBar_CarPressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton"] forState:UIControlStateNormal];
        [_leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Pressed"] forState:UIControlStateHighlighted];
        
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [_rightNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    }
    
    if (yOffset <= (-40 - 64))
    {
        _menuView.frame = CGRectMake(0, -40, ScreenWidth, 40);
    }
    else
    {
        _menuView.frame = CGRectMake(0, yOffset + 64, ScreenWidth, 40);
    }
}


#pragma mark - Button Click

- (void)takeScreenshotNotificationClick:(NSNotification *)notification
{
    
//    ShareViewController *shareVC = [[ShareViewController alloc]init];
//    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:shareVC animated:NO completion:^
//     {
//         [shareVC showPlatView];
//     }];
//    
    
    /*
     
     http://www.jianshu.com/p/1213f9f00fdd
     
     UIPasteboard是ios中访问粘贴板的原生控件，可分为系统等级的和app等级的，系统等级的独立于app，可以复制一个app的内容到另一个app；app等级的只能在app内进行复制和粘贴
     
     可以复制在粘贴板的数据类型有NSString、UIImage、NSURL、UIColor、NSData以及由这些类型元素组成的数组。可分别由它们的set方法将数据放在粘贴板中，如NSString：
     [pasteboard setString:@"复制的字符串内容"];
     
     */
    
    //+ (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
    
    NSLog(@"%@",notification.userInfo);
    
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnShopCarAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

- (void)shareBrandButtonClick
{
    NSString *linkStr = @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *imageStr = _brandDataModel.brandLogoUrlStr;
    NSString *descr = _brandDataModel.brandNameStr;
    
    ShareViewController *shareVC = [[ShareViewController alloc]initWithLinkUrl:linkStr imageUrlStr:imageStr Descr:descr];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:^
     {
         [shareVC showPlatView];
     }];
}

- (void)bottomButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 9;
    
    switch (index)
    {
        case 0:
            [self bottomBrandIntroduceButtonClick];
            break;
        case 1:
            [self bottomAskerviceButtonClick];
            break;
        case 2:
            [self bottomAttentionBrandButtonClick:sender];
            break;
            
        default:
            break;
    }
}

- (void)bottomBrandIntroduceButtonClick//品牌介绍
{
    BrandIntroduceVC *introVC = [[BrandIntroduceVC alloc]init];
    UINavigationController *intrNav =  [[UINavigationController alloc]initWithRootViewController:introVC];
    introVC.brandDataModel = _brandDataModel;
    introVC.navigationController.navigationBar.hidden = NO;
    [self presentViewController:intrNav animated:YES completion:nil];
}

- (void)bottomAskerviceButtonClick//询问客服
{
    ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)bottomAttentionBrandButtonClick:(UIButton *)button//关注本店
{
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if (_brandDataModel.isAttention == NO)//关注
        {
            AccountInfo *account = [AccountInfo standardAccountInfo];
            [button setImage:[UIImage imageNamed:@"SingleProduct_Collected"] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
            
            NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_brandDataModel.brandIDStr,@"follow_type":@"2"};
            
            [self.httpManager attentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 button.userInteractionEnabled = YES;
                 if (error)
                 {
                     NSLog(@"error.domain ===== %@",error.domain);
                 }
                 else
                 {
                     NSLog(@"成功关注");
                     _brandDataModel.isAttention = YES;
                 }
             }];
        }
        else//取消关注
        {
            
            NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_brandDataModel.brandIDStr,@"follow_type":@"2"};
            button.userInteractionEnabled = NO;
            [button setImage:[UIImage imageNamed:@"SingleProduct_CollectNo_Pressed"] forState:UIControlStateNormal];
            [self.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 button.userInteractionEnabled = YES;
                 if (error)
                 {
                     NSLog(@"error.domain ===== %@",error.domain);
                 }
                 else
                 {
                     NSLog(@"取消关注");
                     _brandDataModel.isAttention = NO;
                 }
             }];
            
        }
        
        
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }
    
}


#pragma mark - RequestData

- (void)setTableViewRefresh
{
    __weak __typeof(self) weakSelf = self;
    
//    _commodityCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^
//                            {
//                                [weakSelf pullDownRefreshData];
//                            }];
//    

    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
                                         {
                                             [weakSelf pullUpLoadData];
                                         }];

    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _commodityCollectionView.mj_footer = footer;
}

- (void)pullDownRefreshData
{
    _currentPage = 1;
    
    if (_commodityCollectionView.mj_footer.state == MJRefreshStateNoMoreData)
    {
        _commodityCollectionView.mj_footer.state = MJRefreshStateIdle;
    }
    
    [self requestNetWorkGetDataWithOrderBy:_orderByStr Des:_desStr];
}

- (void)pullUpLoadData
{
    _currentPage ++;
    [self requestNetWorkGetDataWithOrderBy:_orderByStr Des:_desStr];
}

- (void)requestNetworkGetData
{
    
    if (self.brandDataModel)
    {
        [self.view addSubview:self.commodityCollectionView];
        [self.view sendSubviewToBack:self.commodityCollectionView];
        
        _currentPage = 1;
        [self requestNetWorkGetDataWithOrderBy:@"click_count" Des:@""];
    }
    else if (self.brandIDString)
    {
        _orderByStr = @"click_count";
        _desStr = @"";
        
        
        NSDictionary *parametersDict = @{@"supplier_id":self.brandIDString};
        
        [self.httpManager getBrandDetaileWithParametersDict:parametersDict CompletionBlock:^(BrandDetaileModel *brandModel, NSError *error)
         {
             
             if (error)
             {
                 
             }
             else
             {
                 self.brandDataModel = brandModel;
                 [self.view addSubview:self.commodityCollectionView];
                 [self.view sendSubviewToBack:self.commodityCollectionView];
             }
        }];
    }
    
    
    

}

- (void)requestNetWorkGetDataWithOrderBy:(NSString *)orderByStr Des:(NSString *)desStr
{
    
    _orderByStr = orderByStr;
    _desStr = desStr;
    
    /*
     *综合:click_count  销量:buymax     价格:shop_price   新品:add_time
     */
    NSString *pageString = [NSString stringWithFormat:@"%ld",_currentPage];

    NSDictionary *parametersDict = @{@"supplier_id":_brandDataModel.brandIDStr,@"order_by":orderByStr,@"desc":desStr,@"cur_page":pageString,@"cur_size":@"10",@"cat_id":@""};


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
            
            [_commodityCollectionView reloadData];
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
    
    NSDictionary *dict = @{@"sure_id":@"",@"goods_id":@"",@"brand_id":self.brandDataModel.brandIDStr,@"sure_type":@"brand",@"user_id":uID,@"cur_page":@"1",@"cur_size":@"5"};
    
    [self.httpManager getBrandOrCommoditySureListWithParameterDict:dict CompletionBlock:^(NSMutableArray *sureListArray, NSError *error)
    {
        if (sureListArray)
        {
            _sureListModelArray = sureListArray;
            [_commodityCollectionView reloadData];
        }
        else
        {
            
        }
    }];
}

- (void)stopRefreshWithMoreData:(BOOL)isMoreData
{
    
    if ([_commodityCollectionView.mj_header isRefreshing])
    {
        [_commodityCollectionView.mj_header endRefreshing];
        
    }
    
    if ([_commodityCollectionView.mj_footer isRefreshing])
    {
        if (isMoreData)
        {
            [_commodityCollectionView.mj_footer endRefreshing];
        }
        else
        {
            [_commodityCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)_commodityCollectionView.mj_footer;
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
