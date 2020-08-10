//
//  BrandViewController.m
//  SURE
//
//  Created by 王玉龙 on 16/10/9.
//  Copyright © 2016年 longlong. All rights reserved.
//


#define CardWidth (ScreenWidth - 40.0)
#define CardHeight CardWidth


#import "BrandViewController.h"
#import "iCarousel.h"
#import "UIImage+Extend.h"
#import "BrandListButton.h"
#import "BrandDetaileVC.h"

@interface BrandViewController ()

<iCarouselDataSource, iCarouselDelegate,UINavigationControllerDelegate>

{
    iCarousel *_cardView;
    NSMutableArray *_brandArray;
}

@property (nonatomic ,strong) UIImageView *backImageView;

@end

@implementation BrandViewController

- (void)dealloc
{
    _cardView.delegate = nil;
    _cardView.dataSource = nil;
}

- (UIImageView *)backImageView
{
    if (_backImageView == nil)
    {
        _backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"brandBack"]];
        _backImageView.alpha = .9f;
        _backImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49);
    }
    
    return _backImageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    [self.view addSubview:self.backImageView];
    
    self.view.backgroundColor = RGBA(235, 236, 236,1);
    self.navigationController.navigationBar.hidden = YES;

    
    
    _cardView = [[iCarousel alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49 - 30)];
    _cardView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cardView];
    
    _cardView.clipsToBounds = YES;
    _cardView.delegate = self;
    _cardView.dataSource = self;
    _cardView.type = iCarouselTypeCoverFlow;
    _cardView.vertical = YES;
    _cardView.bounces = NO;
    _cardView.scrollToItemBoundary = YES;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_brandArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIImageView *imageView = nil;
    BrandListButton *button = nil;
    
    CGFloat lableHeight = 40.0;
    
    if (view == nil)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight + lableHeight)];
        view.clipsToBounds = YES;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, CardHeight)];
        imageView.tag = 2;
        imageView.clipsToBounds = YES;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CardHeight - 1, CardWidth, lableHeight + 2)];
        bottomImageView.image = [UIImage imageNamed:@"navBar"];
        [view addSubview:bottomImageView];
//        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, CardHeight, CardWidth - 20, lableHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.tag = 1;
        [view addSubview:label];
        
        
        
        button = [BrandListButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(brandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = view.bounds;
        button.tag = 3;
        [view addSubview:button];
        
    }
    else
    {
        label = (UILabel *)[view viewWithTag:1];
        imageView = (UIImageView *)[view viewWithTag:2];
        button = (BrandListButton *)[view viewWithTag:3];
    }
    
    
    
    if (_brandArray)
    {
        BrandDetaileModel *brand = _brandArray[index];
        label.text = [NSString stringWithFormat:@"%@",brand.listNameStr];
        button.brandModel = brand;
        button.index = index;
        [imageView sd_setImageWithURL:[NSURL URLWithString:brand.listLogoUrlStr] placeholderImage:[UIImage imageNamed:@"placeholderImage"] ];

        NSLog(@"%@",brand.brandNameStr);
    }


    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    else if (option == iCarouselOptionWrap)
    {
        return 1;
    }
    /*
    
        case iCarouselOptionTilt:
            {
                return _tiltSlider.value;
            }
        case iCarouselOptionSpacing:
            {
                return value * _spacingSlider.value;
            }
    */
    return value;
}

- (void)brandButtonClick:(BrandListButton *)button
{
    BrandDetaileVC *detaileVC = [[BrandDetaileVC alloc]init];
    detaileVC.hidesBottomBarWhenPushed = YES;
    detaileVC.brandDataModel = button.brandModel;
    [detaileVC requestNetworkGetData];
    [self.navigationController pushViewController:detaileVC animated:YES];
}



#pragma mark -  requestData

- (void)requestNetworkGetData
{
    NSString *uID = @"";
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        uID = account.userId;
    }
    
    
    NSDictionary *parDict = @{@"cur_page":@"1",@"cur_size":@"200",@"user_id":uID};
    
    [self.httpManager getBrandListDataWithParametersDict:parDict CompletionBlock:^(NSMutableArray<BrandDetaileModel *> *brandModelArray, NSError *error)
    {
        if (error)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"错误提示" message:error.domain preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"了解了" style:UIAlertActionStyleDefault handler:nil];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else
        {
            _brandArray = brandModelArray;
            [_cardView reloadData];
        }
        
    }];
}

@end
