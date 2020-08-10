//
//  PublicBarcodeVC.m
//  SURE
//
//  Created by 王玉龙 on 17/2/10.
//  Copyright © 2017年 longlong. All rights reserved.
//

#import "PublicBarcodeVC.h"

#import "CreatBarcode.h"
#import "ScanLifeViewController.h"

#import "HandleResultView.h"

@interface PublicBarcodeVC ()
{
    __weak IBOutlet UIImageView *_barCodeImageView;
}
@end

@implementation PublicBarcodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavBar];
    
    
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesClick:)];
    longPressGes.minimumPressDuration = 0.5f;
    [self.view addGestureRecognizer:longPressGes];
    
    
    if ([AuthorizationManager isAuthorization])
    {
        AccountInfo *account = [AccountInfo standardAccountInfo];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:account.headimg] placeholderImage:[UIImage imageNamed:@"aboutMySelf"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
        {
            NSLog(@"error ===== %@",error);
            
            
            if (error)
            {
                
            }
            else
            {
                NSString *string = [NSString stringWithFormat:@"%@ 的SURE ID 是 %@",account.nickname,account.userId];
                _barCodeImageView.image = [CreatBarcode creatLogoScanLifeWithDataString:string LogoImage:imageView.image LogoScaleToSuperView:0.25];
            }
            
        }];
        
        
        NSString *string = [NSString stringWithFormat:@"%@ 的SURE ID 是 %@",account.nickname,account.userId];
        _barCodeImageView.image = [CreatBarcode creatLogoScanLifeWithDataString:string LogoImage:imageView.image LogoScaleToSuperView:0.25];
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
    
    self.navigationItem.title = @"我的二维码";
    
    LeftBackItem *leftBarItem = [[LeftBackItem alloc] initWithTarget:self Selector:@selector(leftBtnAction)];
    self.navigationItem.leftBarButtonItem=leftBarItem;
    
    
    UIButton *barcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barcodeButton setImage:[UIImage imageNamed:@"navBar_BarCode"] forState:UIControlStateNormal];
    [barcodeButton addTarget:self action:@selector(barcodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    barcodeButton.adjustsImageWhenHighlighted = NO;
    barcodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    barcodeButton.frame = CGRectMake(0, 0, 44, 44);
    
    
    UIBarButtonItem *barCodeItem = [[UIBarButtonItem alloc]initWithCustomView:barcodeButton];
    self.navigationItem.rightBarButtonItem = barCodeItem;
}

-(void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)barcodeButtonClick
{
    ScanLifeViewController *scanVC = [[ScanLifeViewController alloc]init];
    scanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)longPressGesClick:(UILongPressGestureRecognizer *)longPressGes
{
    
    if (longPressGes.state == UIGestureRecognizerStateBegan)
    {
        
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak __typeof__(self) weakSelf = self;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
        
        
        UIImage *image = [self captureScreen];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

        }];
        
        
        [actionSheet addAction:cancelAction];
        [actionSheet addAction:saveAction];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else
    {
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error)
    {
        msg = @"保存图片失败";
        
        [[[HandleResultView alloc]initWithIsFinish:NO Title:@"保存失败"] showToSuperView:self.view];
    }
    else
    {
        msg = @"保存图片成功" ;
        [[[HandleResultView alloc]initWithIsFinish:YES Title:@"已保存至本地相册"] showToSuperView:self.view];
    }
    
    
    
    NSLog(@"保存结果 ======  %@",msg);
}


- (UIImage *)finishCroppingImage
{
    
    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);

    
    CGImageRef imageRef = CGImageCreateWithImageInRect([[_barCodeImageView image] CGImage], rect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    
    return croppedImage;
}

- (UIImage*)captureScreen
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth, ScreenHeight - 64), NO, 3.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

@end
