//
//  SingleProductDetaileVC.m
//  SURE
//
//  Created by 王玉龙 on 16/10/18.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define Collection_Cell_Identifer @"SingleProductDetaileCollectionCell"
#define Collection_SURE_Identifer @"BrandDetaileCollectionSureCell"

#import "SingleProductDetaileVC.h"


#import "BrandDetaileCollectionSureCell.h"
#import "SingleProductDetaileCollectionCell.h"

#import "AppDelegate.h"

#import "ShareViewController.h"
#import "UIViewController+AddShoppingCar.h"
#import "ChooseProductSpecificationVC.h"
#import "UIImage+Extend.h"
#import "BrandDetaileVC.h"
#import "FlashView.h"

#import "UICollectionView+LTCollectionViewLayoutCell.h"

#import "ChatViewController.h"

typedef NS_ENUM(NSUInteger ,SingleProductDetaileShowType)
{
    SingleProductDetaileShowTypeWebView = 0,
    SingleProductDetaileShowTypeSureList,
};





@interface SingleProductDetaileVC ()

<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

{
    
    ProductModel *_singleProduct;
    
    CGFloat _webViewHeight;
    
    SingleProductDetaileShowType _showType;
}

@property (nonatomic,strong) UIView *navBarView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic ,strong) UICollectionView *pageCollectionView;


@property (nonatomic ,strong) FlashView *flashView;
@property (nonatomic ,strong) UIView *productHeaderView;
@property (nonatomic ,strong) UIView *segmentedView;


@property (nonatomic ,strong) NSMutableArray *sureListModelArray;

@property (nonatomic,strong) ChooseProductSpecificationVC *chooseVC;

@end

@implementation SingleProductDetaileVC


- (void)dealloc
{
    NSLog(@"SingleProductDetaileVC dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}


- (instancetype)initWithCommodityModel:(ProductModel *)singleProduct
{
    self = [super init];
    
    if (self)
    {
        if (singleProduct)
        {
            _singleProduct = singleProduct;
            [self requestNetworkGetData];
        }
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeScreenshotNotificationClick:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pageCollectionView];
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.bottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    self.navigationController.delegate = self;
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
        [self.view addSubview:_navBarView];
        
        
        UIImageView *navBarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar"]];
        navBarImageView.tag = 1;
        navBarImageView.alpha = 0;
        navBarImageView.frame = _navBarView.bounds;
        [_navBarView addSubview:navBarImageView];
        
        
        UIButton *leftNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
        leftNavBarButton.tag = 2;
        leftNavBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back"] forState:UIControlStateNormal];
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back_Pressed"] forState:UIControlStateHighlighted];
        [leftNavBarButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:leftNavBarButton];
        
        UIButton *shareNavBarButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 20, 40, 40)];
        shareNavBarButton.tag = 3;
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_Share"] forState:UIControlStateNormal];
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_SharePressed"] forState:UIControlStateHighlighted];
        [shareNavBarButton addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:shareNavBarButton];
        
        
        
        UIButton *carNavBarButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 20, 40, 40)];
        carNavBarButton.tag = 4;
        [carNavBarButton setImage:[UIImage imageNamed:@"navBar_Car"] forState:UIControlStateNormal];
        [carNavBarButton setImage:[UIImage imageNamed:@"navBar_CarPressed"] forState:UIControlStateHighlighted];
        [carNavBarButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:carNavBarButton];
    }
    
    return _navBarView;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightBtnAction
{
    [ShopCarVC pushToShoppingCarWithCurrentViewController:self];
}

-(void)shareBtnAction
{
    NSString *linkStr = @"http://www.cocoachina.com/ios/20170216/18693.html";
    NSString *imageStr = _singleProduct.original_img;
    NSString *descr = _singleProduct.productNameStr;
    ShareViewController *shareVC = [[ShareViewController alloc]initWithLinkUrl:linkStr imageUrlStr:imageStr Descr:descr];
    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:shareVC animated:NO completion:^
     {
         [shareVC showPlatView];
     }];
}

- (UICollectionView *)pageCollectionView
{
    if (_pageCollectionView == nil)
    {
        
        UICollectionViewFlowLayout  *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(ScreenWidth,ScreenWidth);
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, 0);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:1];
        [flowLayout setMinimumLineSpacing:1];
        
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) collectionViewLayout:flowLayout];
        _pageCollectionView.backgroundColor = [UIColor whiteColor];
        _pageCollectionView.scrollEnabled = YES;
        
        _pageCollectionView.delegate = self;
        _pageCollectionView.dataSource = self;

        _webViewHeight = 500;
        
        _pageCollectionView.contentInset = UIEdgeInsetsMake(ScreenWidth + 120, 0, 50, 0);

        //自定义单元格
        [_pageCollectionView registerClass:[SingleProductDetaileCollectionCell class] forCellWithReuseIdentifier:Collection_Cell_Identifer];
        [_pageCollectionView registerClass:[BrandDetaileCollectionSureCell class] forCellWithReuseIdentifier:Collection_SURE_Identifer];
        
    }
    
    
    return _pageCollectionView;
}

- (FlashView *)flashView
{
    if (_flashView == nil)
    {
        _flashView = [[FlashView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _flashView.flashType = FlashViewModelTypeProduct;
        _flashView.currentViewController = self;
        _flashView.flashModelArray = _singleProduct.flashModelArray;
    }
    
    return _flashView;
}

- (UIView *)productHeaderView
{
    if (_productHeaderView == nil)
    {
        _productHeaderView = [[UIView alloc]init];
        _productHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(10,5, ScreenWidth - 20, 25)];
        nameLable.lineBreakMode = NSLineBreakByCharWrapping;
        nameLable.numberOfLines = 0;
        nameLable.textColor = [UIColor blackColor];//RGBA(142, 31, 203,1);
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.text = _singleProduct.productNameStr;
        [_productHeaderView addSubview:nameLable];
        
        CGFloat nameHeight = [nameLable.text boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : nameLable.font} context:nil].size.height;
        nameLable.frame = CGRectMake(10, 5, ScreenWidth - 20, nameHeight);
        
        
        UILabel *priceLable = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLable.frame) + 5, ScreenWidth - 20, 25)];
        priceLable.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
        priceLable.textColor = RGBA(142, 31, 203,1);
        priceLable.textAlignment = NSTextAlignmentLeft;
        priceLable.text = [NSString stringWithFormat:@"￥ %@",_singleProduct.productPriceStr];
        [_productHeaderView addSubview:priceLable];
        
        
        CGSize priceLableSize = [priceLable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:priceLable.font} context:nil].size;
        priceLable.frame = CGRectMake(10, CGRectGetMaxY(nameLable.frame) + 5, priceLableSize.width + 5, 25);
        
        
        
        if (_singleProduct.marketPriceStr.length > 1)
        {
            UILabel *oldPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLable.frame) + 5, CGRectGetMaxY(nameLable.frame) + 5,CGRectGetMaxX(priceLable.frame) + 15, 25)];
            NSString *marketPrice = [NSString stringWithFormat:@"￥%@  ",_singleProduct.marketPriceStr];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:marketPrice];
            [attriStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, marketPrice.length)];
            oldPriceLable.font = [UIFont fontWithName:@"Helvetica" size:14];
            oldPriceLable.textColor = TextColor149;
            oldPriceLable.textAlignment = NSTextAlignmentLeft;
            oldPriceLable.attributedText = attriStr;
            [_productHeaderView addSubview:oldPriceLable];
            
            
            CGSize oldPriceLableSize = [oldPriceLable.text boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:oldPriceLable.font} context:nil].size;
            
            oldPriceLable.frame = CGRectMake(CGRectGetMaxX(priceLable.frame) + 5, CGRectGetMaxY(nameLable.frame) + 3 + 25 - oldPriceLableSize.height,CGRectGetMaxX(priceLable.frame) + 15, oldPriceLableSize.height);

        }
        
        

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(priceLable.frame) + 5, ScreenWidth, 10)];
        lineView.backgroundColor = RGBA(250, 250, 255, 1);
        UIView *lineGray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineGray.backgroundColor = RGBA(220 , 220, 220, 1);
        [lineView addSubview:lineGray];

        [_productHeaderView addSubview:lineView];

        
        UIView *imageContent = [[UIView alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(priceLable.frame) + 25, 40, 40)];
        imageContent.backgroundColor = GrayLineColor;
        UIImageView *storeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 38, 38)];
        storeImageView.contentMode = UIViewContentModeScaleAspectFit;
        [storeImageView sd_setImageWithURL:[NSURL URLWithString:_singleProduct.brandModel.brandLogoUrlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [imageContent addSubview:storeImageView];
        [_productHeaderView addSubview:imageContent];
        

        
        
        
        UILabel *storeNameLable = [[UILabel alloc]initWithFrame:CGRectMake(10 + CGRectGetWidth(imageContent.frame) + 10 , 0, 100, 30)];
        storeNameLable.text = _singleProduct.brandModel.brandNameStr;
        storeNameLable.textColor = [UIColor blackColor];
        storeNameLable.textAlignment = NSTextAlignmentCenter;
        storeNameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        CGRect lableRect = [self boundingRectWithString: storeNameLable.text Font:storeNameLable.font ];
        storeNameLable.frame = CGRectMake(10 + CGRectGetWidth(imageContent.frame) + 10 , 0, lableRect.size.width, 30);
        storeNameLable.center = CGPointMake(storeNameLable.center.x, imageContent.center.y);
        [_productHeaderView addSubview:storeNameLable];
        
        
        UIButton *storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        storeButton.frame = CGRectMake(ScreenWidth - 150, CGRectGetMaxY(priceLable.frame) + 25, 150, 40);
        [storeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [storeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [storeButton addTarget:self action:@selector(pushStoreDetaileButtonclick) forControlEvents:UIControlEventTouchUpInside];
        [storeButton setTitle:@"查看品牌" forState:UIControlStateNormal];
        [storeButton setTitleColor:TextColor149 forState:UIControlStateNormal];
        storeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_productHeaderView addSubview:storeButton];
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navBar_RightButton"]];
        rightImageView.frame = CGRectMake(ScreenWidth - 19, 0, 9, 15);
        rightImageView.center = CGPointMake(rightImageView.center.x, storeButton.center.y);
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_productHeaderView addSubview:rightImageView];
        
        
        
        UIView *bottomineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageContent.frame) + 10, ScreenWidth, 10)];
        bottomineView.backgroundColor = RGBA(250, 250, 255, 1);
        UIView *bolineGray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        bolineGray.backgroundColor = RGBA(220 , 220, 220, 1);
        [bottomineView addSubview:bolineGray];
        [_productHeaderView addSubview:bottomineView];

        
        _productHeaderView.frame = CGRectMake(0, CGRectGetMaxY(_flashView.frame), ScreenWidth, CGRectGetMaxY(imageContent.frame) + 10 + 20);
    
    }
    
    return _productHeaderView;
}

- (UIView *)segmentedView
{
    if (_segmentedView == nil)
    {
        _segmentedView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_productHeaderView.frame) , ScreenWidth, 40)];
        _segmentedView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *grayLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        grayLable1.backgroundColor = GrayColor;
//        [_segmentedView addSubview:grayLable1];
        UILabel *grayLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        grayLable2.backgroundColor = GrayColor;
        [_segmentedView addSubview:grayLable2];

        
        NSMutableArray *segmentedTitleArray = [NSMutableArray arrayWithObjects:@"单品详情",@"Who's SURE", nil];
        CGFloat segmentedButtonWidth = ScreenWidth / segmentedTitleArray.count;
        
        for (int i = 0; i < segmentedTitleArray.count; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(segmentedButtonWidth * i, 0, segmentedButtonWidth, CGRectGetHeight(_segmentedView.frame));
            button.tag = i + 10;
            [button addTarget:self action:@selector(switchBrandSegmentedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UIColor *color = i == 0 ? RGBA(141, 31, 203,1) : [UIColor lightGrayColor];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitle:segmentedTitleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [_segmentedView addSubview:button];
        }
    }
    return _segmentedView;
}

-(void)setUpScrollViewUI
{
    _showType = SingleProductDetaileShowTypeWebView;
    
    
    
    UIButton *collectButton = [self.bottomView viewWithTag:23];
    if (_singleProduct.isCollected)
    {
        [collectButton setImage:[UIImage imageNamed:@"SingleProduct_Collected"] forState:UIControlStateNormal];

    }
    else
    {
        [collectButton setImage:[UIImage imageNamed:@"SingleProduct_CollectNo"] forState:UIControlStateNormal];
    }
    
    
    [self.pageCollectionView addSubview:self.flashView];
    [self.pageCollectionView addSubview:self.productHeaderView];
    [self.pageCollectionView addSubview:self.segmentedView];
    
    
    // 重置控件坐标
    CGFloat y = 0;
    if (CGRectGetMaxY(self.segmentedView.frame) > 100)
    {
        y = CGRectGetMaxY(self.segmentedView.frame) + 5;
    }
    else
    {
        y = - self.flashView.frame.origin.y;
    }
    
    self.flashView.frame = CGRectMake(self.flashView.frame.origin.x, - y, CGRectGetWidth(self.flashView.frame), CGRectGetHeight(self.flashView.frame));
    self.productHeaderView.frame = CGRectMake(0, CGRectGetMaxY(self.flashView.frame), CGRectGetWidth(self.productHeaderView.frame), CGRectGetHeight(self.productHeaderView.frame));
    self.segmentedView.frame = CGRectMake(0, CGRectGetMaxY(self.productHeaderView.frame), CGRectGetWidth(self.segmentedView.frame), CGRectGetHeight(self.segmentedView.frame));
    
    
    
    _pageCollectionView.contentInset = UIEdgeInsetsMake(y, 0, 50, 0);
    _pageCollectionView.contentOffset = CGPointMake(0, -y);
    [_pageCollectionView reloadData];
}



- (void)pushStoreDetaileButtonclick
{
    BrandDetaileVC *detaileVC = [[BrandDetaileVC alloc]init];
    detaileVC.hidesBottomBarWhenPushed = YES;
    detaileVC.brandDataModel = _singleProduct.brandModel;
    [detaileVC requestNetworkGetData];
    [self.navigationController pushViewController:detaileVC animated:YES];
}

- (void)switchBrandSegmentedButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 10;
    UIView *segmentedView = sender.superview;
    
    for (UIView *view in segmentedView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [(UIButton *)view setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    
    [sender setTitleColor:RGBA(141, 31, 203,1) forState:UIControlStateNormal];
    
    
    
    switch (index)
    {
        case 0:
            //单品详情
            _showType = SingleProductDetaileShowTypeWebView;
            [_pageCollectionView reloadData];
            break;
        case 1:
            //Who's SURE
            _showType = SingleProductDetaileShowTypeSureList;
            [self requestNetWorkGetSureListData];
            break;
        default:
            break;
    }
    
    
}

- (UIView *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
        _bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        
        UILabel *grayLable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, .5f)];
        grayLable1.backgroundColor = GrayLineColor;
        [_bottomView addSubview:grayLable1];
        
        
        CGFloat buttonWidth = 50;
        
        UIButton *brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [brandButton setImageEdgeInsets:UIEdgeInsetsMake(17, 17, 17, 17)];
        [brandButton setImage:[UIImage imageNamed:@"SingleProduct_Brand"] forState:UIControlStateNormal];
        [brandButton setImage:[UIImage imageNamed:@"SingleProduct_Brand"] forState:UIControlStateHighlighted];
        [brandButton addTarget:self action:@selector(pushStoreDetaileButtonclick) forControlEvents:UIControlEventTouchUpInside];
        brandButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
        [_bottomView addSubview:brandButton];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setImage:[UIImage imageNamed:@"SingleProduct_Message"] forState:UIControlStateNormal];
        [messageButton setImage:[UIImage imageNamed:@"SingleProduct_Message"] forState:UIControlStateHighlighted];
        [messageButton addTarget:self action:@selector(lookUnReadMessageButtonclick) forControlEvents:UIControlEventTouchUpInside];
        messageButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonWidth);
        [_bottomView addSubview:messageButton];
        
        UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectionButton setImage:[UIImage imageNamed:@"SingleProduct_CollectNo"] forState:UIControlStateNormal];
        collectionButton.tag = 23;
        [collectionButton addTarget:self action:@selector(collectSingleProductButtonclick:) forControlEvents:UIControlEventTouchUpInside];
        collectionButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonWidth);
        [_bottomView addSubview:collectionButton];
        
        
        UIButton *nowBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nowBuyButton.frame = CGRectMake(ScreenWidth - 80 - 10, 7, 80, 35);
        [nowBuyButton addTarget:self action:@selector(nowBuySingleProductButtonclick) forControlEvents:UIControlEventTouchUpInside];
        [nowBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nowBuyButton.backgroundColor = RGBA(142, 31, 203,1);
        [nowBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        nowBuyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:nowBuyButton];
        
        UIButton *addCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addCarButton.frame = CGRectMake(ScreenWidth - 90 - 80 - 10, 7, 80, 35);
        [addCarButton addTarget:self action:@selector(joinBuyCareButtonclick) forControlEvents:UIControlEventTouchUpInside];
        [addCarButton setTitleColor:RGBA(142, 31, 203,1) forState:UIControlStateNormal];
        addCarButton.layer.borderWidth = 1;
        addCarButton.layer.borderColor = RGBA(142, 31, 203,1).CGColor;
        addCarButton.backgroundColor = [UIColor whiteColor];
        [addCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        addCarButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomView addSubview:addCarButton];
        
    }
    
    return _bottomView;
}

#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_showType == SingleProductDetaileShowTypeWebView)
    {
        return 1;
    }
    
    return _sureListModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == SingleProductDetaileShowTypeWebView)
    {
        NSLog(@"webView高度 ========= %f",_webViewHeight);

        return CGSizeMake(ScreenWidth, _webViewHeight);
    }
    else
    {
        
        CGFloat height = [collectionView lt_heightForCellWithIdentifier:Collection_SURE_Identifer cacheByIndexPath:indexPath configuration:^(BrandDetaileCollectionSureCell *cell)
                          {
                              SUREModel *sureModel = _sureListModelArray[indexPath.row];
                              
                              [cell updateBrandDetaileCollectionSureCellWithModel:sureModel];
                          }];
        
        NSLog(@"单元格高度 ========= %f",height);
        
        return CGSizeMake(ScreenWidth, height);
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == SingleProductDetaileShowTypeSureList)
    {
        BrandDetaileCollectionSureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_SURE_Identifer forIndexPath:indexPath];
        cell.currentViewController = self;
        if (_sureListModelArray && _sureListModelArray.count)
        {
            SUREModel *sureModel = _sureListModelArray[indexPath.row];
            
            NSLog(@"sureBody ==== %@",sureModel.sureBody);
            
            [cell updateBrandDetaileCollectionSureCellWithModel:sureModel];
        }
        return cell;
    }
    
    
    SingleProductDetaileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Collection_Cell_Identifer forIndexPath:indexPath];
    
   
    NSLog(@"HTML ===== %@",_singleProduct.productDetaileHTMLStr);

    
    [cell loadHTMLString:_singleProduct.productDetaileHTMLStr];
    cell.updateSingleCollectionCellHeight = ^(CGFloat height)
    {
        if (_webViewHeight != height)
        {
            _webViewHeight = height;
            
            
            [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        }

    };
    
    return cell;
}


#pragma mark - Bottom Button Click

- (void)takeScreenshotNotificationClick:(NSNotification *)notification
{
    
//    ShareViewController *shareVC = [[ShareViewController alloc]init];
//    shareVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:shareVC animated:NO completion:^
//     {
//         [shareVC showPlatView];
//     }];
    
    /*
     
     http://www.jianshu.com/p/1213f9f00fdd
     
     UIPasteboard是ios中访问粘贴板的原生控件，可分为系统等级的和app等级的，系统等级的独立于app，可以复制一个app的内容到另一个app；app等级的只能在app内进行复制和粘贴
     
     可以复制在粘贴板的数据类型有NSString、UIImage、NSURL、UIColor、NSData以及由这些类型元素组成的数组。可分别由它们的set方法将数据放在粘贴板中，如NSString：
     [pasteboard setString:@"复制的字符串内容"];
     
     */
    
    //+ (nullable UIPasteboard *)pasteboardWithName:(NSString *)pasteboardName create:(BOOL)create
    
    NSLog(@"%@",notification.userInfo);
    
}


- (void)lookUnReadMessageButtonclick
{
    ChatViewController *chatDetaileVC = [[ChatViewController alloc]initWithSessionId:@"76"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chatDetaileVC];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)collectSingleProductButtonclick:(UIButton *)collectButton
{
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        if (_singleProduct.isCollected == NO)//关注
        {
            AccountInfo *account = [AccountInfo standardAccountInfo];
            [collectButton setImage:[UIImage imageNamed:@"SingleProduct_Collected"] forState:UIControlStateNormal];
            collectButton.userInteractionEnabled = NO;
            
            NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_singleProduct.productIDStr,@"follow_type":@"3"};
            
            [self.httpManager attentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 collectButton.userInteractionEnabled = YES;
                 if (error)
                 {
                     NSLog(@"error.domain ===== %@",error.domain);
                 }
                 else
                 {
                     NSLog(@"成功关注");
                     _singleProduct.isCollected = YES;
                 }
             }];
        }
        else//取消关注
        {
            
            NSDictionary *dict = @{@"user_id":account.userId,@"parent_id":_singleProduct.productIDStr,@"follow_type":@"3"};
            collectButton.userInteractionEnabled = NO;
            [collectButton setImage:[UIImage imageNamed:@"SingleProduct_CollectNo"] forState:UIControlStateNormal];
            [self.httpManager cancelAttentionWithParameterDict:dict CompletionBlock:^(NSError *error)
             {
                 collectButton.userInteractionEnabled = YES;
                 if (error)
                 {
                     NSLog(@"error.domain ===== %@",error.domain);
                 }
                 else
                 {
                     NSLog(@"取消关注");
                     _singleProduct.isCollected = NO;
                 }
             }];
        }
    }
    else
    {
        [AuthorizationManager getAuthorizationWithViewController:self];
    }

}

- (void)joinBuyCareButtonclick
{
    if (self.chooseVC == nil)
    {
        self.chooseVC = [[ChooseProductSpecificationVC alloc] init];
    }
    

    if (_singleProduct.associationArray.count)
    {
        self.chooseVC.defaultAssociationModel = _singleProduct.associationArray[0];
    }
    
    self.chooseVC.singleProduct = _singleProduct;
    self.chooseVC.enterType = EnterTypeAddShoppingCar;
    __weak typeof(self)weakSelf = self;
    self.chooseVC.block = ^
    {
        NSLog(@"点击回调去购物车");
        // 下面一定要移除，不然你的控制器结构就乱了，基本逻辑层级我们已经写在上面了，这个效果其实是addChildVC来的，最后的展示是在Window上的，一定要移除
        [weakSelf.chooseVC.view removeFromSuperview];
        [weakSelf.chooseVC removeFromParentViewController];
        weakSelf.chooseVC.view = nil;
        weakSelf.chooseVC = nil;
        
    };
    
    [self.navigationController presentSemiViewController:self.chooseVC withOptions:@{KNSemiModalOptionKeys.pushParentBack:@(YES),KNSemiModalOptionKeys.animationDuration:@(0.6),KNSemiModalOptionKeys.shadowOpacity:@(0.3),KNSemiModalOptionKeys.backgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_01"]]}];


}

- (void)nowBuySingleProductButtonclick
{
    if (self.chooseVC == nil)
    {
        self.chooseVC = [[ChooseProductSpecificationVC alloc] init];
    }

    
    if (_singleProduct.associationArray.count)
    {
        self.chooseVC.defaultAssociationModel = _singleProduct.associationArray[0];
    }
    
    self.chooseVC.singleProduct = _singleProduct;
    self.chooseVC.enterType = EnterTypeNoBuy;
    __weak typeof(self)weakSelf = self;
    self.chooseVC.block = ^
    {
        
        NSLog(@"点击回调去购物车");
        // 下面一定要移除，不然你的控制器结构就乱了，基本逻辑层级我们已经写在上面了，这个效果其实是addChildVC来的，最后的展示是在Window上的，一定要移除
        [weakSelf.chooseVC.view removeFromSuperview];
        [weakSelf.chooseVC removeFromParentViewController];
        weakSelf.chooseVC.view = nil;
        weakSelf.chooseVC = nil;
        
        [weakSelf rightBtnAction];
        
    };
    
    
    NSDictionary *optionsDict = @{KNSemiModalOptionKeys.pushParentBack:@(YES),KNSemiModalOptionKeys.animationDuration:@(0.6),KNSemiModalOptionKeys.shadowOpacity:@(0.3),KNSemiModalOptionKeys.backgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_01"]]};
    
    [self.navigationController presentSemiViewController:self.chooseVC withOptions:optionsDict];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;

    CGFloat alpha = (yOffset + ScreenWidth) / ScreenWidth;
    
    
    UIImageView *navBarImageView = [_navBarView viewWithTag:1];
    UIButton *leftNavBarButton = [_navBarView viewWithTag:2];
    UIButton *shareNavBarButton = [_navBarView viewWithTag:3];
    UIButton *carNavBarButton = [_navBarView viewWithTag:4];
    
    navBarImageView.alpha = alpha;

    if (alpha < .5f)
    {
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back"] forState:UIControlStateNormal];
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back_Pressed"] forState:UIControlStateHighlighted];
        
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_Share"] forState:UIControlStateNormal];
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_SharePressed"] forState:UIControlStateHighlighted];
        
        
        [carNavBarButton setImage:[UIImage imageNamed:@"navBar_Car"] forState:UIControlStateNormal];
        [carNavBarButton setImage:[UIImage imageNamed:@"navBar_CarPressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton"] forState:UIControlStateNormal];
        [leftNavBarButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Pressed"] forState:UIControlStateHighlighted];
        
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_ShareBack"] forState:UIControlStateNormal];
        [shareNavBarButton setImage:[UIImage imageNamed:@"navBar_ShareBack"] forState:UIControlStateHighlighted];
        
        [carNavBarButton setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        [carNavBarButton setImage:[UIImage imageNamed:@"shopCar_Pressed"] forState:UIControlStateHighlighted];
    }



    if (yOffset <= (CGRectGetMaxY(_productHeaderView.frame) - 64))
    {
        _segmentedView.frame = CGRectMake(0, CGRectGetMaxY(_productHeaderView.frame), ScreenWidth, 40);
    }
    else
    {
        _segmentedView.frame = CGRectMake(0, yOffset + 64, ScreenWidth, 40);
    }

}


#pragma mark -  Other Method

- (CGRect)boundingRectWithString:(NSString  *)string Font:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName : font} ;
    CGRect  rect = [string boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect;
}

#pragma mark - Request Data

- (void)requestNetworkGetData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *goodID = nil;
    
    if (_singleProduct && self.goodIDString == nil)
    {
        goodID = _singleProduct.productIDStr;
    }
    else
    {
        goodID = _goodIDString;
    }
    
    NSString *uID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        uID = account.userId;
    }

    NSDictionary *parametersDict = @{@"goods_id":goodID,@"user_id":uID};

    
    [self.httpManager getSingleProductDataWithParameterDict:parametersDict CompletionBlock:^(ProductModel *product, NSError *error)
    {
        [hud hide:YES];
        
        if (!error)
        {
            _singleProduct = product;
            [self setUpScrollViewUI];
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

    
    NSDictionary *dict = @{@"sure_id":@"",@"goods_id":_singleProduct.productIDStr,@"brand_id":@"",@"sure_type":@"goods",@"user_id":uID,@"cur_page":@"1",@"cur_size":@"5"};

    
    [self.httpManager getBrandOrCommoditySureListWithParameterDict:dict CompletionBlock:^(NSMutableArray *sureListArray, NSError *error)
     {
         if (sureListArray)
         {
             _sureListModelArray = sureListArray;
             NSLog(@"SURE数量 ===== %ld",_sureListModelArray.count);
             
             [_pageCollectionView reloadData];
         }
         else
         {
             
         }
     }];
}


@end
